# pet_keeper_lite

Um aplicativo Flutter leve para gerenciar informações de pets. Este repositório contém o código do app Flutter e funções do Firebase usadas pelo projeto.

## Visão geral

`pet_keeper_lite` é uma aplicação móvel construída com Flutter que demonstra integração com Firebase (autenticação, firestore, funções em nuvem e storage). O objetivo é servir como um projeto exemplo/poço de protótipo para gerenciar dados de animais de estimação.

Principais componentes:

- App Flutter em `lib/` — interface e lógica do cliente.
- Funções Firebase em `functions/functions/` — lógica do servidor (Cloud Functions).
- Configurações e recursos Android em `app/android/`.

## Tecnologias

- Flutter & Dart
- Firebase (Auth, Firestore, Functions, Storage)
- Node.js (para as Cloud Functions)

## Requisitos

- Flutter SDK (3.35.0+) e ferramentas associadas (Android SDK para builds Android)
- Node.js & npm (para funções Firebase)
- Firebase CLI (para deploy e emulação local)

## Instalação e configuração local

1. Clone o repositório:

   git clone https://github.com/toshiossada/pet_keeper_lite.git
   cd pet_keeper_lite

2. Instale dependências Flutter (no diretório raiz do app):

   cd app
   flutter pub get

3. Instale dependências das Cloud Functions:

   cd ../functions/functions
   npm install

4. Configure as credenciais do Firebase (se necessário):

- O arquivo `app/app/google-services.json` já existe para Android; confirme se ele está correto para seu projeto Firebase.
- Para trabalhar com emuladores, instale e inicialize o Firebase CLI e configure `firebase.json` conforme necessário.

## Como executar

- Executar o app em modo debug (diretório `app`):

  flutter run

- Executar testes do Flutter:

  flutter test

- Executar/depurar as Cloud Functions localmente (diretório `functions/functions`):

  # inicia emulador (se desejar emular Firestore, Auth, Functions, etc.)

  firebase emulators:start

  # ou para deploy das funções

  firebase deploy --only functions

Nota: ajuste o caminho ao CLI `firebase` se necessário e entre nas pastas corretas antes de rodar os comandos.

## Estrutura do projeto (visão rápida)

- `app/` — código fonte do Flutter (contém `lib/`, `android/`, `pubspec.yaml`, etc.)
  - `lib/` — código Dart do aplicativo
  - `lib/src/` — módulos e widgets do app
- `functions/` — código e configurações do Firebase Functions
  - `functions/functions/index.js` — ponto de entrada das funções
- `assets/`, `img/` — imagens e recursos estáticos

---

## Passo a passo de setup (Firebase, google-services.json / GoogleService-Info.plist, FCM e emuladores)

1. Crie um projeto no Firebase Console: [Firebase Console](https://console.firebase.google.com/)

2. Registre os apps:

   - Android: adicione um app Android com o pacote (applicationId) do seu app. Ao final do registro faça o download do `google-services.json`.
     - Coloque o arquivo em: `app/android/app/google-services.json` (caminho relativo ao diretório raiz deste repositório).
   - iOS (opcional): adicione um app iOS e faça o download do `GoogleService-Info.plist`.
     - Coloque o arquivo em: `app/ios/Runner/GoogleService-Info.plist` (quando houver o diretório iOS no projeto).

3. Ative os serviços necessários no Console do Firebase:

   - Authentication (ex.: Email/Password). Ajuste regras se for usar autenticação anônima ou providers sociais.
   - Firestore (modo de produção: ajuste regras de segurança; para desenvolvimento, você pode usar regras abertas temporariamente).
   - Cloud Messaging (FCM) — usado para notificações push.

4. Configurar Cloud Messaging (básico):

   - No Console Firebase, abra Cloud Messaging e verifique se a configuração do app aparece corretamente.
   - Para enviar mensagens de teste, use o painel "Enviar sua primeira mensagem" ou utilize um endpoint HTTP v1/curl com credenciais do servidor (não commit suas chaves).

5. Emuladores locais (recomendado para desenvolvimento):

   - Instale o Firebase CLI e faça login: `npm install -g firebase-tools` e `firebase login`.
   - No diretório `app` (ou onde estiver seu `firebase.json`/`.firebaserc`), inicialize emuladores (se ainda não): `firebase init emulators` e selecione Firestore, Authentication, Functions (conforme necessário).
   - Inicie os emuladores:

     firebase emulators:start --only firestore,auth,functions

   - Para conectar o app Flutter aos emuladores, use os endpoints/variáveis fornecidos pelo emulador ou configure o SDK no app para apontar para `localhost` (consulte a documentação do Firebase para Flutter sobre `useEmulator`).

## Comandos úteis

- Instalar dependências Flutter (pasta `app`):

  cd app
  flutter pub get

- Executar o app (aparelho ou emulador Android) — a partir da pasta `app`:

  flutter run

- Rodar testes Flutter (a partir da pasta `app`):

  flutter test

- Instalar dependências das Cloud Functions (pasta `functions/functions`):

  cd functions/functions
  npm install

- Iniciar emuladores Firebase (a partir do diretório que contém `firebase.json` — neste repo há um `functions/` com `firebase.json`):

  firebase emulators:start --only firestore,auth,functions

- Deploy opcional das funções para o Firebase (a partir de `functions/functions` ou onde estiver seu `firebase.json` configurado):

  firebase deploy --only functions

Observação: execute os comandos na pasta correta e verifique se está autenticado no Firebase CLI (`firebase login`).

## Vídeo de demonstração

O vídeo curto (≤8 minutos) demonstra os 4 fluxos principais de UX e as notificações do app. Assista em:

[Demo: fluxos e notificações](assets/demo.mp4)

Fluxos cobertos no vídeo:

- Autenticação / onboarding
- Cadastro de um novo pet
- Edição / visualização de detalhes do pet
- Recebimento de notificação push (ex.: aviso criado pelo back-end)

## Como usei o Gemini

Durante o desenvolvimento usei o Gemini (modelo de geração de código) para acelerar protótipos e obter ideias iniciais de implementação. Abaixo estão 3 prompts reais (exemplos) que usei e uma breve explicação do que precisei refatorar manualmente e por quê.

Prompts usados

1. "Gere um widget Flutter que mostre uma lista paginada de pets usando Firestore com StreamBuilder, carregamento incremental e tratamento de erros. Inclua exemplos de teste unitário para o componente de listagem."

2. "Escreva uma Cloud Function em Node.js que escute criações na coleção `pets` do Firestore e envie uma notificação FCM para um tópico `new-pet` com o título e a foto do pet."

3. "Crie um serviço Dart para encapsular as chamadas ao Firestore (CRUD) com injeção de dependência para permitir mocks em testes unitários."

Por que ajustei manualmente (segurança, performance, testes)

- Segurança: o código gerado frequentemente não validou corretamente as permissões do usuário nem as entradas do cliente. Eu acrescentei verificações de autorização nas Cloud Functions e validei/sanitizei dados antes de escrever no Firestore para evitar gravações inválidas ou exposição de dados.

- Performance: a geração inicial usou patterns simples que causavam rebuilds e leituras excessivas do Firestore. Refatorei os widgets para usar `const` quando possível, `ListView.builder` com itens lazily built, e adotei paginação/limit+startAfter para evitar buscas completas em coleções grandes.

- Testabilidade: o código gerado misturava lógica de UI e acesso a dados. Separei responsabilidades criando um serviço/repositório (classe Dart) com injeção de dependência para permitir mocks nos testes. Também adicionei testes unitários para as camadas de serviço e testes widget para os componentes principais.

### Exemplos de uso do prompt de teste (arquivo `app/prompt_test.md`)

Abaixo há 3 exemplos práticos de como usar o prompt de teste presente em `app/prompt_test.md`. Cada exemplo mostra: (1) o trecho de código de entrada que você envia ao prompt, (2) o prompt wrapper curto que usa as regras do arquivo, e (3) o tipo de saída esperada e os ajustes manuais comuns.

Exemplo 1 — Unit test (classe Dart simples)

Entrada (trecho de código):

```dart
class Counter {
  int value = 0;
  void increment() => value++;
}
```

Prompt wrapper (resumido):

"Use o prompt de teste (app/prompt_test.md). Gere testes unitários em Português para a classe `Counter` seguindo o padrão Dado/Quando/Então. Inclua casos de borda (valor inicial e múltiplos incrementos)."

Saída esperada (descrição):

- Grupo de Unit Test para `Counter` com testes que seguem Dado/Quando/Então; asserts sobre `value` após chamadas a `increment()`.

Ajustes manuais comuns:

- Adicionar imports (por exemplo, `package:flutter_test/flutter_test.dart`).
- Garantir nomes de pacotes corretos para imports (usar `package:seu_app/...`).

Exemplo 2 — Widget test (formulário simples)

Entrada (trecho de código do widget):

```dart
class PetForm extends StatelessWidget {
  final void Function(String) onSave;
  const PetForm({required this.onSave, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(key: Key('name')),
        ElevatedButton(onPressed: () { onSave('Rex'); }, child: Text('Salvar')),
      ],
    );
  }
}
```
