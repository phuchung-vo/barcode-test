import 'package:flutter/material.dart';
import 'package:flutter_base_code/app/constants/constant.dart';
import 'package:flutter_base_code/app/constants/enum.dart';
import 'package:flutter_base_code/app/helpers/extensions/build_context_ext.dart';
import 'package:flutter_base_code/app/helpers/injection.dart';
import 'package:flutter_base_code/app/themes/app_spacing.dart';
import 'package:flutter_base_code/app/utils/dialog_utils.dart';
import 'package:flutter_base_code/app/utils/error_message_utils.dart';
import 'package:flutter_base_code/core/domain/model/failure.dart';
import 'package:flutter_base_code/core/presentation/widgets/app_title.dart';
import 'package:flutter_base_code/core/presentation/widgets/connectivity_checker.dart';
import 'package:flutter_base_code/core/presentation/widgets/flutter_base_code_button.dart';
import 'package:flutter_base_code/core/presentation/widgets/flutter_base_code_text_field.dart';
import 'package:flutter_base_code/features/auth/domain/bloc/auth/auth_bloc.dart';
import 'package:flutter_base_code/features/auth/domain/bloc/login/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LoginScreen extends HookWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController passwordTextController =
        useTextEditingController();
    final TextEditingController emailTextController =
        useTextEditingController();

    return BlocProvider<LoginBloc>(
      create: (BuildContext context) => getIt<LoginBloc>(),
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: _onStateChangedListener,
        builder: (BuildContext context, LoginState state) {
          emailTextController
            ..value = TextEditingValue(text: state.emailAddress ?? '')
            ..selection = TextSelection.fromPosition(
              TextPosition(offset: emailTextController.text.length),
            );

          return PopScope(
            canPop: false,
            onPopInvoked: (bool didPop) async =>
                DialogUtils.showExitDialog(context),
            child: ConnectivityChecker.scaffold(
              backgroundColor: context.colorScheme.background,
              body: Center(
                child: Container(
                  padding: const EdgeInsets.all(Insets.xlarge),
                  constraints: const BoxConstraints(
                    maxWidth: Constant.mobileBreakpoint,
                  ),
                  child: Column(
                    children: <Widget>[
                      const Flexible(child: Center(child: AppTitle())),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            AppTextField(
                              controller: emailTextController,
                              labelText: context.l10n.login__label_text__email,
                              hintText:
                                  context.l10n.login__text_field_hint__email,
                              onChanged: (String value) => context
                                  .read<LoginBloc>()
                                  .onEmailAddressChanged(value),
                              autofocus: true,
                            ),
                            Gap.large(),
                            AppTextField(
                              controller: passwordTextController,
                              labelText:
                                  context.l10n.login__label_text__password,
                              hintText:
                                  context.l10n.login__text_field_hint__password,
                              textInputType: TextInputType.visiblePassword,
                              isPassword: true,
                            ),
                            Gap.xxxlarge(),
                            AppButton(
                              text: context.l10n.login__button_text__login,
                              isEnabled: !state.isLoading,
                              isExpanded: true,
                              buttonType: ButtonType.filled,
                              onPressed: () => context.read<LoginBloc>().login(
                                    emailTextController.text,
                                    passwordTextController.text,
                                  ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: Insets.small,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _onStateChangedListener(BuildContext context, LoginState state) {
    state.loginStatus.whenOrNull(
      success: () => context.read<AuthBloc>().authenticate(),
      failed: (Failure failure) => DialogUtils.showError(
        context,
        ErrorMessageUtils.generate(context, failure),
      ),
    );
  }
}
