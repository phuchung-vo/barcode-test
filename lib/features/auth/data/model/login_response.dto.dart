import 'dart:convert';

import 'package:flutter_base_code/core/domain/model/value_object.dart';
import 'package:flutter_base_code/features/auth/domain/model/login_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response.dto.freezed.dart';
part 'login_response.dto.g.dart';

@freezed
class LoginResponseDTO with _$LoginResponseDTO {
  const factory LoginResponseDTO({
    @JsonKey(name: 'token') required String accessToken,
    String? refreshToken,
  }) = _LoginResponseDTO;

  const LoginResponseDTO._();

  factory LoginResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseDTOFromJson(json);

  factory LoginResponseDTO.fromDomain(LoginResponse loginResponse) =>
      LoginResponseDTO(
        accessToken: loginResponse.accessToken.getOrCrash(),
        refreshToken: loginResponse.refreshToken.getOrCrash(),
      );

  factory LoginResponseDTO.loginDTOFromJson(String str) =>
      LoginResponseDTO.fromJson(json.decode(str) as Map<String, dynamic>);

  static String loginDTOToJson(LoginResponseDTO data) =>
      json.encode(data.toJson());

  LoginResponse toDomain() => LoginResponse(
        accessToken: AuthToken(accessToken),
        refreshToken: AuthToken(refreshToken ?? accessToken),
      );
}
