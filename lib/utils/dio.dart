import 'package:dio/dio.dart';
import '.env.dart';


Dio dio(){

  Dio dio = Dio();
  dio.options.baseUrl = baseUri;
  dio.options.headers['accept'] = 'application/json';
  dio.options.headers['accept'] = 'application/json';
  dio.options.receiveDataWhenStatusError = true;
  dio.options.connectTimeout = 60*1000; //60s
  dio.options.receiveTimeout = 60*1000;
  return dio; 

}