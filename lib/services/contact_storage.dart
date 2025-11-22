import 'package:hive_flutter/hive_flutter.dart';
import '../models/contact.dart';

class ContactStorage {
  static final _box = Hive.box<Contact>('contactsBox');

  /// 🔹 Ajouter un contact
  static Future<void> addContact(Contact c) async {
    await _box.add(c);
  }

  /// 🔹 Modifier un contact (selon index)
  static Future<void> updateContact(int index, Contact c) async {
    await _box.putAt(index, c);
  }

  /// 🔹 Supprimer un contact
  static Future<void> deleteContact(int index) async {
    await _box.deleteAt(index);
  }

  /// 🔹 Récupérer tous les contacts
  static List<Contact> getContacts() {
    return _box.values.toList();
  }

  /// 🔹 Vider tout
  static Future<void> clearAll() async {
    await _box.clear();
  }

  /// 🔹 Charger tous les contacts
  static Future<List<Contact>> loadContacts() async {
    return _box.values.toList();
  }

  /// 🔹 Sauvegarder une liste de contacts
  static Future<void> saveContacts(List<Contact> contacts) async {
    await _box.clear();
    for (var contact in contacts) {
      await _box.add(contact);
    }
  }
}
