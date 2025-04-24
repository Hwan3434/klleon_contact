import 'package:domain/domain.dart';
import 'package:presentation/screen/contact/contact_event.dart';

class ContactState {
  final List<Contact> contacts;
  final bool isLoading;
  final bool hasMore;
  final ContactFilter filter;
  final ContactEvent? event;

  ContactState({
    required this.contacts,
    required this.isLoading,
    required this.hasMore,
    required this.filter,
    this.event,
  });

  ContactState copyWith({
    List<Contact>? contacts,
    bool? isLoading,
    ContactFilter? filter,
    bool? hasMore,
    ContactEvent? event,
  }) {
    return ContactState(
      contacts: contacts ?? this.contacts,
      isLoading: isLoading ?? this.isLoading,
      filter: filter ?? this.filter,
      hasMore: hasMore ?? this.hasMore,
      event: event,
    );
  }
}
