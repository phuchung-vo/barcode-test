import 'package:flutter/material.dart';
import 'package:flutter_base_code/app/config/scroll_behavior_config.dart';
import 'package:flutter_base_code/app/constants/constant.dart';
import 'package:flutter_base_code/app/generated/l10n.dart';
import 'package:flutter_base_code/app/themes/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MockMaterialApp extends StatelessWidget {
  const MockMaterialApp({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: child,
        title: Constant.appName,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.delegate.supportedLocales,
        debugShowCheckedModeBanner: false,
        scrollBehavior: ScrollBehaviorConfig(),
      );
}
