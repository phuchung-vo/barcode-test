import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_code/core/domain/model/value_object.dart';
import 'package:flutter_base_code/features/home/presentation/widgets/post_container_header.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../utils/mock_localization.dart';
import '../../../../utils/test_utils.dart';

void main() {
  group('PostContainerHeader Widget Tests', () {
    goldenTest(
      'renders correctly',
      fileName: 'post_container_header'.goldensVersion,
      builder: () => GoldenTestGroup(
        children: <Widget>[
          GoldenTestScenario(
            name: 'default',
            child: MockLocalization(child: PostContainerHeader(post: mockPost)),
          ),
          GoldenTestScenario(
            name: 'without tag',
            child: MockLocalization(
              child: PostContainerHeader(
                post: mockPost.copyWith(linkFlairText: ValueString()),
              ),
            ),
          ),
        ],
      ),
    );
  });
}
