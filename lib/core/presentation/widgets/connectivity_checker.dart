import 'dart:async';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_code/app/constants/enum.dart';
import 'package:flutter_base_code/app/helpers/extensions/build_context_ext.dart';
import 'package:flutter_base_code/app/helpers/injection.dart';
import 'package:flutter_base_code/app/themes/app_spacing.dart';
import 'package:flutter_base_code/app/themes/app_theme.dart';
import 'package:flutter_base_code/app/utils/connectivity_utils.dart';

class ConnectivityChecker extends StatefulWidget {
  const ConnectivityChecker({required this.child, super.key});

  final Widget child;

  static Widget scaffold({
    required Widget body,
    PreferredSizeWidget? appBar,
    Widget? bottomNavigationBar,
    Color? backgroundColor,
  }) =>
      ConnectivityChecker(
        child: Scaffold(
          body: body,
          appBar: appBar,
          backgroundColor: backgroundColor,
          bottomNavigationBar: bottomNavigationBar,
        ),
      );

  @override
  State<ConnectivityChecker> createState() => _ConnectivityCheckerState();
}

class _ConnectivityCheckerState extends State<ConnectivityChecker> {
  final ConnectivityUtils connectivityUtils = getIt<ConnectivityUtils>();
  StreamSubscription<ConnectionStatus>? _connectionSubscription;
  bool _isDialogShowing = false;
  FlashController<void>? _controller;

  Future<void> _showOfflineDialog(BuildContext context) async {
    await showFlash<void>(
      context: context,
      builder: (BuildContext context, FlashController<void> controller) {
        _controller = controller;
        return FlashBar<void>(
          controller: controller,
          position: FlashPosition.top,
          behavior: FlashBehavior.floating,
          margin: const EdgeInsets.symmetric(
            vertical: Insets.xxxlarge,
            horizontal: Insets.xxxlarge,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppTheme.defaultBoardRadius,
          ),
          clipBehavior: Clip.antiAlias,
          backgroundColor: context.colorScheme.background,
          surfaceTintColor: context.colorScheme.surfaceTint,
          icon: Icon(Icons.wifi_off, color: context.colorScheme.onSurface),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Insets.small),
            child: Text(
              context.l10n.common_error_no_internet_connection,
              style: context.textTheme.bodyLarge
                  ?.copyWith(color: context.colorScheme.onBackground),
            ),
          ),
        );
      },
    );
  }

  Future<void> _onStatusChanged(ConnectionStatus connectionStatus) async {
    switch (connectionStatus) {
      case ConnectionStatus.offline:
        if (!_isDialogShowing) {
          _isDialogShowing = true;
          await _showOfflineDialog(context);
          _isDialogShowing = false;
        }
      case ConnectionStatus.online:
        if (_isDialogShowing) {
          await _controller?.dismiss();
          _isDialogShowing = false;
        }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _onStatusChanged(await connectivityUtils.checkInternet());
      _connectionSubscription ??= connectivityUtils
          .internetStatus()
          .listen((ConnectionStatus event) async {
        await _onStatusChanged(event);
      });
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void dispose() {
    _connectionSubscription?.cancel();
    super.dispose();
  }
}
