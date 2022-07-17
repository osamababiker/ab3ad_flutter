import 'package:ab3ad/enums.dart';
import 'package:ab3ad/screens/components/coustom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:ab3ad/controllers/authController.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'components/body.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static String routeName = '/home';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState(); 
    readToken();
    requestPermission();
    FirebaseMessaging.instance.subscribeToTopic('all');  
  }

  void requestPermission() async {
    await Geolocator.requestPermission();
  }

  void readToken() async {
    try {
      String token = await storage.read(key: 'token') as String;
      var provider = Provider.of<Auth>(context, listen: false);
      provider.tryToken(token: token);
      if(provider.authenticated){
        if(provider.user.isDriver == 1){
          FirebaseMessaging.instance.subscribeToTopic('driversTopic');
        }
      }
    } catch (ex) {
      print(ex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Body(),
        bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
      ),
    );
  }
}
