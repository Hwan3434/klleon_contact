import 'package:data/contact/common/drift/contact_dao.dart';
import 'package:data/contact/common/drift/k_drift_database.dart';
import 'package:data/contact/datasource/drift/contact_local_datasource_impl.dart';
import 'package:data/contact/repository/contact_repository_impl.dart';
import 'package:domain/domain.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late KDriftDatabase database;
  late ContactDao contactDao;
  late ContactLocalDatasourceImpl localDatasource;
  late ContactRepositoryImpl repository;

  setUp(() {
    database = KDriftDatabase.test(NativeDatabase.memory());
    contactDao = database.contactDao;
    localDatasource = ContactLocalDatasourceImpl(contactDao);
    repository = ContactRepositoryImpl(localDatasource);
  });

  tearDown(() async {
    await database.close();
  });

  test('연락처를 추가하고 조회할 수 있다', () async {
    final contact = Contact(id: 1, name: '홍길동', phone: '010-1234-5678');
    await repository.createContact(contact);

    final result = await repository.getContacts(
      ContactFilter(pageNumber: 1, pageSize: 10),
    );

    expect(result.length, 1);
    expect(result.first.name, '홍길동');
    expect(result.first.phone, '010-1234-5678');
  });

  test('연락처를 수정하고 변경사항을 확인할 수 있다', () async {
    final contact = Contact(id: 1, name: '홍길동', phone: '010-1234-5678');
    await repository.createContact(contact);

    final updatedContact = Contact(id: 1, name: '이순신', phone: '010-8765-4321');
    await repository.updateContact(updatedContact);

    final result = await repository.getContacts(
      ContactFilter(pageNumber: 1, pageSize: 10),
    );

    expect(result.length, 1);
    expect(result.first.name, '이순신');
    expect(result.first.phone, '010-8765-4321');
  });

  test('연락처를 삭제하고 리스트가 비어있는지 확인할 수 있다', () async {
    final contact = Contact(id: 1, name: '홍길동', phone: '010-1234-5678');
    await repository.createContact(contact);

    await repository.deleteContact(1);

    final result = await repository.getContacts(
      ContactFilter(pageNumber: 1, pageSize: 10),
    );

    expect(result.isEmpty, true);
  });

  test('연락처가 11개 있을 때 10개씩 페이징하여 가져올 수 있다', () async {
    for (int i = 0; i < 11; i++) {
      await repository.createContact(
        Contact(id: i, name: '이름$i', phone: '010-0000-000$i'),
      );
    }

    final page1 = await repository.getContacts(
      ContactFilter(pageNumber: 1, pageSize: 10),
    );
    final page2 = await repository.getContacts(
      ContactFilter(pageNumber: 2, pageSize: 10),
    );

    expect(page1.length, 10);
    expect(page2.length, 1);
  });

  test('연락처가 9개 있을 때 10개 요청하면 9개만 가져온다', () async {
    for (int i = 0; i < 9; i++) {
      await repository.createContact(
        Contact(id: i, name: '이름$i', phone: '010-0000-000$i'),
      );
    }

    final result = await repository.getContacts(
      ContactFilter(pageNumber: 1, pageSize: 10),
    );

    expect(result.length, 9);
  });

  test('pageNumber가 0일 때 에러가 발생한다', () async {
    expect(
      () async => await repository.getContacts(
        ContactFilter(pageNumber: 0, pageSize: 10),
      ),
      throwsA(isA<ArgumentError>()),
    );
  });
}
