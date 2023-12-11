import 'dart:developer';

import 'package:flutter_base_code/app/helpers/extensions/cubit_ext.dart';
import 'package:flutter_base_code/core/domain/interface/i_user_repository.dart';
import 'package:flutter_base_code/core/domain/model/failure.dart';
import 'package:flutter_base_code/core/domain/model/user.dart';
import 'package:flutter_base_code/features/auth/domain/interface/i_auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'auth_bloc.freezed.dart';
part 'auth_state.dart';

@lazySingleton
class AuthBloc extends Cubit<AuthState> {
  AuthBloc(
    this._userRepository,
    this._authRepository,
  ) : super(const AuthState.initial());

  final IUserRepository _userRepository;
  final IAuthRepository _authRepository;

  Future<void> initialize() async {
    try {
      safeEmit(const AuthState.initial());
      _emitAuthState(await _userRepository.user, isLogout: true);
    } catch (error) {
      _emitError(error);
    }
  }

  Future<void> getUser() async {
    try {
      safeEmit(const AuthState.loading());
      _emitAuthState(await _userRepository.user);
    } catch (error) {
      _emitError(error);
    }
  }

  Future<void> authenticate() async {
    try {
      safeEmit(const AuthState.loading());
      _emitAuthState(await _userRepository.user, isLogout: true);
    } catch (error) {
      _emitError(error);
    }
  }

  Future<void> logout() async {
    try {
      safeEmit(const AuthState.loading());
      final Either<Failure, Unit> possibleFailure =
          await _authRepository.logout();
      safeEmit(
        possibleFailure.fold(
          AuthState.failed,
          (_) => const AuthState.unauthenticated(),
        ),
      );
    } catch (error) {
      _emitError(error);
    }
  }

  void _emitAuthState(
    Either<Failure, User> possibleFailure, {
    bool isLogout = false,
  }) {
    possibleFailure.fold(
      (Failure failure) {
        safeEmit(AuthState.failed(failure));
        if (isLogout) {
          safeEmit(const AuthState.unauthenticated());
        }
      },
      (User user) => safeEmit(
        AuthState.authenticated(
          user: user,
        ),
      ),
    );
  }

  void _emitError(Object error) {
    log(error.toString());
    safeEmit(
      AuthState.failed(
        Failure.unexpected(error.toString()),
      ),
    );
  }
}
