import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_code/core/presentation/widgets/app_title.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils/test_utils.dart';

void main() {
  group('AppTile Widget Tests', () {
    goldenTest(
      'renders correctly',
      fileName: 'app_title'.goldensVersion,
      builder: () => GoldenTestGroup(
        children: <Widget>[
          GoldenTestScenario(
            name: 'default',
            child: const AppTitle(),
          ),
        ],
      ),
    );
  });
}
