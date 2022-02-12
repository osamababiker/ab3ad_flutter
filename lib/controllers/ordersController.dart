import 'package:ab3ad/models/Coupon.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ab3ad/models/Order.dart';
import 'package:ab3ad/utils/dio.dart';

const storage = FlutterSecureStorage();

List<Order> parseOrders(List responseBody) {
  return responseBody.map<Order>((json) => Order.fromJson(json)).toList();
}

Future<List<Order>> fetchOrders({required int userId}) async {
  String token = await storage.read(key: 'token') as String;
  Dio.Response response = await dio().get('/orders/$userId',
      options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
  if (response.statusCode == 200) {
    return parseOrders(response.data['data']);
  } else {
    throw Exception('Failed to load');
  }
}

Future<List<Order>> fetchAllOrders() async {
  try {
    String token = await storage.read(key: 'token') as String;
    Dio.Response response = await dio().get('/orders/all',
        options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
    if (response.statusCode == 200) {
      return parseOrders(response.data['data']);
    } else {
      throw Exception('Failed to load');
    }
  } catch (ex) {
    print(ex);
    throw Exception('Failed to load');
  }
}

Future deleteOrders({required int orderId}) async {
  try {
    String token = await storage.read(key: 'token') as String;
    Dio.Response response = await dio().get('/orders/delete/$orderId',
        options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to load');
    }
  } catch (ex) {
    print(ex);
  }
}

Future fetchCoupon({required Map data}) async {
  try {
    Dio.Response response = await dio().post('/coupons', data: data);
    if (response.statusCode == 200 && response.data['data'] != null) {
      return Coupon.fromJson(response.data['data']);
    } else {
      return null;
    }
  } catch (ex) {
    print(ex);
    throw Exception(ex);
  }
}

Future<bool> checkout({required Map data}) async {
  try {
    String token = await storage.read(key: 'token') as String;
    Dio.Response response = await dio().post('/orders/send',
        data: data,
        options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));

    if (response.statusCode == 201) {
      return true;
    } else {
      print(response.data['data']);
      throw Exception('Failed to load');
    }
  } catch (ex) {
    print(ex);
    throw Exception(ex);
  }
}
