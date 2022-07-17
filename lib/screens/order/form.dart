import 'package:ab3ad/constants.dart';
import 'package:ab3ad/controllers/itemsController.dart';
import 'package:ab3ad/enums.dart';
import 'package:ab3ad/models/Category.dart';
import 'package:ab3ad/screens/components/coustom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'components/form_body.dart';

class OrderFormScreen extends StatelessWidget {
  const OrderFormScreen({Key? key}) : super(key: key);

  static String routeName = "/order_form";

  @override
  Widget build(BuildContext context) { 
    final Category agrs =
        ModalRoute.of(context)!.settings.arguments as Category;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(" اضافة الطلب للسلة", 
              style: TextStyle(
                  fontSize: 16,
                  color: kTextColor,
                  fontWeight: FontWeight.bold)),
        ),
        body: FutureBuilder(
            future: fetchItemsByCategory(agrs.id), 
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return FormBody(items: snapshot.data, category: agrs);
              } else {
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
          bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.orderForm),
      ),
    );
  }
}
