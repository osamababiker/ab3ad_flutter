import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ab3ad/models/Directions.dart';
import '.env.dart'; 

class DirectionsHelper {

  static const String  _baseUrl = "https://maps.googleapis.com/maps/api/directions/json?";
  final _dio = Dio();
  
  Future<Directions?> getDirections({
    required LatLng origin,
    required LatLng destination, 
  }) async {
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        'origin': '${origin.latitude}, ${origin.longitude}',
        'destination': '${destination.latitude}, ${destination.longitude}',
        'key': googleApiKey
      },
    );

    if(response.statusCode == 200){
      return Directions.fromMap(response.data);
    }

    return null;

  }
}