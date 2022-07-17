import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:ab3ad/models/User.dart';
import 'package:ab3ad/utils/dio.dart';

class Auth extends ChangeNotifier {
  bool _isLoggedIn = false;
  late User _user;
  late String _token;
  final storage = const FlutterSecureStorage();

  bool get authenticated => _isLoggedIn;
  User get user => _user;

  Future<bool> login({required Map creds}) async {
    try {
      Dio.Response response = await dio().post('/sanctum/token', data: creds);
      String token = response.data.toString();
      if (response.statusCode == 401) {
        return false;
      }
      await tryToken(token: token);
      return true;
    } catch (ex) {
      return false;
    }
  }

  Future<Map> register({required Map fields}) async {
    Map apiResult = {};
    try {
      Dio.Response response = await dio().post('/register', data: fields);
      if (response.data['errors'] == '') {
        apiResult = {
          'errors': false,
          'message': '',
          'data': response.data['user']
        };
      } else {
        if (response.data['errors']['notificationToken'] != null) {
          apiResult = {
            'errors': true,
            'message': response.data['errors']['notificationToken'][0],
            'data': ''
          };
        } else if (response.data['errors']['address'] != null) {
          apiResult = {
            'errors': true,
            'message': response.data['errors']['address'][0],
            'data': ''
          };
        } else if (response.data['errors']['password'] != null) {
          apiResult = {
            'errors': true,
            'message': response.data['errors']['password'][0],
            'data': ''
          };
        } else if (response.data['errors']['phone'] != null) {
          apiResult = {
            'errors': true,
            'message': response.data['errors']['phone'][0],
            'data': ''
          };
        }
      }
      return apiResult;
    } catch (ex) {
      print(ex);
      throw Exception(ex);
    }
  }

  Future<void> tryToken({required String token}) async {
    try {
      Dio.Response response = await dio().get('/user',
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      _token = token;
      _isLoggedIn = true;
      _user = User.fromJson(response.data);
      await storeToken(token: token);
      notifyListeners();
    } catch (ex) {
      print(ex);
    }
  }

  Future<void> storeToken({required String token}) async {
    await storage.write(key: 'token', value: token);
  }

  Future<String> readToken() async {
    String token = await storage.read(key: 'token') as String;
    return token;
  }

  Future<void> logout() async {
    try {
      Dio.Response response = await dio().get('/user/revoke',
          options: Dio.Options(headers: {'Authorization': 'Bearer $_token'}));
      cleanToken();
      notifyListeners();
    } on Dio.DioError catch (ex) {}
  }

  void cleanToken() async {
    _isLoggedIn = false;
    _token = '';
    await storage.delete(key: 'token');
  }
}
