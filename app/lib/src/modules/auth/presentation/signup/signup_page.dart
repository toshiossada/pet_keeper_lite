import 'package:flutter/material.dart';

import '../../../../shared/validators/email_validator.dart';
import 'controllers/signup_controller.dart';
import 'stores/signup_state.dart';

class SignUpPage extends StatefulWidget {
  final SignUpController controller;
  const SignUpPage({required this.controller, super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _familyCtrl = TextEditingController();

  SignUpController get _controller => widget.controller;

  @override
  void initState() {
    super.initState();
    _controller.store.addListener(() {
      final state = _controller.store.state;
      if (state is SignUpError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message)),
        );
      }

      if (state is SignUpSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cadastro realizado com sucesso!')),
        );
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _nameCtrl.dispose();
    _familyCtrl.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await _controller.signUp(
      _emailCtrl.text.trim(),
      _passCtrl.text,
      _nameCtrl.text.trim(),
      familyCode: _familyCtrl.text.trim().isEmpty
          ? null
          : _familyCtrl.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(labelText: 'Nome'),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Informe o nome' : null,
                    ),
                    TextFormField(
                      controller: _familyCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Código da família (opcional)',
                      ),
                    ),
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: validateEmail,
                    ),
                    TextFormField(
                      controller: _passCtrl,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Senha'),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Informe a senha' : null,
                    ),
                    const SizedBox(height: 12),
                    ListenableBuilder(
                      listenable: _controller.store,
                      builder: (context, _) {
                        final isLoading =
                            _controller.store.state is SignUpLoading;

                        return ElevatedButton(
                          onPressed: isLoading ? null : _signUp,
                          child: isLoading
                              ? const CircularProgressIndicator()
                              : const Text('Cadastrar'),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
