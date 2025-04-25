import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_detail_event.freezed.dart';

@freezed
sealed class ContactDetailEvent with _$ContactDetailEvent {
  const factory ContactDetailEvent.fetchSuccess(Contact contact) = FetchSuccess;
  const factory ContactDetailEvent.fetchError(Object message) = FetchError;
  const factory ContactDetailEvent.validate(String message) = Validate;
}
