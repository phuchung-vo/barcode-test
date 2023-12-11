import 'dart:developer';

import 'package:flutter_base_code/app/helpers/extensions/cubit_ext.dart';
import 'package:flutter_base_code/core/domain/model/failure.dart';
import 'package:flutter_base_code/features/home/domain/interface/i_post_repository.dart';
import 'package:flutter_base_code/features/home/domain/model/post.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'post_bloc.freezed.dart';
part 'post_state.dart';

@injectable
class PostBloc extends Cubit<PostState> {
  PostBloc(
    this._postRepository,
  ) : super(const PostState.initial());

  final IPostRepository _postRepository;

  Future<void> initialize() async {
    await getPosts();
  }

  Future<void> getPosts() async {
    try {
      safeEmit(const PostState.loading());

      final Either<Failure, List<Post>> possibleFailure =
          await _postRepository.getPosts();

      safeEmit(
        possibleFailure.fold(
          PostState.failed,
          PostState.success,
        ),
      );
    } catch (error) {
      log(error.toString());

      safeEmit(
        PostState.failed(
          Failure.unexpected(error.toString()),
        ),
      );
    }
  }
}
