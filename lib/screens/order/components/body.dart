import 'package:ab3ad/constants.dart';
import 'package:ab3ad/models/Order.dart';
import 'package:ab3ad/controllers/ordersController.dart';
import 'package:ab3ad/size_config.dart';
import 'package:ab3ad/utils/.env.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Body extends StatefulWidget {
  Body({Key? key, required this.orders}) : super(key: key);

  List<Order> orders;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    if(widget.orders.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(kDefaultPadding / 2),
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                  children: List.generate(
                      widget.orders.length,
                      (index) => Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.all(kDefaultPadding / 2),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(children: [
                                      SizedBox(
                                        width: getScreenSize(context) * 8.0,
                                        height: getScreenSize(context) * 8.0,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                                width: getScreenSize(context) *
                                                    4.0,
                                                height: getScreenSize(context) *
                                                    4.0,
                                                child: FadeInImage.assetNetwork(
                                                    imageErrorBuilder: (context,
                                                        error, stackTrace) {
                                                      return Image.asset(
                                                        "assets/images/spinner.gif",
                                                      );
                                                    },
                                                    placeholder:
                                                        "assets/images/spinner.gif",
                                                    image:
                                                        "$uploadUri/items/${widget.orders[index].item.image}")),
                                            const VerticalSpacing(of: 1.0),
                                            Text(
                                              widget.orders[index].item.name,
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
                                            fontSize: 16, color: kTextColor),
                                      ),
                                      SizedBox(
                                          width: getScreenSize(context) * 2.0),
                                      Text(
                                        "${widget.orders[index].quantity}",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ]),
                                    GestureDetector(
                                      onTap: () async {
                                        await deleteOrders(
                                            orderId: widget.orders[index].id);
                                        setState(() {
                                          widget.orders.removeAt(index);
                                        });
                                      },
                                      child: Container(
                                        width: getScreenSize(context) * 4.0,
                                        height: getScreenSize(context) * 4.0,
                                        decoration: BoxDecoration(
                                            color: kPrimaryColor,
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(
                                              kDefaultPadding / 2),
                                          child: SvgPicture.asset(
                                              "assets/icons/Trash.svg",
                                              color: Colors.white),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Divider(color: kTextColor.withOpacity(0.2)),
                            ],
                          ))),
            )));
    }else {
      return Padding(
        padding: const EdgeInsets.all(kDefaultPadding / 2),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)
          ),
          child: const Center(
            child: Text(
              "لا توجد طلبات لعرضها حاليا",
              style: TextStyle(
                fontSize: 16,
                color: kTextColor
              ),
              ),
          ),
        ),
      );
    }
  }
}
