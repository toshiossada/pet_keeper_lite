String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) return 'Informe o email';

  final email = value.trim();
  // Simples regex para validação básica de email
  final regex = RegExp(r'^[a-zA-Z0-9.+_-]+@[a-zA-Z0-9._-]+\.[a-zA-Z]{2,}');
  if (!regex.hasMatch(email)) return 'Email inválido';

  return null;
}
