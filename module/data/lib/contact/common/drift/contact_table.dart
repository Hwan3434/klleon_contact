import 'package:drift/drift.dart';

/// table schema class
/// 절대 instance를 생성하지 말 것
class ContactTable extends Table {
  IntColumn get id => integer().autoIncrement()(); // PK
  TextColumn get name => text()();
  TextColumn get phone => text()();
}
