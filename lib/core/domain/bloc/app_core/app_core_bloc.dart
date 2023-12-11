import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_code/app/constants/enum.dart';
import 'package:flutter_base_code/app/helpers/extensions/cubit_ext.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'app_core_bloc.freezed.dart';
part 'app_core_state.dart';

@lazySingleton
class AppCoreBloc extends Cubit<AppCoreState> {
  AppCoreBloc() : super(AppCoreState.initial());

  void setScrollControllers(
    Map<AppScrollController, ScrollController> scrollControllers,
  ) =>
      safeEmit(state.copyWith(scrollControllers: scrollControllers));
}
