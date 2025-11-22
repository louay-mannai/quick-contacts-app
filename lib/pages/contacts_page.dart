import 'package:flutter/material.dart';
import '../models/contact.dart';
import 'add_contact_page.dart';
import 'chat_page.dart';
import '../services/contact_storage.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> with SingleTickerProviderStateMixin {
  List<Contact> contacts = [];
  List<Contact> filteredContacts = [];
  final _searchCtrl = TextEditingController();
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _animController.forward();
    _loadContacts();
    _searchCtrl.addListener(_search);
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_search);
    _searchCtrl.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _loadContacts() async {
    final loaded = await ContactStorage.loadContacts();
    setState(() {
      contacts = loaded;
      filteredContacts = List.from(loaded);
    });
  }

  void _search() {
    final q = _searchCtrl.text.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        filteredContacts = List.from(contacts);
      } else {
        filteredContacts = contacts.where((c) => c.name.toLowerCase().contains(q)).toList();
      }
    });
  }

  Future<void> _handleAdd() async {
    final newContact = await Navigator.of(context).push<Contact>(
      MaterialPageRoute(builder: (_) => const AddContactPage()),
    );
    if (newContact != null) {
      final exists = contacts.any((c) => c.email == newContact.email);
      if (exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Contact avec cet email existe déjà'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      setState(() {
        contacts.add(newContact);
      });
      await ContactStorage.saveContacts(contacts);
      _search();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contact ajouté avec succès'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _handleEdit(Contact original) async {
    final edited = await Navigator.of(context).push<Contact>(
      MaterialPageRoute(builder: (_) => AddContactPage(contact: original)),
    );
    if (edited != null) {
      final index = contacts.indexWhere((c) => c.email == original.email);
      if (index != -1) {
        setState(() {
          contacts[index] = edited;
        });
        await ContactStorage.saveContacts(contacts);
        _search();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Contact mis à jour'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _handleDelete(Contact c) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Supprimer'),
        content: Text('Êtes-vous sûr de vouloir supprimer ${c.name} ?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Non')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Oui', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirmed ?? false) {
      setState(() => contacts.removeWhere((x) => x.email == c.email));
      await ContactStorage.saveContacts(contacts);
      _search();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contact supprimé'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildContactCard(Contact c) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.grey.shade50],
            ),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top section: Avatar + Name
                Row(
                  children: [
                    // Avatar with gradient background
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF1E3C72).withOpacity(0.9),
                            const Color(0xFF2A5298).withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1E3C72).withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        c.name.isNotEmpty ? c.name[0].toUpperCase() : '?',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Name
                    Expanded(
                      child: Text(
                        c.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3C72),
                          letterSpacing: 0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                // Middle section: Email and Phone
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Email
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(Icons.email, size: 12, color: Colors.blue),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            c.email,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Phone
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(Icons.phone, size: 12, color: Colors.green),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            c.phone,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Bottom section: Action Buttons (4 in a row)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Chat Button
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => ChatPage(contact: c)),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.purple.withOpacity(0.3)),
                        ),
                        child: const Icon(Icons.chat, color: Colors.purple, size: 16),
                      ),
                    ),
                    // Edit Button
                    GestureDetector(
                      onTap: () => _handleEdit(c),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.blue.withOpacity(0.3)),
                        ),
                        child: const Icon(Icons.edit, color: Colors.blue, size: 16),
                      ),
                    ),
                    // Call Button
                    GestureDetector(
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Appel à ${c.phone} (non implémenté)'),
                          duration: const Duration(seconds: 2),
                          backgroundColor: Colors.green.withOpacity(0.8),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.green.withOpacity(0.3)),
                        ),
                        child: const Icon(Icons.call, color: Colors.green, size: 16),
                      ),
                    ),
                    // Delete Button
                    GestureDetector(
                      onTap: () => _handleDelete(c),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.red.withOpacity(0.3)),
                        ),
                        child: const Icon(Icons.delete, color: Colors.red, size: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Empty spacer to balance layout
                    const SizedBox(width: 40),
                    
                    // Centered Title
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Mes Contacts',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Gérez vos contacts facilement',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Delete Button on the right
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.delete_forever, color: Colors.white),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Vider tout'),
                              content: const Text('Êtes-vous sûr de vouloir supprimer tous les contacts ?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Non')),
                                TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Oui', style: TextStyle(color: Colors.red))),
                              ],
                            ),
                          );
                          if (confirm ?? false) {
                            setState(() => contacts.clear());
                            await ContactStorage.saveContacts(contacts);
                            _search();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Tous les contacts ont été supprimés'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          }
                        },
                        tooltip: 'Vider tout',
                      ),
                    ),
                  ],
                ),
              ),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _searchCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Colors.white70),
                    hintText: 'Rechercher par nom...',
                    hintStyle: const TextStyle(color: Colors.white54),
                    suffixIcon: _searchCtrl.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.white70),
                            onPressed: () {
                              _searchCtrl.clear();
                              _search();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),

              // Contacts List
              Expanded(
                child: filteredContacts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              contacts.isEmpty ? Icons.contacts_outlined : Icons.search_off,
                              size: 64,
                              color: Colors.white54,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              contacts.isEmpty ? 'Aucun contact' : 'Aucun résultat',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              contacts.isEmpty ? 'Commencez par ajouter un contact' : 'Essayez une autre recherche',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: filteredContacts.length,
                        itemBuilder: (context, index) {
                          final c = filteredContacts[index];
                          return FadeTransition(
                            opacity: _animController,
                            child: _buildContactCard(c),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleAdd,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E3C72),
        elevation: 8,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}
