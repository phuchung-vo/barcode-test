import 'dart:developer';

import 'package:chopper/chopper.dart';
import 'package:flutter_base_code/app/constants/enum.dart';
import 'package:flutter_base_code/app/helpers/extensions/int_ext.dart';
import 'package:flutter_base_code/app/helpers/extensions/status_code_ext.dart';
import 'package:flutter_base_code/core/domain/interface/i_local_storage_repository.dart';
import 'package:flutter_base_code/core/domain/model/failure.dart';
import 'package:flutter_base_code/core/domain/model/value_object.dart';
import 'package:flutter_base_code/features/auth/data/model/login_response.dto.dart';
import 'package:flutter_base_code/features/auth/data/service/auth_service.dart';
import 'package:flutter_base_code/features/auth/domain/interface/i_auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IAuthRepository)
class AuthRepository implements IAuthRepository {
  AuthRepository(
    this._authService,
    this._localStorageRepository,
  );

  final ILocalStorageRepository _localStorageRepository;

  final AuthService _authService;

  @override
  Future<Either<Failure, Unit>> login(
    EmailAddress email,
    Password password,
  ) async {
    try {
      final String emailAddress = email.getOrCrash();
      final Map<String, dynamic> requestBody = <String, dynamic>{
        'email': emailAddress,
        'password': password.getOrCrash(),
      };

      final Response<LoginResponseDTO> response =
          await _authService.login(requestBody);
      final StatusCode statusCode = response.statusCode.statusCode;

      if (statusCode.isSuccess && response.body != null) {
        // Save tokens to local storage
        if (!await _localStorageRepository
            .setAccessToken(response.body!.accessToken)) {
          return left(const Failure.storageError());
        }
        if (!await _localStorageRepository
            .setRefreshToken(response.body!.refreshToken)) {
          return left(const Failure.storageError());
        }
        if (!await _localStorageRepository.setLastLoggedInEmail(emailAddress)) {
          return left(const Failure.storageError());
        }

        return right(unit);
      } else {
        return left(
          Failure.serverError(statusCode, response.error?.toString() ?? ''),
        );
      }
    } catch (error) {
      log(error.toString());

      return left(Failure.unexpected(error.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      //TODO: add  service to logout
      await Future<void>.delayed(const Duration(milliseconds: 500));

      //clear auth tokens from the local storage
      if (!await _localStorageRepository.setAccessToken(null)) {
        return left(const Failure.storageError());
      }
      if (!await _localStorageRepository.setRefreshToken(null)) {
        return left(const Failure.storageError());
      }

      return right(unit);
    } catch (error) {
      log(error.toString());

      return left(Failure.unexpected(error.toString()));
    }
  }
}
