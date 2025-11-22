import 'package:flutter/material.dart';
import '../models/contact.dart';

class AddContactPage extends StatefulWidget {
  final Contact? contact;
  const AddContactPage({Key? key, this.contact}) : super(key: key);

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  late AnimationController _animController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.contact?.name ?? '');
    _email = TextEditingController(text: widget.contact?.email ?? '');
    _phone = TextEditingController(text: widget.contact?.phone ?? '');
    _animController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _animController.forward();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 800));
    
    final c = Contact(name: _name.text.trim(), email: _email.text.trim(), phone: _phone.text.trim());
    Navigator.of(context).pop(c);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.contact != null;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom AppBar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEdit ? 'Modifier le contact' : 'Ajouter un contact',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            isEdit ? 'Mettez à jour les informations' : 'Entrez les détails du nouveau contact',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Form Container
              Expanded(
                child: FadeTransition(
                  opacity: _animController,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Avatar
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E3C72).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  _name.text.isNotEmpty ? _name.text[0].toUpperCase() : '?',
                                  style: const TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E3C72),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Name Field
                            Text(
                              'Nom complet',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1E3C72),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _name,
                              onChanged: (value) => setState(() {}),
                              decoration: InputDecoration(
                                hintText: 'Ex: Ahmed Ben Ali',
                                prefixIcon: const Icon(Icons.person, color: Color(0xFF1E3C72)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFF1E3C72), width: 2),
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF5F5F5),
                              ),
                              validator: (v) => v == null || v.trim().isEmpty ? 'Le nom est requis' : null,
                            ),
                            const SizedBox(height: 20),

                            // Email Field
                            Text(
                              'Adresse email',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1E3C72),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _email,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: 'exemple@email.com',
                                prefixIcon: const Icon(Icons.email, color: Color(0xFF1E3C72)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFF1E3C72), width: 2),
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF5F5F5),
                              ),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) return 'L\'email est requis';
                                if (!v.contains('@')) return 'Veuillez entrer un email valide';
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // Phone Field
                            Text(
                              'Numéro de téléphone',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1E3C72),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _phone,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintText: '+216 XX XXX XXX',
                                prefixIcon: const Icon(Icons.phone, color: Color(0xFF1E3C72)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFF1E3C72), width: 2),
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF5F5F5),
                              ),
                              validator: (v) => v == null || v.trim().isEmpty ? 'Le numéro est requis' : null,
                            ),
                            const SizedBox(height: 28),

                            // Save Button
                            _saving
                                ? Container(
                                    width: double.infinity,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1E3C72),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Center(
                                      child: SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          strokeWidth: 3,
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: _save,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF1E3C72),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        elevation: 5,
                                      ),
                                      child: Text(
                                        isEdit ? 'Enregistrer les modifications' : 'Ajouter le contact',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 12),

                            // Cancel Button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: OutlinedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFF1E3C72), width: 2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Annuler',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E3C72),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
