import 'package:domain/domain.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../mocks/mock_contact_repository.mocks.dart';

void main() {
  group('DeleteContactUseCase 테스트 (Mockito)', () {
    test('기존 연락처를 성공적으로 삭제한다', () async {
      // Arrange
      final mockRepository = MockContactRepository();
      final useCase = DeleteContactUseCase(mockRepository);
      const contactId = "1";

      when(
        mockRepository.deleteContact(contactId),
      ).thenAnswer((_) async => null);

      // Act
      final result = await useCase(contactId);

      // Assert
      expect(result, isA<Success<void>>());
      verify(mockRepository.deleteContact(contactId)).called(1);
    });

    test('연락처 삭제 실패 시 에러를 반환한다', () async {
      // Arrange
      final mockRepository = MockContactRepository();
      final useCase = DeleteContactUseCase(mockRepository);
      const contactId = "1";

      when(
        mockRepository.deleteContact(contactId),
      ).thenThrow(Exception('DB 오류'));

      // Act
      final result = await useCase(contactId);

      // Assert
      expect(result, isA<Failure<void>>());
      verify(mockRepository.deleteContact(contactId)).called(1);
    });
  });
}
