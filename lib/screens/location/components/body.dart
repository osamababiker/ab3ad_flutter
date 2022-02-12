import 'dart:convert';

import 'package:ab3ad/controllers/ordersController.dart';
import 'package:ab3ad/screens/order/order_complete.dart';
import 'package:ab3ad/screens/sign_in/sign_in_screen.dart';
import 'package:ab3ad/utils/cart_db_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocode/geocode.dart';
import 'package:provider/provider.dart';
import 'package:ab3ad/controllers/authController.dart';
import '../../../constants.dart';

class Body extends StatefulWidget {
  final Position currentLocation;
  const Body({Key? key, required this.currentLocation}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late GoogleMapController mapController;
  Map<MarkerId, Marker> markers = {};
  late double _currentLat = 0.0;
  late double _currentLng = 0.0;

  @override
  void initState() {
    super.initState();
    _setMarkers();
  }

  _setMarkers() async {
    /// origin marker
    var location = await _getCurrentPosition();
    _addMarker(LatLng(location.latitude, location.longitude), "موقعك",
        BitmapDescriptor.defaultMarker);
  }

  Future<Position> _getCurrentPosition() async {
    // to get current user location
    final _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentLat = _currentPosition.latitude;
      _currentLng = _currentPosition.longitude;
    });
    return _currentPosition;
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (_currentLat != 0 && _currentLng != 0) {
      return SizedBox(
        width: size.width,
        height: size.height * 0.8,
        child: Stack(
          alignment: Alignment.center,
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: LatLng(_currentLat, _currentLng), zoom: 15),
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              onMapCreated: _onMapCreated,
              mapToolbarEnabled: true,
              markers: Set<Marker>.of(markers.values),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: size.width,
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30))),
                child: Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                            keyboardType: TextInputType.text,
                            onChanged: (value) async {
                              GeoCode geoCode = GeoCode();
                              try {
                                Coordinates coordinates = await geoCode
                                    .forwardGeocoding(address: value);
                                setState(() {
                                  _currentLat = coordinates.latitude!;
                                  _currentLng = coordinates.longitude!;
                                });
                              } catch (e) {
                                print(e);
                              }
                            },
                            decoration: const InputDecoration(
                              hintText: "ابحث عن موقع معين",
                              hintStyle:
                                  TextStyle(color: kTextColor, fontSize: 14),
                              contentPadding: EdgeInsets.all(kDefaultPadding),
                            )),
                        const SizedBox(height: 5),
                        TextButton(
                            child: Container(
                              padding:
                                  const EdgeInsets.all(kDefaultPadding / 2),
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(5)),
                              child: const Text("ارسل الطلب",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14)),
                            ),
                            onPressed: () async {
                              var authProvider =
                                  Provider.of<Auth>(context, listen: false); 
                              var cartProvider =
                                  Provider.of<CartDatabaseHelper>(context,
                                      listen: false);
                              List cart = await cartProvider.getItems();
                              if (authProvider.authenticated) {
                                var user = authProvider.user;
                                List cartList = [];
                                for (var i = 0; i < cart.length; i++) {
                                  var cartMap = cart[i].toMap();
                                  cartList.add(cartMap);
                                }
                                Map data = {
                                  'userId': user.id,
                                  'cart': jsonEncode(cartList),
                                  "lat": _currentLat,
                                  "lng": _currentLng,
                                  'status': 0
                                };
                                await checkout(data: data);
                                var db = CartDatabaseHelper();
                                for (var i = 0; i < cart.length; i++) {
                                  await db.deleteItem(cart[i].id);
                                }
                                Navigator.pushReplacementNamed(
                                context, OrderCompleteScreen.routeName);
                              } else {
                                Navigator.pushNamed(
                                    context, SignInScreen.routeName);
                              }
                            })
                      ]),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}
