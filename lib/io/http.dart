import 'package:dio/dio.dart';
import '../models.dart';

bool emulator = false;

final _client = Dio(BaseOptions(
  baseUrl: emulator ? 'http://10.0.2.2:8080' : 'http://192.168.1.9:8080',
));

void setAuthHeader(String token) {
  _client.options.headers['Authorization'] = 'Bearer $token';
}

void resetAuthHeaders() {
  _client.options.headers.remove('Authorization');
}

final backend = Backend(_client);

class Backend {
  const Backend(this._dio);

  final Dio _dio;

  Future<List<User>> getUsers() async {
    final response = await _dio.get('/users');
    return (response.data as List).map((e) => User.fromJson(e)).toList();
  }

  Future<String?> logIn(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      return response.data;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<String?> signUp(User user, String password) async {
    final response = await _dio.post('/auth/register', data: {
      'email': user.email,
      'password': password,
      "name": user.name,
      "surname": user.surname,
      "date_of_birth": user.dateOfBirth.toIso8601String()
    });
    return response.data;
  }

  Future<User> getCurrentUser() async {
    final response = await _dio.get('/auth');
    return User.fromJson(response.data);
  }

  Future<void> editUser(
      String name, String surname, String email, DateTime date) async {
    await _dio.put('/auth', data: {
      "name": name,
      "surname": surname,
      "email": email,
      "date_of_birth": date.toIso8601String()
    });
  }

  Future<List<Court>> getCourtsInRange(
      double lat, double lon, double range) async {
    final response = await _dio.get('/courts', queryParameters: {
      'lat': lat,
      'lon': lon,
      'range': range,
    });
    return (response.data as List).map((e) => Court.fromJson(e)).toList();
  }
}
