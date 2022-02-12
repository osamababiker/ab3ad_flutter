import 'package:dio/dio.dart' as Dio;
import 'package:ab3ad/models/Category.dart';

import 'package:ab3ad/utils/dio.dart';



List<Category> parseCategories(List responseBody) {
  return responseBody.map<Category>((json) => Category.fromJson(json)).toList();
} 
 
Future<List<Category>> fetchCategories() async { 
  Dio.Response response = await dio().get('/categories');
  if (response.statusCode == 200) {
    return parseCategories(response.data['data']); 
  } else {
    throw Exception('Failed to load');  
  }
}  




