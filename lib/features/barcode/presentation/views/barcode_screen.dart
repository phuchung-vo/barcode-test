import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_base_code/app/constants/constant.dart';
import 'package:flutter_base_code/app/helpers/extensions/build_context_ext.dart';
import 'package:flutter_base_code/app/themes/app_spacing.dart';
import 'package:flutter_base_code/app/themes/app_theme.dart';
import 'package:flutter_base_code/core/presentation/widgets/flutter_base_code_app_bar.dart';
import 'package:flutter_base_code/core/presentation/widgets/flutter_base_code_button.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BarcodeScreen extends StatefulHookWidget {
  const BarcodeScreen({super.key});

  @override
  State<BarcodeScreen> createState() => _BarcodeScreenState();
}

class _BarcodeScreenState extends State<BarcodeScreen> {
  String _scanBarcode = '0000000000000';

  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    if (barcodeScanRes == '-1') return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: context.colorScheme.background,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppTheme.defaultAppBarHeight),
          child: AppAppBar(
            titleColor: context.colorScheme.primary,
            actions: const <Widget>[],
          ),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: Constant.mobileBreakpoint,
            ),
            child: Container(
              alignment: Alignment.center,
              child: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  BarcodeWidget(
                    data: _scanBarcode,

                    /// Bar code format
                    barcode: Barcode.isbn(),
                    style: const TextStyle(fontSize: 20),
                  ),
                  Gap.medium(),
                  AppButton(
                      onPressed: scanBarcodeNormal, text: 'Start barcode scan'),
                ],
              ),
            ),
          ),
        ),
      );
}
