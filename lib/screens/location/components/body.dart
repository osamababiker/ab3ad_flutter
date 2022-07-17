import 'dart:convert';
import 'package:ab3ad/controllers/ordersController.dart';
import 'package:ab3ad/screens/components/default_button.dart';
import 'package:ab3ad/screens/order/order_complete.dart';
import 'package:ab3ad/screens/sign_in/sign_in_screen.dart';
import 'package:ab3ad/utils/cart_db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocode/geocode.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ab3ad/controllers/authController.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import '../../../constants.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late double _currentLat = 0.0;
  late double _currentLng = 0.0;
  late MapController mapController;
  bool isPressed = false;

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
    mapController = MapController();
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
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                center: LatLng(_currentLat, _currentLng),
                zoom: 13.0,
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c']
                ),
                MarkerLayerOptions(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(_currentLat, _currentLng),
                      builder: (ctx) =>
                      const Icon(Icons.location_on, size: 48, color: Colors.red),
                    ),
                  ],
                ),
              ],
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
                            onSubmitted: (value) async {
                              GeoCode geoCode = GeoCode();
                              try {
                                Coordinates coordinates = await geoCode
                                    .forwardGeocoding(address: value);
                              mapController.move(LatLng(coordinates.latitude!, coordinates.longitude!), 13.0);
                              setState(() {
                                _currentLat = coordinates.latitude!;
                                _currentLng = coordinates.longitude!;
                              });
                              } catch (e) {
                                print(e);
                              }
                            },
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "ابحث عن موقع معين",
                              hintStyle:
                                  TextStyle(color: kTextColor, fontSize: 14),
                              contentPadding: EdgeInsets.all(kDefaultPadding),
                            )),
                        const SizedBox(height: 5),
                        isPressed ? const Center(child: CircularProgressIndicator()) :
                        DefaultButton(
                            text: "ارسل الطلب",
                            press: () async {

                              setState(() {isPressed = true;});
                              
                              var authProvider =
                                  Provider.of<Auth>(context, listen: false);
                              var cartProvider =
                                  Provider.of<CartDatabaseHelper>(context,
                                      listen: false);
                              List cart = await cartProvider.getItems();

                              if(cart.isEmpty){
                                setState(() {
                                  isPressed = false;
                                });
                                Fluttertoast.showToast(
                                    msg: "الرجاء اضافة عناصر لسلة التسوق اولا",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: kPrimaryColor,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }else {
                                if (authProvider.authenticated) {
                                  var user = authProvider.user;
                                  var cartDb = CartDatabaseHelper();
                                  var _itemFile;
                                  for (var i = 0; i < cart.length; i++) {
                                    var cartMap = cart[i].toMap();
                                    if(cartMap['uploadedImage'] != null){
                                      _itemFile = await MultipartFile.fromFile(
                                        cartMap['uploadedImage'],
                                        filename:
                                            basename(cartMap['uploadedImage']),
                                      );
                                    }

                                    var formData = FormData.fromMap({
                                      'userId': user.id,
                                      'cart': jsonEncode(cartMap),
                                      "lat": _currentLat,
                                      "lng": _currentLng,
                                      "file": _itemFile,
                                      'status': 0
                                    });

                                    await checkout(formData: formData);
                                    await cartDb.deleteItem(cart[i].id);
                                  }
                                  Navigator.pushReplacementNamed(
                                  context, OrderCompleteScreen.routeName);
                                } else {
                                  Navigator.pushNamed(
                                      context, SignInScreen.routeName);
                                }
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
