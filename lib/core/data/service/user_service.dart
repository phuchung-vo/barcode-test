import 'package:chopper/chopper.dart';

part 'user_service.chopper.dart';

@ChopperApi(baseUrl: 'api')
abstract interface class UserService extends ChopperService {
  @Get(path: '/users/2')
  Future<Response<dynamic>> getCurrentUser();

  static UserService create() => _$UserService();
}
