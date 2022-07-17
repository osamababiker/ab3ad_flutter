import 'package:ab3ad/screens/location/location_screen.dart';
import 'package:flutter/material.dart';
import 'package:ab3ad/screens/components/default_button.dart';
import 'package:ab3ad/utils/cart_db_helper.dart';
import 'package:provider/provider.dart';
import '../../../size_config.dart';

class CheckoutCard extends StatelessWidget {
  const CheckoutCard({
    Key? key,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    var cartProvider = context.watch<CartDatabaseHelper>();

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: getScreenSize(context) * 1.5,
        horizontal: getScreenSize(context) * 3.0,
      ),
      // height: 174,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.15),
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const TextField(
            //     keyboardType: TextInputType.text,
            //     decoration: InputDecoration(
            //       hintText: "أدخل كود التخفيض",
            //       hintStyle: TextStyle(color: kTextColor, fontSize: 14),
            //       contentPadding: EdgeInsets.all(kDefaultPadding),
            //     )),
            // SizedBox(height: getScreenSize(context) * 2.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FutureBuilder(
                    future: cartProvider.getCartTotal(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return Text.rich(
                          TextSpan(
                            text: "المجموع :\n",
                            children: [
                              TextSpan(
                                text: "${snapshot.data}",
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return const Text.rich(
                          TextSpan(
                            text: "المجموع :\n",
                            children: [
                              TextSpan(
                                text: "",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            ],
                          ),
                        );
                      }
                    }),
                SizedBox(
                  width: getScreenSize(context) * 25.0,
                  child: DefaultButton(
                    text: "اختر موقع التوصيل",
                    press: () {
                      Navigator.pushNamed(context, LocationScreen.routeName);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
