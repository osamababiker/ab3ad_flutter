import 'package:dio/dio.dart' as Dio;
import 'package:ab3ad/models/Item.dart';

import 'package:ab3ad/utils/dio.dart';

List<Item> parseItems(List responseBody) {
  return responseBody.map<Item>((json) => Item.fromJson(json)).toList();
}

Future<List<Item>> fetchItems() async {
  Dio.Response response = await dio().get('/items');
  if (response.statusCode == 200) {
    return parseItems(response.data['data']);
  } else {
    throw Exception('Failed to load');
  }
}

Future<List<Item>> fetchItemsByCategory(categoryId) async {
  Dio.Response response = await dio().get('/items/$categoryId');
  if (response.statusCode == 200) {
    return parseItems(response.data['data']);
  } else {
    throw Exception('Failed to load');
  }
}
