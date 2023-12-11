import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_code/app/constants/enum.dart';
import 'package:flutter_base_code/core/domain/bloc/app_core/app_core_bloc.dart';
import 'package:flutter_base_code/features/auth/domain/bloc/auth/auth_bloc.dart';
import 'package:flutter_base_code/features/profile/presentation/views/profile_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../utils/golden_test_device_scenario.dart';
import '../../../../utils/mock_material_app.dart';
import '../../../../utils/test_utils.dart';
import 'profile_screen_test.mocks.dart';

@GenerateNiceMocks(<MockSpec<dynamic>>[
  MockSpec<AuthBloc>(),
  MockSpec<AppCoreBloc>(),
])
void main() {
  late MockAuthBloc authBloc;
  late MockAppCoreBloc appCoreBloc;
  late Map<AppScrollController, ScrollController> scrollControllers;

  setUp(() {
    authBloc = MockAuthBloc();
    appCoreBloc = MockAppCoreBloc();
    scrollControllers = mockScrollControllers;
    when(appCoreBloc.stream).thenAnswer(
      (_) => Stream<AppCoreState>.fromIterable(
        <AppCoreState>[
          AppCoreState.initial().copyWith(scrollControllers: scrollControllers),
        ],
      ),
    );
    when(appCoreBloc.state).thenAnswer(
      (_) =>
          AppCoreState.initial().copyWith(scrollControllers: scrollControllers),
    );
  });

  AuthBloc setUpAuthBloc(Stream<AuthState> stream, AuthState state) {
    authBloc = MockAuthBloc();
    when(authBloc.stream).thenAnswer((_) => stream);
    when(authBloc.state).thenAnswer((_) => state);
    return authBloc;
  }

  Widget buildProfileScreen(AuthBloc authBloc) => MultiBlocProvider(
        providers: <BlocProvider<dynamic>>[
          BlocProvider<AuthBloc>(
            create: (BuildContext context) => authBloc,
          ),
          BlocProvider<AppCoreBloc>(
            create: (BuildContext context) => appCoreBloc,
          ),
        ],
        child: const MockMaterialApp(
          child: Scaffold(
            body: ProfileScreen(),
          ),
        ),
      );

  group('Profile Screen Tests', () {
    goldenTest(
      'renders correctly',
      fileName: 'profile_screen'.goldensVersion,
      pumpBeforeTest: (WidgetTester tester) async {
        await tester.pump(const Duration(seconds: 1));
      },
      builder: () => GoldenTestGroup(
        children: <Widget>[
          GoldenTestDeviceScenario(
            name: 'default',
            builder: () => buildProfileScreen(
              setUpAuthBloc(
                Stream<AuthState>.fromIterable(<AuthState>[
                  AuthState.authenticated(
                    user: mockUser,
                  ),
                ]),
                AuthState.authenticated(
                  user: mockUser,
                ),
              ),
            ),
          ),
          GoldenTestDeviceScenario(
            name: 'loading',
            builder: () => buildProfileScreen(
              setUpAuthBloc(
                Stream<AuthState>.fromIterable(<AuthState>[
                  const AuthState.loading(),
                ]),
                const AuthState.loading(),
              ),
            ),
          ),
        ],
      ),
    );
  });
}
