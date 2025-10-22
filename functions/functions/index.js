/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const functions = require("firebase-functions");
// using functions.setGlobalOptions() guarded below
const {onCall} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

const admin = require("firebase-admin");
try {
  admin.initializeApp();
} catch (e) {
  /* already initialized */
}
const db = admin.firestore();
const messaging = admin.messaging();

// For cost control, you can set the maximum number of containers that can be
// running at the same time. This helps mitigate the impact of unexpected
// traffic spikes by instead downgrading performance. This limit is a
// per-function limit. You can override the limit for each function using the
// `maxInstances` option in the function's options, e.g.
// `onRequest({ maxInstances: 5 }, (req, res) => { ... })`.
// NOTE: setGlobalOptions does not apply to functions using the v1 API. V1
// functions should each use functions.runWith({ maxInstances: 10 }) instead.
// In the v1 API, each function can only serve one request per container, so
// this will be the maximum concurrent request count.
if (typeof functions.setGlobalOptions === "function") {
  functions.setGlobalOptions({maxInstances: 10});
}

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

/**
 * notifyFamily callable
 * - input: { petId: string, message: string }
 * - flow: read pets/{petId} -> get familyCode -> query users where
 *         familyCode == value, collect fcmTokens from user docs and send
 *         FCM to all tokens
 */
exports.notifyFamily = onCall(async (req) => {
  const data = req.data || {};
  const petId = data.petId;
  const message = data.message;

  // Validate
  if (!petId || typeof petId !== "string") {
    throw new functions.https.HttpsError(
        "invalid-argument",
        "Missing or invalid petId",
    );
  }
  if (!message || typeof message !== "string") {
    throw new functions.https.HttpsError(
        "invalid-argument",
        "Missing or invalid message",
    );
  }

  try {
    const petRef = db.collection("pets").doc(petId);
    const petSnap = await petRef.get();
    if (!petSnap.exists) {
      throw new functions.https.HttpsError("not-found", "Pet not found");
    }
    const petData = petSnap.data() || {};
    const familyCode = petData.familyCode;
    if (!familyCode) {
      throw new functions.https.HttpsError(
          "failed-precondition",
          "Pet has no familyCode",
      );
    }

    const usersQuery = await db
        .collection("users")
        .where("familyCode", "==", familyCode)
        .get();
    if (usersQuery.empty) {
      return {
        success: true,
        message: "Notificações enviadas com sucesso.",
        totalTokens: 0,
      };
    }

    const tokens = [];
    usersQuery.forEach((u) => {
      const d = u.data() || {};
      if (Array.isArray(d.fcmTokens)) {
        tokens.push(...d.fcmTokens.filter((t) => typeof t === "string" && t));
      }
    });

    const uniqTokens = Array.from(new Set(tokens));
    if (uniqTokens.length === 0) {
      return {
        success: true,
        message: "Notificações enviadas com sucesso.",
        totalTokens: 0,
      };
    }

    const notification = {title: "Notificação da família", body: message};
    const dataPayload = {petId};

    const BATCH = 500;
    const failures = [];

    for (let i = 0; i < uniqTokens.length; i += BATCH) {
      const batchTokens = uniqTokens.slice(i, i + BATCH);
      const multicast = {
        tokens: batchTokens,
        notification,
        data: dataPayload,
      };
      const resp = await messaging.sendEachForMulticast(multicast);
      if (resp.failureCount && resp.responses) {
        resp.responses.forEach((r, idx) => {
          if (!r.success) {
            failures.push({
              token: batchTokens[idx],
              error:
                r.error && r.error.message ? r.error.message : String(r.error),
            });
          }
        });
      }
    }

    const result = {
      success: true,
      message: "Notificações enviadas com sucesso.",
      totalTokens: uniqTokens.length,
    };
    if (failures.length) result.failures = failures;
    return result;
  } catch (err) {
    logger.error("notifyFamily error", err);
    if (err instanceof functions.https.HttpsError) throw err;
    throw new functions.https.HttpsError(
        "internal",
        err.message || String(err),
    );
  }
});
