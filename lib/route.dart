import 'package:ab3ad/screens/cart/cart_screen.dart';
import 'package:ab3ad/screens/delivery/delivery_screen.dart';
import 'package:ab3ad/screens/location/location_screen.dart';
import 'package:ab3ad/screens/order/form.dart';
import 'package:ab3ad/screens/order/order_complete.dart';
import 'package:ab3ad/screens/order/orders_screen.dart';
import 'package:ab3ad/screens/profile/profile_screen.dart';
import 'package:ab3ad/screens/settings/settings_screen.dart';
import 'package:ab3ad/screens/sign_in/sign_in_screen.dart';
import 'package:ab3ad/screens/sign_up/sign_up_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:ab3ad/screens/splash/splash_screen.dart';
import 'package:ab3ad/screens/home/home_screen.dart';



final Map<String , WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  OrderFormScreen.routeName: (context) => const OrderFormScreen(),
  OrdersScreen.routeName: (context) => const OrdersScreen(),
  SignInScreen.routeName: (context) => const SignInScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  ProfileScreen.routeName: (context) => const ProfileScreen(),
  CartScreen.routeName: (context) => const CartScreen(),
  DeliveryScreen.routeName: (context) => const DeliveryScreen(),
  LocationScreen.routeName: (context) => const LocationScreen(),
  OrderCompleteScreen.routeName: (context) => const OrderCompleteScreen() ,
  SettingsScreen.routeName: (context) => const SettingsScreen()
};