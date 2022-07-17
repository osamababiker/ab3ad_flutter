import 'package:ab3ad/controllers/authController.dart';
import 'package:ab3ad/screens/delivery_requests/delivery_requests_screen.dart';
import 'package:ab3ad/screens/home/home_screen.dart';
import 'package:ab3ad/screens/order/orders_screen.dart';
import 'package:ab3ad/screens/settings/settings_screen.dart';
import 'package:ab3ad/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<Auth>(context, listen: false);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          const ProfilePic(),
          const VerticalSpacing(of: 2.0),
          Text(
            authProvider.user.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const VerticalSpacing(of: 2.0),
          ProfileMenu(
            text: "الاعدادات",
            icon: "assets/icons/Settings.svg",
            press: () {
              Navigator.pushNamed(context, SettingsScreen.routeName);
            },
          ),
          ProfileMenu(
            text: "طلبات التوصيل",
            icon: "assets/icons/Settings.svg",
            press: () {
              authProvider.user.isDriver == 1
                  ? Navigator.pushNamed(context, DeliveryRequestsScreen.routeName)
                  : Navigator.pushNamed(context, OrdersScreen.routeName);
            },
          ),
          ProfileMenu(
            text: "تسجيل خروج",
            icon: "assets/icons/Log out.svg",
            press: () async {
              await authProvider.logout();
              Navigator.pushNamed(context, HomeScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
