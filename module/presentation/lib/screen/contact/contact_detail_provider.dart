import 'package:domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'contact_provider.dart';

final contactDetailProvider = Provider.family<Contact, String>((ref, id) {
  final contact = ref.watch(
    contactProvider.select(
      (value) => value.contacts.singleWhere((element) => element.id == id),
    ),
  );
  assert(contact != null, "Contact not found");
  return contact;
});
