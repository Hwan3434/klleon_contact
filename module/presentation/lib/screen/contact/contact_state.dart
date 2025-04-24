import 'package:domain/domain.dart';

class ContactState {
  final List<Contact> contacts;
  final bool isLoading;
  final bool hasMore;
  final ContactFilter filter;

  ContactState({
    required this.contacts,
    required this.isLoading,
    required this.hasMore,
    required this.filter,
  });

  ContactState copyWith({
    List<Contact>? contacts,
    bool? isLoading,
    ContactFilter? filter,
    bool? hasMore,
  }) {
    return ContactState(
      contacts: contacts ?? this.contacts,
      isLoading: isLoading ?? this.isLoading,
      filter: filter ?? this.filter,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
