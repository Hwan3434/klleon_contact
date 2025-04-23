import 'package:domain/domain.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../mocks/mock_contact_repository.mocks.dart';

void main() {
  group('UpdateContactUseCase 테스트 (Mockito)', () {
    test('기존 연락처를 성공적으로 수정한다', () async {
      // Arrange
      final mockRepository = MockContactRepository();
      final useCase = UpdateContactUseCase(mockRepository);
      final updatedContact = Contact(
        id: 1,
        name: '홍길동',
        phone: '010-9999-8888',
      );

      when(
        mockRepository.updateContact(updatedContact),
      ).thenAnswer((_) async => null);

      // Act
      final result = await useCase(updatedContact);

      // Assert
      expect(result, isA<Success<void>>());
      verify(mockRepository.updateContact(updatedContact)).called(1);
    });

    test('연락처 수정 실패 시 에러를 반환한다', () async {
      // Arrange
      final mockRepository = MockContactRepository();
      final useCase = UpdateContactUseCase(mockRepository);
      final contact = Contact(id: 1, name: '홍길동', phone: '010-1234-5678');

      when(mockRepository.updateContact(contact)).thenThrow(Exception('DB 오류'));

      // Act
      final result = await useCase(contact);

      // Assert
      expect(result, isA<Failure<void>>());
      verify(mockRepository.updateContact(contact)).called(1);
    });
  });
}
