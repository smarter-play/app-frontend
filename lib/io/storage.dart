import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

Future<void> saveSession(String token) async {
  await storage.write(key: "token", value: token);
}

Future<String?> getSession() async {
  return await storage.read(key: "token");
}
