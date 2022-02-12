import 'package:ab3ad/screens/components/coustom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:ab3ad/enums.dart';
import 'components/body.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import '../../constants.dart';

class LocationScreen extends StatelessWidget {
  static String routeName = "/location";
  
  const LocationScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) { 

    final Position arguments = ModalRoute.of(context)!.settings.arguments as Position;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "اختر موقع التوصيل",
              style: TextStyle(fontSize: 16, color: kTextColor),
            ),
          ), 
          body: Body(currentLocation: arguments),
          bottomNavigationBar:
              const CustomBottomNavBar(selectedMenu: MenuState.map)),
    );
  }
}
