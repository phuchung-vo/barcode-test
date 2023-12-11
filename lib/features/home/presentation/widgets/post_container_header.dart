import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_code/app/helpers/extensions/build_context_ext.dart';
import 'package:flutter_base_code/app/helpers/extensions/datetime_ext.dart';
import 'package:flutter_base_code/app/themes/app_colors.dart';
import 'package:flutter_base_code/app/themes/app_spacing.dart';
import 'package:flutter_base_code/app/themes/app_theme.dart';
import 'package:flutter_base_code/features/home/domain/model/post.dart';

class PostContainerHeader extends StatelessWidget {
  const PostContainerHeader({
    required this.post,
    super.key,
  });

  final Post post;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(Insets.xsmall),
            child: Text(
              context.l10n.post__post_details__author_and_created_date(
                post.author.getOrCrash(),
                post.createdUtc.ago,
              ),
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.secondary,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              if (post.linkFlairText.getOrCrash().isNotNullOrBlank)
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: Insets.xxsmall,
                    horizontal: Insets.xsmall,
                  ),
                  decoration: BoxDecoration(
                    color: _getBackgroundColor(
                      context,
                      post.linkFlairBackgroundColor,
                    ),
                    borderRadius: AppTheme.defaultBoardRadius,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: Insets.xsmall),
                  child: Text(
                    post.linkFlairText.getOrCrash(),
                    style: context.textTheme.bodySmall
                        ?.copyWith(color: context.colorScheme.onSecondary),
                  ),
                ),
              if (!post.linkFlairText.getOrCrash().isNotNullOrBlank)
                Gap.medium(),
              Expanded(
                child: Text(
                  post.title.getOrCrash(),
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.colorScheme.onSecondaryContainer,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ],
      );

  Color _getBackgroundColor(
    BuildContext context,
    Color linkFlairBackgroundColor,
  ) =>
      linkFlairBackgroundColor == AppColors.transparent
          ? context.colorScheme.secondary.withOpacity(0.5)
          : linkFlairBackgroundColor;
}
