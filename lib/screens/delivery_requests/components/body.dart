import 'package:ab3ad/constants.dart';
import 'package:ab3ad/controllers/authController.dart';
import 'package:ab3ad/controllers/driversController.dart';
import 'package:ab3ad/controllers/ordersController.dart';
import 'package:ab3ad/screens/evaluation/evaluation_screen.dart';
import 'package:ab3ad/models/DeliveryRequest.dart';
import 'package:ab3ad/models/Order.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ab3ad/utils/.env.dart';
import '../../../size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';


class Body extends StatefulWidget {
  Body({Key? key, required this.requests}) : super(key: key);

  List<DeliveryRequest> requests;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    if(widget.requests.isNotEmpty){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: List.generate(
              widget.requests.length,
              (index) => Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(kDefaultPadding / 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "بيانات العميل",
                              style: TextStyle(fontSize: 16, color: kTextColor),
                            ),
                            const SizedBox(height: kDefaultPadding / 2),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.person),
                                    const SizedBox(width: kDefaultPadding / 4),
                                    Text(
                                      widget.requests[index].customer.name,
                                      style: const TextStyle(
                                          fontSize: 16, color: kTextColor),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: kDefaultPadding / 4),
                                Row(
                                  children: [
                                    const Icon(Icons.phone),
                                    const SizedBox(width: kDefaultPadding / 4),
                                    Text(
                                      widget.requests[index].customer.phone,
                                      style: const TextStyle(
                                          fontSize: 16, color: kTextColor),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Divider(color: kTextColor.withOpacity(0.5)),
                            const Text(
                              "تفاصيل الطلب",
                              style: TextStyle(fontSize: 16, color: kTextColor),
                            ),
                            const SizedBox(height: kDefaultPadding / 2),
                            Padding(
                              padding:
                                  const EdgeInsets.all(kDefaultPadding / 2),
                              child: FutureBuilder<Order>(
                                  future: fetchSingleOrder(
                                      orderId: widget.requests[index].orderId),
                                  builder: (context, AsyncSnapshot snapshot) {
                                    if (snapshot.hasData) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(children: [
                                            SizedBox(
                                              width:
                                                  getScreenSize(context) * 8.0,
                                              height:
                                                  getScreenSize(context) * 8.0,
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                      width: getScreenSize(
                                                              context) *
                                                          4.0,
                                                      height: getScreenSize(
                                                              context) *
                                                          4.0,
                                                          child: CachedNetworkImage(
                                                          imageUrl: "$uploadUri/items/${snapshot.data.item.image}",
                                                          placeholder: (context, url) => Image.asset("assets/images/liquid-loader.gif"),
                                                          errorWidget: (context, url, error) => Image.asset("assets/images/liquid-loader.gif"),
                                                      )),
                                                  const VerticalSpacing(
                                                      of: 1.0),
                                                  Text(
                                                    snapshot.data.item
                                                        .name,
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: kTextColor),
                                                  )
                                                ],
                                              ),
                                            ),
                                            const Text(
                                              " الكمية المطلوبة",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: kTextColor),
                                            ),
                                            SizedBox(
                                                width: getScreenSize(context) *
                                                    2.0),
                                            Text(
                                              "${snapshot.data.quantity}",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ]),
                                          widget.requests[index].isAccepted == 1  && snapshot.data.status != 2 ?
                                          GestureDetector(
                                            onTap: () async {
                                              var authProvider =
                                                  Provider.of<Auth>(context,
                                                      listen: false);
                                              Map formData = {
                                                'orderId':
                                                    snapshot.data.id,
                                                'driverId': authProvider.user.id
                                              };
                                              bool check =
                                                  await orderCompleteSign(
                                                      formData: formData);

                                              if (check) {
                                                Navigator.pushNamed(context,
                                                    EvaluationScreen.routeName,
                                                    arguments:
                                                        snapshot.data);
                                              }
                                            },
                                            child: Container(
                                              width:
                                                  getScreenSize(context) * 4.0,
                                              height:
                                                  getScreenSize(context) * 4.0,
                                              decoration: BoxDecoration(
                                                  color: kPrimaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              child: const Padding(
                                                padding: EdgeInsets.all(
                                                    kDefaultPadding / 2),
                                                child: Icon(Icons.check, color: Colors.white),
                                              ),
                                            ),
                                          ) : const Text(""),
                                        ],
                                      );
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
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: kDefaultPadding / 2),
                    ],
                  )),
        ),
      ),
    );
  }else{
    return Padding(
      padding: const EdgeInsets.only(top: kDefaultPadding / 2),
      child: Container(
        color: Colors.white,
        child: const Center(
          child: Text(
            "لم تقم بارسال طلبات توصيل بعد",
            style: TextStyle(color: kTextColor, fontSize: 16),
          ),
        ),
      ),
    );
  }
  }
}
