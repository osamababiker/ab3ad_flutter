import 'package:dio/dio.dart' as Dio;
import 'package:ab3ad/models/Evaluation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:ab3ad/utils/dio.dart';




const storage = FlutterSecureStorage();

List<Evaluation> parseEvaluations(List responseBody) {
  return responseBody.map<Evaluation>((json) => Evaluation.fromJson(json)).toList();
}

Future<List<Evaluation>> fetchEvaluation({required int userId}) async { 
  try {
    String token = await storage.read(key: 'token') as String;
    Dio.Response response = await dio().get(
      '/evaluation/$userId', 
      options: Dio.Options(headers: {'Authorization': 'Bearer $token'})
    );
    if (response.statusCode == 200) {
      return parseEvaluations(response.data['data']); 
    } else {
      throw Exception('Failed to load');
    }
  } catch (e) {
    print(e);
    throw Exception('Failed to load');
  }
}  



Future<bool> saveEvaluation({required Map data}) async { 
  try {
    String token = await storage.read(key: 'token') as String;
    Dio.Response response = await dio().post(
      '/evaluation/save',
      data: data,
      options: Dio.Options(headers: {'Authorization': 'Bearer $token'})
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print(e);
    return false;
  }
}  






