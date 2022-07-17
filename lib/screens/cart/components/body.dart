import 'package:ab3ad/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ab3ad/utils/cart_db_helper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ab3ad/utils/.env.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Body extends StatefulWidget {
  List cart;
  Body({Key? key, required this.cart}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    var provider = context.watch<CartDatabaseHelper>();

    if (widget.cart.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(kDefaultPadding / 2),
        child: Column(
          children: List.generate(
              widget.cart.length,
              (index) => Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 88,
                              child: AspectRatio(
                                aspectRatio: 0.88,
                                child: Container( 
                                    padding: EdgeInsets.all(
                                        getScreenSize(context) * 1.0),
                                        child: CachedNetworkImage(
                                    imageUrl: "$uploadUri/items/${widget.cart[index].image}",
                                    placeholder: (context, url) => Image.asset("assets/images/liquid-loader.gif"),
                                    errorWidget: (context, url, error) => Image.asset("assets/images/liquid-loader.gif"),
                                )),
                              ),
                            ),
                            const SizedBox(width: kDefaultPadding),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${widget.cart[index].name}",
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 16),
                                  maxLines: 2,
                                ),
                                const SizedBox(height: 10),
                                Text.rich(
                                  TextSpan(
                                    text: "${widget.cart[index].price} جنيه",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: kPrimaryColor),
                                    children: [
                                      TextSpan(
                                          text:
                                              " x ${widget.cart[index].quantity}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(width: kDefaultPadding),
                            GestureDetector(
                              onTap: () async {
                                await provider
                                    .deleteItem(widget.cart[index].id);
                                setState(() {
                                  widget.cart.removeAt(index);
                                });
                                Fluttertoast.showToast(
                                    msg: "تمت ازلة المنتج من السلة بنجاح",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: kPrimaryColor,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.all(kDefaultPadding / 2),
                                  child: SvgPicture.asset(
                                      "assets/icons/Trash.svg",
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(width: kDefaultPadding / 2),
                          ],
                        ),
                      ),
                      const SizedBox(height: kDefaultPadding / 2)
                    ],
                  )),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: kDefaultPadding / 2, bottom: kDefaultPadding / 2),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white
          ),
          child: const Center(
            child: Text(
              "لا توجد عناصر في السلة",
              style: TextStyle(fontSize: 16, color: kTextColor),
            ),
          ),
        ),
      );
    }
  }
}
