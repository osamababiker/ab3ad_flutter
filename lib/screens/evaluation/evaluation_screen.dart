import 'package:ab3ad/models/Order.dart';
import 'package:flutter/material.dart';
import 'package:ab3ad/constants.dart';
import 'package:ab3ad/enums.dart';
import 'package:ab3ad/screens/components/coustom_bottom_nav_bar.dart';
import 'components/body.dart';


class EvaluationScreen extends StatelessWidget {
  static String routeName = "/evaluation";

  const EvaluationScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) { 

    final Order arguments = ModalRoute.of(context)!.settings.arguments as Order;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "تقييم الخدمة",
            style: TextStyle(
              fontSize: 16,
              color: kTextColor
            ),
          ),
        ),
        body: Body(order: arguments),
        bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.orders),
      ),
    );
  }
}