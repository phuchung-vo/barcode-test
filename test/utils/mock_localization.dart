import 'package:flutter/material.dart';
import 'package:flutter_base_code/app/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MockLocalization extends StatelessWidget {
  const MockLocalization({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => Localizations(
        locale: const Locale('en'),
        delegates: const <LocalizationsDelegate<dynamic>>[
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        child: child,
      );
}
