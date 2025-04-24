import 'package:domain/contact/entity/contact.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_event.freezed.dart';

@freezed
sealed class ContactEvent with _$ContactEvent {
  const factory ContactEvent.createSuccess(Contact contact) = CreateSuccess;
  const factory ContactEvent.createFailure(Object error) = CreateFailure;
  const factory ContactEvent.updateSuccess(Contact contact) = UpdateSuccess;
  const factory ContactEvent.updateFailure(Object error) = UpdateFailure;
  const factory ContactEvent.deleteSuccess(String contactId) = DeleteSuccess;
  const factory ContactEvent.deleteFailure(Object error) = DeleteFailure;
}
