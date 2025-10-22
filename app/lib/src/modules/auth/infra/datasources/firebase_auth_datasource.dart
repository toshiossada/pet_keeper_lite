import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/auth_user_model.dart';
import '../repositories/datasources/auth_datasource.dart';

class FirebaseAuthDataSource implements AuthDataSource {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthDataSource()
    : _auth = FirebaseAuth.instance,
      _googleSignIn = GoogleSignIn();

  @override
  Future<AuthUserModel> signInWithEmail(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = cred.user!;

    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

    final token = await FirebaseMessaging.instance.getToken();
    if (token != null && token.isNotEmpty) {
      await docRef.set({
        'fcmTokens': FieldValue.arrayUnion([token]),
      }, SetOptions(merge: true));
    }

    // Read the latest user document (may have been updated above)
    final updated = await docRef.get();
    final data = Map<String, dynamic>.from(updated.data() ?? {});
    data['id'] = user.uid;
    data['email'] = user.email ?? '';
    return AuthUserModel.fromJson(data);
  }

  @override
  Future<AuthUserModel?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCred = await _auth.signInWithCredential(credential);
    final user = userCred.user!;
    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

    final token = await FirebaseMessaging.instance.getToken();
    if (token != null && token.isNotEmpty) {
      await docRef.set({
        'fcmTokens': FieldValue.arrayUnion([token]),
      }, SetOptions(merge: true));
    }

    final updated = await docRef.get();
    final data = Map<String, dynamic>.from(updated.data() ?? {});
    data['id'] = user.uid;
    data['email'] = user.email ?? '';
    return AuthUserModel.fromJson(data);
  }

  @override
  Future<AuthUserModel> signUp(
    AuthUserModel user,
    String password,
  ) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: user.email,
      password: password,
    );
    final created = cred.user!;

    final userDoc = user.toJson();

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(created.uid);
    await docRef.set(userDoc);

    final returned = Map<String, dynamic>.from(userDoc);
    returned['id'] = created.uid;
    returned['email'] = user.email;
    return AuthUserModel.fromJson(returned);
  }

  @override
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } finally {
      await _auth.signOut();
    }
  }
}
