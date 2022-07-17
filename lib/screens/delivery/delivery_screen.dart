import 'package:ab3ad/constants.dart';
import 'package:ab3ad/controllers/ordersController.dart';
import 'package:ab3ad/screens/components/coustom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

import '../../enums.dart';
import 'components/body.dart';
import 'package:geolocator/geolocator.dart';

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({Key? key}) : super(key: key);

  static String routeName = "/delivery";

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {

  late double _currentLat = 0.0;
  late double _currentLng = 0.0;

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
  }

  Future _getCurrentPosition() async {
    // to get current user location
    final _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentLat = _currentPosition.latitude;
      _currentLng = _currentPosition.longitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "طلبات التوصيل",
            style: TextStyle(color: kTextColor, fontSize: 16),
          ),
        ),
        body: FutureBuilder(
            future: fetchAllOrders(lat: _currentLat, lng: _currentLng), 
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Body(orders: snapshot.data);
              }else {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      "هنا مشكلة في الاتصال الرجاء المحاولة لاحقا",
                      style: TextStyle(fontSize: 14),
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
          bottomNavigationBar:
          const CustomBottomNavBar(selectedMenu: MenuState.orders),
      ),
    );
  }
}
