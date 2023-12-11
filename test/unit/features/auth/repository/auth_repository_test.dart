import 'package:flutter_base_code/core/data/repository/local_storage_repository.dart';
import 'package:flutter_base_code/core/domain/model/failure.dart';
import 'package:flutter_base_code/core/domain/model/value_object.dart';
import 'package:flutter_base_code/features/auth/data/model/login_response.dto.dart';
import 'package:flutter_base_code/features/auth/data/repository/auth_repository.dart';
import 'package:flutter_base_code/features/auth/data/service/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../utils/test_utils.dart';
import 'auth_repository_test.mocks.dart';

@GenerateNiceMocks(<MockSpec<dynamic>>[
  MockSpec<AuthService>(),
  MockSpec<LocalStorageRepository>(),
])
void main() {
  late MockAuthService authService;
  late MockLocalStorageRepository localStorageRepository;
  late AuthRepository authRepository;
  late LoginResponseDTO loginResponseDTO;

  setUp(() {
    authService = MockAuthService();
    localStorageRepository = MockLocalStorageRepository();
    authRepository = AuthRepository(authService, localStorageRepository);
    loginResponseDTO = const LoginResponseDTO(accessToken: 'accessToken');
  });

  group('Login', () {
    test(
      'should return a unit when login is successful',
      () async {
        provideDummy(
          generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200),
        );
        when(authService.login(any)).thenAnswer(
          (_) async =>
              generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200),
        );
        when(localStorageRepository.setAccessToken(any))
            .thenAnswer((_) async => true);
        when(localStorageRepository.setRefreshToken(any))
            .thenAnswer((_) async => true);
        when(localStorageRepository.setLastLoggedInEmail(any))
            .thenAnswer((_) async => true);

        final Either<Failure, Unit> result = await authRepository.login(
          EmailAddress('email@example.com'),
          Password('password'),
        );

        expect(result.isRight(), true);
      },
    );

    test(
      'should return a failure when login encounters a server error',
      () async {
        provideDummy(
          generateMockResponse<LoginResponseDTO>(loginResponseDTO, 500),
        );
        when(authService.login(any)).thenAnswer(
          (_) async =>
              generateMockResponse<LoginResponseDTO>(loginResponseDTO, 500),
        );
        when(localStorageRepository.setAccessToken(any))
            .thenAnswer((_) async => true);
        when(localStorageRepository.setRefreshToken(any))
            .thenAnswer((_) async => true);
        when(localStorageRepository.setLastLoggedInEmail(any))
            .thenAnswer((_) async => true);

        final Either<Failure, Unit> result = await authRepository.login(
          EmailAddress('email@example.com'),
          Password('password'),
        );

        expect(result.isLeft(), true);
      },
    );

    test(
      'should return a failure when login encounters an unexpected error',
      () async {
        when(authService.login(any)).thenThrow(throwsException);
        when(localStorageRepository.setAccessToken(any))
            .thenAnswer((_) async => true);
        when(localStorageRepository.setRefreshToken(any))
            .thenAnswer((_) async => true);
        when(localStorageRepository.setLastLoggedInEmail(any))
            .thenAnswer((_) async => true);

        final Either<Failure, Unit> result = await authRepository.login(
          EmailAddress('email@example.com'),
          Password('password'),
        );

        expect(result.isLeft(), true);
      },
    );
    test(
      'should return a failure when an error occurs when saving the access token',
      () async {
        provideDummy(
          generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200),
        );
        when(authService.login(any)).thenAnswer(
          (_) async =>
              generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200),
        );
        when(localStorageRepository.setAccessToken(any))
            .thenAnswer((_) async => false);
        when(localStorageRepository.setRefreshToken(any))
            .thenAnswer((_) async => true);
        when(localStorageRepository.setLastLoggedInEmail(any))
            .thenAnswer((_) async => true);

        final Either<Failure, Unit> result = await authRepository.login(
          EmailAddress('email@example.com'),
          Password('password'),
        );

        expect(result.isLeft(), true);
      },
    );
    test(
      'should return a failure when an error occurs when saving the refresh token',
      () async {
        provideDummy(
          generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200),
        );
        when(authService.login(any)).thenAnswer(
          (_) async =>
              generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200),
        );
        when(localStorageRepository.setAccessToken(any))
            .thenAnswer((_) async => true);
        when(localStorageRepository.setRefreshToken(any))
            .thenAnswer((_) async => false);
        when(localStorageRepository.setLastLoggedInEmail(any))
            .thenAnswer((_) async => true);

        final Either<Failure, Unit> result = await authRepository.login(
          EmailAddress('email@example.com'),
          Password('password'),
        );

        expect(result.isLeft(), true);
      },
    );
    test(
      'should return a failure when an error occurs when saving the last logged in email',
      () async {
        provideDummy(
          generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200),
        );
        when(authService.login(any)).thenAnswer(
          (_) async =>
              generateMockResponse<LoginResponseDTO>(loginResponseDTO, 200),
        );
        when(localStorageRepository.setAccessToken(any))
            .thenAnswer((_) async => true);
        when(localStorageRepository.setRefreshToken(any))
            .thenAnswer((_) async => true);
        when(localStorageRepository.setLastLoggedInEmail(any))
            .thenAnswer((_) async => false);

        final Either<Failure, Unit> result = await authRepository.login(
          EmailAddress('email@example.com'),
          Password('password'),
        );

        expect(result.isLeft(), true);
      },
    );
  });
  group('Logout', () {
    test(
      'should return a unit when logout is successful',
      () async {
        when(localStorageRepository.setAccessToken(any))
            .thenAnswer((_) async => true);
        when(localStorageRepository.setRefreshToken(any))
            .thenAnswer((_) async => true);

        final Either<Failure, Unit> result = await authRepository.logout();

        expect(result.isRight(), true);
      },
    );

    test(
      'should return a failure when logout encounters an unexpected error',
      () async {
        when(localStorageRepository.setAccessToken(any))
            .thenThrow(throwsException);
        when(localStorageRepository.setRefreshToken(any))
            .thenAnswer((_) async => true);

        final Either<Failure, Unit> result = await authRepository.logout();

        expect(result.isLeft(), true);
      },
    );
    test(
      'should return a failure when an error occurs when clearing the access token',
      () async {
        when(localStorageRepository.setAccessToken(any))
            .thenAnswer((_) async => false);
        when(localStorageRepository.setRefreshToken(any))
            .thenAnswer((_) async => true);

        final Either<Failure, Unit> result = await authRepository.logout();

        expect(result.isLeft(), true);
      },
    );
    test(
      'should return a failure when an error occurs when clearing the refresh token',
      () async {
        when(localStorageRepository.setAccessToken(any))
            .thenAnswer((_) async => true);
        when(localStorageRepository.setRefreshToken(any))
            .thenAnswer((_) async => false);

        final Either<Failure, Unit> result = await authRepository.logout();

        expect(result.isLeft(), true);
      },
    );
  });
}
