import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  const EnvConfig._();

  static Future<void> load({String fileName = '.env'}) async {
    await dotenv.load(fileName: fileName);
  }

  static String get apiUrl =>
      dotenv.env['API_URL'] ?? 'https://jsonplaceholder.typicode.com';

  static String get apiKey => dotenv.env['API_KEY'] ?? '';

  static String get apiToken => dotenv.env['API_TOKEN'] ?? '';
}
