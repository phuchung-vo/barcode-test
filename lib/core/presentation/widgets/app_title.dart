import 'package:flutter/material.dart';
import 'package:flutter_base_code/app/constants/constant.dart';
import 'package:flutter_base_code/app/helpers/extensions/build_context_ext.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({super.key});

  @override
  Widget build(BuildContext context) => Text(
        Constant.appName,
        textAlign: TextAlign.center,
        style: context.textTheme.displayLarge
            ?.copyWith(color: context.colorScheme.primary),
      );
}
