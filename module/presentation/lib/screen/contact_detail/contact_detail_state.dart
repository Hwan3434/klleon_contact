import 'contact_detail_event.dart';
import 'contact_detail_screen_type.dart';

class ContactDetailScreenState {
  final String id;
  final String name;
  final String phone;
  final ContactDetailScreenType mode;
  final ContactDetailEvent? event;

  ContactDetailScreenState({
    required this.id,
    required this.name,
    required this.phone,
    required this.mode,
    this.event,
  });

  ContactDetailScreenState copyWith({
    String? id,
    String? name,
    String? phone,
    ContactDetailScreenType? mode,
    ContactDetailEvent? event,
  }) {
    return ContactDetailScreenState(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      mode: mode ?? this.mode,
      event: event ?? this.event,
    );
  }
}
