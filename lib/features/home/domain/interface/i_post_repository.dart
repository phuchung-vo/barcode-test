import 'package:flutter_base_code/core/domain/model/failure.dart';
import 'package:flutter_base_code/features/home/domain/model/post.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class IPostRepository {
  Future<Either<Failure, List<Post>>> getPosts();
}
