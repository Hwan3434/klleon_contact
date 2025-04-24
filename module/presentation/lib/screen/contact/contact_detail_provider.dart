import 'package:domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'contact_provider.dart';

final contactDetailProvider = Provider.family<Contact, int>((ref, id) {
  final contacts = ref.watch(contactProvider);
  final contact = contacts.contacts.firstWhere((element) => element.id == id);
  assert(contact != null, "Contact not found");
  return contact;
});
