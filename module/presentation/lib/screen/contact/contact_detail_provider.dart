import 'package:collection/collection.dart';
import 'package:domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'contact_provider.dart';

final contactDetailProvider = Provider.family<Contact?, String>((ref, id) {
  final contact = ref.watch(
    contactProvider.select(
      (value) => value.contacts.firstWhereOrNull((element) => element.id == id),
    ),
  );
  return contact;
});
