import 'package:ab3ad/constants.dart';
import 'package:ab3ad/controllers/authController.dart';
import 'package:ab3ad/controllers/driversController.dart';
import 'package:provider/provider.dart';
import 'package:ab3ad/screens/components/coustom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

import '../../enums.dart';
import 'components/body.dart';


class DeliveryRequestsScreen extends StatelessWidget {
  const DeliveryRequestsScreen({ Key? key }) : super(key: key);
  static String routeName = "/delivery-requests";

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<Auth>(context, listen: false);
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
            future: fetchDeliveryRequests(userId: authProvider.user.id), 
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Body(requests: snapshot.data);
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


