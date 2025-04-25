import 'package:domain/domain.dart';
import 'package:presentation/common/contact_event.dart';

class ContactListState {
  final List<Contact> contacts;
  final bool isLoading;
  final bool hasMore;
  final ContactFilter filter;

  ContactListState({
    required this.contacts,
    required this.isLoading,
    required this.hasMore,
    required this.filter,
  });

  ContactListState copyWith({
    List<Contact>? contacts,
    bool? isLoading,
    ContactFilter? filter,
    bool? hasMore,
    ContactEvent? event,
  }) {
    return ContactListState(
      contacts: contacts ?? this.contacts,
      isLoading: isLoading ?? this.isLoading,
      filter: filter ?? this.filter,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
