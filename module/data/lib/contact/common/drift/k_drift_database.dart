import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'contact_dao.dart';
import 'contact_table.dart';

part 'k_drift_database.g.dart';

@DriftDatabase(tables: [ContactTable], daos: [ContactDao])
class KDriftDatabase extends _$KDriftDatabase {
  KDriftDatabase() : super(_openConnection());
  KDriftDatabase.test(NativeDatabase super.db);

  @override
  int get schemaVersion => 1;

  // 필요한 경우 Migration 로직 여기에 작성
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) => m.createAll(),
    // onUpgrade: ... (버전 업그레이드 시 사용)
  );
}

// 데이터베이스 연결 설정
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.sqlite'));
    return NativeDatabase(file);
  });
}
