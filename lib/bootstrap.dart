import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_code/app/config/chopper_config.dart';
import 'package:flutter_base_code/app/config/url_strategy_native.dart'
    if (dart.library.html) 'package:flutter_base_code/app/config/url_strategy_web.dart';
import 'package:flutter_base_code/app/constants/enum.dart';
import 'package:flutter_base_code/app/generated/assets.gen.dart';
import 'package:flutter_base_code/app/helpers/injection.dart';
import 'package:flutter_base_code/app/observers/app_bloc_observer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder, Env env) async {
  urlConfig();
  initializeSingletons();
  await initializeEnvironmentConfig(env);
  await configureDependencies(env);

  final Logger logger = getIt<Logger>();
  Bloc.observer = getIt<AppBlocObserver>();

  FlutterError.onError = (FlutterErrorDetails details) {
    logger.f(
      details.exceptionAsString(),
      error: details,
      stackTrace: details.stack,
    );
  };
  WidgetsFlutterBinding.ensureInitialized();
  runApp(await builder());
}

void initializeSingletons() {
  getIt
    ..registerLazySingleton<Logger>(
      () => Logger(
        filter: ProductionFilter(),
        printer: PrettyPrinter(),
        output: ConsoleOutput(),
      ),
    )
    ..registerLazySingleton<ChopperClient>(
      () => ChopperConfig().client,
    );
}

Future<void> initializeEnvironmentConfig(Env env) async {
  switch (env) {
    case Env.development:
    case Env.test:
      await dotenv.load(fileName: Assets.env.envDevelopment);
    case Env.staging:
      await dotenv.load(fileName: Assets.env.envStaging);
    case Env.production:
      await dotenv.load(fileName: Assets.env.envProduction);
  }
}
