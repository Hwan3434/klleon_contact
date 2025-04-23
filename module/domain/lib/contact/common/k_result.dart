import 'package:freezed_annotation/freezed_annotation.dart';

part 'k_result.freezed.dart';

@freezed
sealed class KResult<T> with _$KResult<T> {
  const factory KResult.success(T data) = Success<T>;
  const factory KResult.failure(Object error) = Failure<T>;
}
