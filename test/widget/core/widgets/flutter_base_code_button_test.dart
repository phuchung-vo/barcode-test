import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_code/app/constants/enum.dart';
import 'package:flutter_base_code/core/presentation/widgets/flutter_base_code_button.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils/test_utils.dart';

void main() {
  group('AppButton Widget Tests', () {
    int counter = 0;

    List<Widget> buildButtons(Widget? icon, ButtonType buttonType) => <Widget>[
          GoldenTestScenario(
            name: 'default ${buttonType.name} button',
            child: AppButton(
              text: 'Button',
              buttonType: buttonType,
              onPressed: () => counter++,
              icon: icon,
            ),
          ),
          GoldenTestScenario(
            name: 'isExpanded ${buttonType.name} button',
            constraints: const BoxConstraints(minWidth: 200),
            child: AppButton(
              text: 'Button',
              isExpanded: true,
              buttonType: buttonType,
              onPressed: () => counter++,
              icon: icon,
            ),
          ),
          GoldenTestScenario(
            name: 'isDisabled ${buttonType.name} button',
            child: AppButton(
              text: 'Button',
              isEnabled: false,
              buttonType: buttonType,
              onPressed: () => counter++,
              icon: icon,
            ),
          ),
          GoldenTestScenario(
            name: 'isDisabled & isExpanded ${buttonType.name} button',
            constraints: const BoxConstraints(minWidth: 200),
            child: AppButton(
              text: 'Button',
              isEnabled: false,
              isExpanded: true,
              buttonType: buttonType,
              onPressed: () => counter++,
              icon: icon,
            ),
          ),
        ];

    GoldenTestGroup buildButtonTestGroup({Widget? icon}) => GoldenTestGroup(
          children: <Widget>[
            ...buildButtons(icon, ButtonType.elevated),
            ...buildButtons(icon, ButtonType.filled),
            ...buildButtons(icon, ButtonType.tonal),
            ...buildButtons(icon, ButtonType.outlined),
            ...buildButtons(icon, ButtonType.text),
          ],
        );

    goldenTest(
      'renders correctly ',
      fileName: 'flutter_base_code_button'.goldensVersion,
      pumpBeforeTest: (WidgetTester tester) async {
        await tester.pump(const Duration(seconds: 1));
      },
      builder: buildButtonTestGroup,
    );
    goldenTest(
      'renders correctly and with icon',
      fileName: 'flutter_base_code_button_icon'.goldensVersion,
      pumpBeforeTest: (WidgetTester tester) async {
        await tester.pump(const Duration(seconds: 1));
      },
      builder: () => buildButtonTestGroup(icon: const Icon(Icons.add)),
    );
  });
}
