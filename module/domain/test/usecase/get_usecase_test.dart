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

      when(mockRepository.getAllContacts()).thenAnswer((_) async => contacts);

      // Act
      final result = await useCase();

      // Assert
      expect(result, isA<Success<List<Contact>>>());
      result.when(
        success: (data) => expect(data.length, 2),
        failure: (_) => fail('실패하면 안 됨'),
      );

      verify(mockRepository.getAllContacts()).called(1); // 호출 확인
    });

    test('연락처 목록 가져오기 실패 시 에러를 반환한다', () async {
      // Arrange
      final mockRepository = MockContactRepository();
      final useCase = GetContactsUseCase(mockRepository);

      when(mockRepository.getAllContacts()).thenThrow(Exception('DB 오류'));

      // Act
      final result = await useCase();

      // Assert
      expect(result, isA<Failure<List<Contact>>>());

      verify(mockRepository.getAllContacts()).called(1);
    });
  });
}
