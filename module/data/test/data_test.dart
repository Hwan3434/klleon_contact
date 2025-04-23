import 'package:data/contact/datasource/contact_local_datasource.dart';
import 'package:data/contact/dto/contact_dto.dart';
import 'package:data/contact/repository/contact_repository_impl.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'data_test.mocks.dart';

@GenerateMocks([ContactLocalDatasource])
void main() {
  late ContactRepositoryImpl repository;
  late MockContactLocalDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockContactLocalDatasource();
    repository = ContactRepositoryImpl(mockDatasource);
  });

  group('ContactRepositoryImpl 테스트', () {
    final testContact = Contact(id: 1, name: '홍길동', phone: '01012345678');
    final testContactDTO = ContactDTO(
      id: 1,
      name: '홍길동',
      phoneNumber: '01012345678',
    );
    final testFilter = ContactFilter(pageNumber: 1, pageSize: 10);

    test('연락처 목록을 잘 가져오는지 테스트', () async {
      when(
        mockDatasource.getContacts(testFilter),
      ).thenAnswer((_) async => [testContactDTO]);

      final result = await repository.getContacts(testFilter);

      expect(result, [testContact]);
      verify(mockDatasource.getContacts(testFilter)).called(1);
    });

    test('연락처 생성이 잘 되는지 테스트', () async {
      when(mockDatasource.createContact(any)).thenAnswer((_) async => {});

      await repository.createContact(testContact);

      verify(mockDatasource.createContact(testContactDTO)).called(1);
    });

    test('연락처 업데이트가 잘 되는지 테스트', () async {
      when(mockDatasource.updateContact(any)).thenAnswer((_) async => {});

      await repository.updateContact(testContact);

      verify(mockDatasource.updateContact(testContactDTO)).called(1);
    });

    test('연락처 삭제가 잘 되는지 테스트', () async {
      when(mockDatasource.deleteContact(1)).thenAnswer((_) async => {});

      await repository.deleteContact(1);

      verify(mockDatasource.deleteContact(1)).called(1);
    });

    test('연락처 목록을 오름차순으로 잘 가져오는지 테스트', () async {
      final filter = ContactFilter(
        pageNumber: 1,
        pageSize: 10,
        sortOrder: SortOrder.asc,
      );
      final mockDTOs = [
        ContactDTO(id: 1, name: 'Alice', phoneNumber: '1234567890'),
        ContactDTO(id: 2, name: 'Bob', phoneNumber: '0987654321'),
      ];

      when(
        mockDatasource.getContacts(filter),
      ).thenAnswer((_) async => mockDTOs);

      final result = await repository.getContacts(filter);

      expect(result.length, equals(2));
      expect(result[0].name, equals('Alice'));
      expect(result[1].name, equals('Bob'));
      verify(mockDatasource.getContacts(filter)).called(1);
    });

    test('연락처 목록을 내림차순으로 잘 가져오는지 테스트', () async {
      final filter = ContactFilter(
        pageNumber: 1,
        pageSize: 10,
        sortOrder: SortOrder.desc,
      );
      final mockDTOs = [
        ContactDTO(id: 2, name: 'Bob', phoneNumber: '0987654321'),
        ContactDTO(id: 1, name: 'Alice', phoneNumber: '1234567890'),
      ];

      when(
        mockDatasource.getContacts(filter),
      ).thenAnswer((_) async => mockDTOs);

      final result = await repository.getContacts(filter);

      expect(result.length, equals(2));
      expect(result[0].name, equals('Bob'));
      expect(result[1].name, equals('Alice'));
      verify(mockDatasource.getContacts(filter)).called(1);
    });
  });
}
