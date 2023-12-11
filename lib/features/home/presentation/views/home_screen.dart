import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_code/app/constants/constant.dart';
import 'package:flutter_base_code/app/constants/enum.dart';
import 'package:flutter_base_code/app/constants/route_name.dart';
import 'package:flutter_base_code/app/helpers/extensions/build_context_ext.dart';
import 'package:flutter_base_code/app/helpers/injection.dart';
import 'package:flutter_base_code/app/themes/app_spacing.dart';
import 'package:flutter_base_code/app/themes/app_theme.dart';
import 'package:flutter_base_code/app/utils/dialog_utils.dart';
import 'package:flutter_base_code/app/utils/error_message_utils.dart';
import 'package:flutter_base_code/core/domain/bloc/app_core/app_core_bloc.dart';
import 'package:flutter_base_code/core/domain/bloc/theme/theme_bloc.dart';
import 'package:flutter_base_code/core/domain/model/failure.dart';
import 'package:flutter_base_code/core/domain/model/user.dart';
import 'package:flutter_base_code/core/presentation/widgets/flutter_base_code_app_bar.dart';
import 'package:flutter_base_code/core/presentation/widgets/flutter_base_code_avatar.dart';
import 'package:flutter_base_code/features/auth/domain/bloc/auth/auth_bloc.dart';
import 'package:flutter_base_code/features/home/domain/bloc/post/post_bloc.dart';
import 'package:flutter_base_code/features/home/domain/model/post.dart';
import 'package:flutter_base_code/features/home/presentation/widgets/empty_post.dart';
import 'package:flutter_base_code/features/home/presentation/widgets/post_container.dart';
import 'package:flutter_base_code/features/home/presentation/widgets/post_container_loading.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconColor = context.colorScheme.onSecondaryContainer;

    return Scaffold(
      backgroundColor: context.colorScheme.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppTheme.defaultAppBarHeight),
        child: AppAppBar(
          titleColor: context.colorScheme.primary,
          actions: <Widget>[
            IconButton(
              onPressed: () => context
                  .read<ThemeBloc>()
                  .switchTheme(Theme.of(context).brightness),
              icon: Theme.of(context).brightness == Brightness.dark
                  ? Icon(Icons.light_mode, color: iconColor)
                  : Icon(Icons.dark_mode, color: iconColor),
            ),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (BuildContext context, AuthState state) =>
                  state.maybeWhen(
                orElse: SizedBox.shrink,
                authenticated: (User user) => GestureDetector(
                  onTap: () =>
                      GoRouter.of(context).goNamed(RouteName.profile.name),
                  child: AppAvatar(
                    size: 32,
                    imageUrl: user.avatar?.getOrCrash(),
                    padding: const EdgeInsets.all(Insets.small),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: Constant.mobileBreakpoint,
          ),
          child: _HomeContent(),
        ),
      ),
    );
  }
}

class _HomeContent extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> isDialogShowing = useState(false);

    return BlocProvider<PostBloc>(
      create: (BuildContext context) => getIt<PostBloc>()..getPosts(),
      child: Builder(
        builder: (BuildContext context) => RefreshIndicator(
          onRefresh: () => context.read<PostBloc>().getPosts(),
          color: context.colorScheme.primary,
          backgroundColor: context.colorScheme.background,
          child: BlocConsumer<PostBloc, PostState>(
            listener: (BuildContext context, PostState state) =>
                _onStateChangeListener(context, state, isDialogShowing),
            builder: (BuildContext context, PostState state) => state.maybeWhen(
              success: (List<Post> posts) => posts.isNotEmpty
                  ? BlocSelector<AppCoreBloc, AppCoreState,
                      Map<AppScrollController, ScrollController>>(
                      selector: (AppCoreState state) => state.scrollControllers,
                      builder: (
                        BuildContext context,
                        Map<AppScrollController, ScrollController>
                            scrollController,
                      ) =>
                          ListView.separated(
                        padding: const EdgeInsets.only(top: Insets.medium),
                        controller: scrollController.isNotEmpty
                            ? scrollController[AppScrollController.home]
                            : ScrollController(),
                        itemBuilder: (BuildContext context, int index) =>
                            PostContainer(post: posts[index]),
                        separatorBuilder: (BuildContext context, int index) =>
                            const Gap(Insets.small),
                        itemCount: posts.length,
                      ),
                    )
                  : const EmptyPost(),
              orElse: PostContainerLoading.new,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onStateChangeListener(
    BuildContext context,
    PostState state,
    ValueNotifier<bool> isDialogShowing,
  ) async {
    await state.whenOrNull(
      failed: (Failure failure) async {
        isDialogShowing.value = true;

        await DialogUtils.showError(
          context,
          ErrorMessageUtils.generate(context, failure),
          position: FlashPosition.top,
        );
        isDialogShowing.value = false;
      },
    );
  }
}
