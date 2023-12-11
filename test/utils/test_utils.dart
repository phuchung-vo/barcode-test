import 'dart:convert';

import 'package:chopper/chopper.dart' as chopper;
import 'package:flutter/material.dart';
import 'package:flutter_base_code/app/constants/enum.dart';
import 'package:flutter_base_code/app/helpers/injection.dart';
import 'package:flutter_base_code/bootstrap.dart';
import 'package:flutter_base_code/core/data/model/user.dto.dart';
import 'package:flutter_base_code/core/domain/model/user.dart';
import 'package:flutter_base_code/features/home/data/model/post.dto.dart';
import 'package:flutter_base_code/features/home/domain/model/post.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../flutter_test_config.dart';
import 'mock_path_provider_platform.dart';

// ignore_for_file: depend_on_referenced_packages
Future<void> setupInjection() async {
  await getIt.reset();
  TestWidgetsFlutterBinding.ensureInitialized();
  PathProviderPlatform.instance = MockPathProviderPlatform();
  initializeSingletons();
  await initializeEnvironmentConfig(Env.test);
  SharedPreferences.setMockInitialValues(<String, Object>{});
  await configureDependencies(Env.test);
}

User get mockUser => UserDTO(
      uid: 1,
      email: 'exampe@email.com',
      firstName: 'test',
      lastName: 'test',
      gender: 'Male',
      contactNumber: '123456789',
      birthday: DateTime(2000),
    ).toDomain();

List<Post> get mockPosts => <Post>[
      mockPost,
      mockPost,
    ];

Map<AppScrollController, ScrollController> mockScrollControllers =
    <AppScrollController, ScrollController>{
  AppScrollController.home: ScrollController(),
  AppScrollController.profile: ScrollController(),
};

Post get mockPost => PostDTO(
      uid: '1',
      title: 'Turpis in eu mi bibendum neque egestas congue.',
      author: 'Tempus egestas',
      permalink: '/r/FlutterDev/comments/123456/',
      selftext:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      createdUtc: DateTime.fromMillisecondsSinceEpoch(1672689610000),
      linkFlairBackgroundColor: '#7b35f0',
      linkFlairText: 'Lorem',
      upvotes: 10,
      comments: 2,
    ).toDomain();

chopper.Response<T> generateMockResponse<T>(T body, int statusCode) =>
    chopper.Response<T>(http.Response(json.encode(body), statusCode), body);

extension FileNameX on String {
  String get goldensVersion => '${this}_${TestConfig.goldensVersion}';
}
