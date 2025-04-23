import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_filter.freezed.dart';

enum SortOrder { asc, desc }

@freezed
class ContactFilter with _$ContactFilter {
  const factory ContactFilter({
    String? query,
    SortOrder? sortOrder, // 추가된 필드
    required int pageNumber, // 페이지 번호는 1부터 시작
    required int pageSize,
  }) = _ContactFilter;
}
