import 'package:drift/drift.dart';

class ContactTable extends Table {
  IntColumn get id => integer().autoIncrement()(); // PK
  TextColumn get name => text()();
  TextColumn get phone => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}