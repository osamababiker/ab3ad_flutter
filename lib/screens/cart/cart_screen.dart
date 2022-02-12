import 'package:ab3ad/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ab3ad/utils/cart_db_helper.dart';
import 'components/body.dart';
import 'components/check_out_card.dart';

class CartScreen extends StatelessWidget {
  static String routeName = "/cart";

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<CartDatabaseHelper>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: buildAppBar(context),
        body: FutureBuilder(
            future: provider.getItems(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Body(cart: snapshot.data);
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
        bottomNavigationBar: const CheckoutCard(),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        "عربة التسوق الخاصة بك",
        style: TextStyle(color: kTextColor, fontSize: 16),
      ),
    );
  }
}
