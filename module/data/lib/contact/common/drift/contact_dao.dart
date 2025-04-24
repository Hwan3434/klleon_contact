import 'package:data/contact/common/drift/k_drift_database.dart';
import 'package:domain/contact/entity/contact_filter.dart';
import 'package:drift/drift.dart';

import 'contact_table.dart';

part 'contact_dao.g.dart';

/// Drift의 DAO 클래스, ContactTable에 대한 데이터 접근 처리
@DriftAccessor(tables: [ContactTable])
class ContactDao extends DatabaseAccessor<KDriftDatabase>
    with _$ContactDaoMixin {
  ContactDao(KDriftDatabase db) : super(db);

  /// 페이징 처리 및 정렬, 검색 조건이 포함된 연락처 조회
  Future<List<ContactTableData>> getContactsWithPaging({
    required int pageNumber,
    required int pageSize,
    String? query,
    SortOrder? sortOrder,
  }) {
    // 정렬 기준 설정 (오름차순 또는 내림차순)
    final order =
        (sortOrder ?? SortOrder.asc) == SortOrder.asc
            ? OrderingTerm.asc(contactTable.name)
            : OrderingTerm.desc(contactTable.name);

    // 페이지네이션 오프셋 계산
    final offset = (pageNumber - 1) * pageSize;

    // 검색 조건 설정: 이름 또는 전화번호에 검색어 포함 여부
    final whereClause =
        query != null && query.isNotEmpty
            ? contactTable.name.contains(query) |
                contactTable.phone.contains(query)
            : const Constant(true); // 조건이 없으면 모두 조회

    // 조건을 바탕으로 쿼리 수행
    return (select(contactTable)
          ..where((tbl) => whereClause)
          ..orderBy([(_) => order])
          ..limit(pageSize, offset: offset))
        .get();
  }

  /// 새로운 연락처 추가
  Future<int> insertContact(Insertable<ContactTableData> contact) =>
      into(contactTable).insert(contact);

  /// 기존 연락처 수정
  Future<bool> updateContact(Insertable<ContactTableData> contact) =>
      update(contactTable).replace(contact);

  /// 연락처 삭제
  Future<int> deleteContact(String id) =>
      (delete(contactTable)..where((tbl) => tbl.id.equals(id))).go();
}
