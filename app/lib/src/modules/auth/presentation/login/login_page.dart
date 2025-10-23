import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'controllers/auth_controller.dart';
import 'stores/auth_state.dart';

class LoginPage extends StatefulWidget {
  final AuthController controller;
  const LoginPage({
    required this.controller,
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  AuthController get _controller => widget.controller;

  @override
  void initState() {
    super.initState();

    _controller.store.addListener(() {
      final state = _controller.store.state;
      if (state is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message)),
        );
      }
    });
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _signInEmail() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await _controller.signInWithEmail(_emailCtrl.text.trim(), _passCtrl.text);
  }

  Future<void> _signInGoogle() async {
    await _controller.signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Entrar')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListenableBuilder(
                  listenable: _controller.store,
                  builder: (context, _) {
                    final state = _controller.store.state;
                    if (state is AuthLoading) {
                      return const SizedBox(
                        height: 120,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    return _LoginForm(
                      formKey: _formKey,
                      emailCtrl: _emailCtrl,
                      passCtrl: _passCtrl,
                      signInEmail: _signInEmail,
                      signInGoogle: _signInGoogle,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  final Key formKey;
  final TextEditingController emailCtrl;
  final TextEditingController passCtrl;
  final VoidCallback signInEmail;
  final VoidCallback signInGoogle;

  const _LoginForm({
    required this.formKey,
    required this.emailCtrl,
    required this.passCtrl,
    required this.signInEmail,
    required this.signInGoogle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: emailCtrl,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: 'Email'),
          validator: (v) => (v == null || v.isEmpty) ? 'Informe o email' : null,
        ),
        TextFormField(
          controller: passCtrl,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Senha'),
          validator: (v) => (v == null || v.isEmpty) ? 'Informe a senha' : null,
        ),
        const SizedBox(height: 12),
        ElevatedButton(onPressed: signInEmail, child: const Text('Entrar')),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          icon: const Icon(Icons.login, size: 20, color: Colors.red),
          label: const Text('Entrar com Google'),
          onPressed: signInGoogle,
        ),
        OutlinedButton.icon(
          icon: const Icon(Icons.login, size: 20, color: Colors.red),
          label: const Text('Sign Up'),
          onPressed: () {
            Modular.to.pushNamed('/auth/signup');
          },
        ),
      ],
    );
  }
}
