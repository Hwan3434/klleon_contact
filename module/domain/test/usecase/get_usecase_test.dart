import 'package:domain/domain.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../mocks/mock_contact_repository.mocks.dart';

void main() {
  group('GetContactsUseCase 테스트 (Mockito)', () {
    test('연락처 목록을 성공적으로 가져온다', () async {
      // Arrange
      final mockRepository = MockContactRepository();
      final useCase = GetContactsUseCase(mockRepository);
      final contacts = [
        Contact(id: 1, name: '홍길동', phone: '010-1234-5678'),
        Contact(id: 2, name: '김철수', phone: '010-9876-5432'),
      ];

      final filter = ContactFilter(pageNumber: 1, pageSize: 20);

      when(
        mockRepository.getContacts(filter),
      ).thenAnswer((_) async => contacts);

      // Act
      final result = await useCase.call(filter: filter);

      // Assert
      expect(result, isA<Success<List<Contact>>>());
      result.when(
        success: (data) => expect(data.length, 2),
        failure: (_) => fail('실패하면 안 됨'),
      );

      verify(mockRepository.getContacts(filter)).called(1); // 호출 확인
    });

    test('데이터가 11개 있을 때 10개씩 가져오면 첫 페이지는 10개를 반환한다', () async {
      // Arrange
      final mockRepository = MockContactRepository();
      final useCase = GetContactsUseCase(mockRepository);
      final contacts = List.generate(
        11,
        (index) => Contact(
          id: index + 1,
          name: '이름$index',
          phone: '010-0000-000$index',
        ),
      );

      final filter = ContactFilter(pageNumber: 1, pageSize: 10);
      when(
        mockRepository.getContacts(filter),
      ).thenAnswer((_) async => contacts.take(10).toList());

      // Act
      final result = await useCase.call(filter: filter);

      // Assert
      expect(result, isA<Success<List<Contact>>>());
      result.when(
        success: (data) => expect(data.length, 10),
        failure: (_) => fail('실패하면 안 됨'),
      );

      verify(mockRepository.getContacts(filter)).called(1);
    });

    test('데이터가 9개 있을 때 10개씩 가져오면 9개를 반환한다', () async {
      // Arrange
      final mockRepository = MockContactRepository();
      final useCase = GetContactsUseCase(mockRepository);
      final contacts = List.generate(
        9,
        (index) => Contact(
          id: index + 1,
          name: '이름$index',
          phone: '010-0000-000$index',
        ),
      );

      final filter = ContactFilter(pageNumber: 1, pageSize: 10);
      when(
        mockRepository.getContacts(filter),
      ).thenAnswer((_) async => contacts);

      // Act
      final result = await useCase.call(filter: filter);

      // Assert
      expect(result, isA<Success<List<Contact>>>());
      result.when(
        success: (data) => expect(data.length, 9),
        failure: (_) => fail('실패하면 안 됨'),
      );

      verify(mockRepository.getContacts(filter)).called(1);
    });

    test('연락처 목록 가져오기 실패 시 에러를 반환한다', () async {
      // Arrange
      final mockRepository = MockContactRepository();
      final useCase = GetContactsUseCase(mockRepository);

      final filter = ContactFilter(pageNumber: 1, pageSize: 20);

      when(mockRepository.getContacts(filter)).thenThrow(Exception('DB 오류'));

      // Act
      final result = await useCase.call(filter: filter);

      // Assert
      expect(result, isA<Failure<List<Contact>>>());

      verify(mockRepository.getContacts(filter)).called(1);
    });
  });
}
