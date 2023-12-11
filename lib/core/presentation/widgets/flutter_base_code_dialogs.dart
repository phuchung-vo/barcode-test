import 'package:flutter/material.dart';
import 'package:flutter_base_code/app/constants/enum.dart';
import 'package:flutter_base_code/app/helpers/extensions/build_context_ext.dart';
import 'package:flutter_base_code/app/themes/app_spacing.dart';
import 'package:flutter_base_code/app/themes/app_theme.dart';
import 'package:flutter_base_code/core/presentation/widgets/flutter_base_code_button.dart';

// ignore_for_file: prefer-match-file-name
class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    required this.message,
    this.title,
    this.titleColor,
    this.negativeButtonText,
    this.positiveButtonText,
    this.onNegativePressed,
    this.onPositivePressed,
    this.negativeButtonColor,
    this.positiveButtonColor,
    this.negativeButtonTextColor,
    this.positiveButtonTextColor,
    super.key,
  });
  final String message;
  final String? title;
  final Color? titleColor;
  final String? negativeButtonText;
  final String? positiveButtonText;
  final VoidCallback? onNegativePressed;
  final VoidCallback? onPositivePressed;
  final Color? negativeButtonColor;
  final Color? positiveButtonColor;
  final Color? negativeButtonTextColor;
  final Color? positiveButtonTextColor;

  @override
  Widget build(BuildContext context) => AlertDialog(
        backgroundColor: context.colorScheme.background,
        surfaceTintColor: context.colorScheme.surfaceTint,
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.defaultBoardRadius,
        ),
        title: title != null
            ? Text(title!, style: context.textTheme.titleMedium)
            : null,
        content: Padding(
          padding: title != null
              ? EdgeInsets.zero
              : const EdgeInsets.only(top: Insets.xxsmall),
          child: Text(
            message,
            style: context.textTheme.bodyMedium?.copyWith(
              color: titleColor ?? context.colorScheme.onBackground,
            ),
          ),
        ),
        actions: <Widget>[
          AppButton(
            text: negativeButtonText ?? context.l10n.common_no.toUpperCase(),
            buttonType: ButtonType.text,
            onPressed: onNegativePressed ?? () => Navigator.of(context).pop(),
            padding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            textStyle: TextStyle(
              color: negativeButtonTextColor ?? context.colorScheme.primary,
            ),
          ),
          AppButton(
            text: positiveButtonText ?? context.l10n.common_yes.toUpperCase(),
            buttonType: ButtonType.text,
            onPressed: onPositivePressed ?? () => Navigator.of(context).pop(),
            padding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            textStyle: TextStyle(
              color: positiveButtonTextColor ?? context.colorScheme.primary,
            ),
          ),
        ],
        actionsPadding: const EdgeInsets.symmetric(horizontal: Insets.medium),
        buttonPadding: EdgeInsets.zero,
      );
}
