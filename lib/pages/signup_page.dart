import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _email = TextEditingController();
  final _pwd = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  void _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final ok = await AuthService.instance.register(_email.text.trim(), _pwd.text);
    setState(() => _loading = false);
    if (ok) Navigator.of(context).pop(true);
    else {
      showDialog(context: context, builder: (_) => AlertDialog(
        title: const Text('Erreur'),
        content: const Text('Email déjà utilisé'),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK'))],
      ));
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _pwd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inscription')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _email, decoration: const InputDecoration(labelText: 'Email'), validator: (v)=> v==null||!v.contains('@') ? 'Email invalide' : null),
              const SizedBox(height: 12),
              TextFormField(controller: _pwd, decoration: const InputDecoration(labelText: 'Mot de passe'), obscureText: true, validator: (v)=> v==null||v.length<4 ? '4 chars min' : null),
              const SizedBox(height: 20),
              _loading ? const CircularProgressIndicator() : ElevatedButton(onPressed: _register, child: const Text('S\'inscrire')),
            ],
          ),
        ),
      ),
    );
  }
}
