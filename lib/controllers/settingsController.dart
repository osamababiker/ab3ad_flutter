import 'package:dio/dio.dart' as Dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ab3ad/models/Setting.dart';

import 'package:ab3ad/utils/dio.dart';
 



const storage = FlutterSecureStorage();

Future<Setting> fetchSettings() async { 
  try {
    Dio.Response response = await dio().get(
      '/settings',
    );
    if (response.statusCode == 200) {
      return Setting.fromJson((response.data['data'])); 
    } else { 
      throw Exception('Failed to load');
    }
  } catch (e) {
    print(e);
    throw Exception('Failed to load');
  }
}  