import 'package:ab3ad/constants.dart';
import 'package:ab3ad/controllers/ordersController.dart';
import 'package:ab3ad/screens/components/coustom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

import '../../enums.dart';
import 'components/body.dart';

class DeliveryScreen extends StatelessWidget {
  const DeliveryScreen({Key? key}) : super(key: key);

  static String routeName = "/delivery";
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
            future: fetchAllOrders(),
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
