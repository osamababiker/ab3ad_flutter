import 'package:ab3ad/models/DeliveryRequest.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ab3ad/utils/dio.dart';

const storage = FlutterSecureStorage();

List<DeliveryRequest> parseDeliveryRequests(List responseBody) {
  return responseBody.map<DeliveryRequest>((json) => DeliveryRequest.fromJson(json)).toList();
}
 

Future<List<DeliveryRequest>> fetchDeliveryRequests({required int userId}) async {
  String token = await storage.read(key: 'token') as String;
  Dio.Response response = await dio().get('/delivery/request/$userId',
      options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
  if (response.statusCode == 200) {
    return parseDeliveryRequests(response.data['data']);
  } else {
    throw Exception('Failed to load');
  }
}


Future<DeliveryRequest> fetchAcceptedDeliveryRequests({required int orderId}) async {
  String token = await storage.read(key: 'token') as String;
  Dio.Response response = await dio().get('/delivery/request/accepted/$orderId',
      options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
  if (response.statusCode == 200) {
    return DeliveryRequest.fromJson(response.data['data']);
  } else {
    throw Exception('Failed to load');
  }
}

Future<bool> sendDeliveryRequest({required Map formData}) async {
  try {
    String token = await storage.read(key: 'token') as String;
    Dio.Response response = await dio().post('/delivery/request/store',
        data: formData,
        options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Failed to load');
    }
  } catch (ex) {
    print(ex);
    throw Exception(ex);
  }
}


Future<bool> orderCompleteSign({required Map formData}) async {
  try {
    String token = await storage.read(key: 'token') as String;
    Dio.Response response = await dio().post('/delivery/order/complete',
        data: formData,
        options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to load');
    }
  } catch (ex) {
    print(ex);
    throw Exception(ex);
  }
}


