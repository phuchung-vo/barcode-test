import 'package:flutter_base_code/app/constants/enum.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final class AppConfig {
  static Env get environment => switch (dotenv.get('ENV')) {
        'Development' => Env.development,
        'Staging' => Env.staging,
        'Production' => Env.production,
        _ => Env.development
      };
  static String get baseApiUrl => dotenv.get('BASE_API_URL');
}
