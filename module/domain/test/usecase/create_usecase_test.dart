import 'package:domain/domain.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../mocks/mock_contact_repository.mocks.dart';

void main() {
  group('CreateContactUseCase 테스트 (Mockito)', () {
    test('새 연락처를 성공적으로 추가한다', () async {
      // Arrange
      final mockRepository = MockContactRepository();
      final useCase = CreateContactUseCase(mockRepository);
      final contact = Contact(id: "1", name: '홍길동', phone: '010-1234-5678');

      when(mockRepository.createContact(contact)).thenAnswer((_) async => null);

      // Act
      final result = await useCase(contact);

      // Assert
      expect(result, isA<Success<void>>());
      verify(mockRepository.createContact(contact)).called(1);
    });

    test('연락처 추가 실패 시 에러를 반환한다', () async {
      // Arrange
      final mockRepository = MockContactRepository();
      final useCase = CreateContactUseCase(mockRepository);
      final contact = Contact(id: "1", name: '홍길동', phone: '010-1234-5678');

      when(mockRepository.createContact(contact)).thenThrow(Exception('DB 오류'));

      // Act
      final result = await useCase(contact);

      // Assert
      expect(result, isA<Failure<void>>());
      verify(mockRepository.createContact(contact)).called(1);
    });
  });
}
