import 'package:ab3ad/constants.dart';
import 'package:ab3ad/controllers/authController.dart';
import 'package:provider/provider.dart';
import 'package:ab3ad/screens/evaluation/evaluation_screen.dart';
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
    if (widget.orders.isNotEmpty) {
      return Padding(
          padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                    children: List.generate(
                        widget.orders.length,
                        (index) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                                  width: getScreenSize(
                                                          context) *
                                                      4.0,
                                                  height: getScreenSize(
                                                          context) *
                                                      4.0,
                                                  child:
                                                      FadeInImage.assetNetwork(
                                                          imageErrorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
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
                                            width:
                                                getScreenSize(context) * 2.0),
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
                                Padding(
                                  padding:
                                      const EdgeInsets.all(kDefaultPadding / 2),
                                  child: Row(
                                    children: [
                                      const Text(
                                        "حالة الطلب",
                                        style: TextStyle(
                                            fontSize: 16, color: kTextColor),
                                      ),
                                      const SizedBox(
                                          width: kDefaultPadding / 4),
                                      Text(
                                        widget.orders[index].status == 0
                                            ? " قيد الانتظار "
                                            : widget.orders[index].status == 1
                                                ? " قيد التوصيل "
                                                : widget.orders[index].status ==
                                                        2
                                                    ? " تم التوصيل "
                                                    : widget.orders[index]
                                                                .status ==
                                                            3
                                                        ? " تم الالغاء "
                                                        : "",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: kTextColor,
                                            fontStyle: FontStyle.italic),
                                      )
                                    ],
                                  ),
                                ), 
                                widget.orders[index].driverCompleteSign == 1 &&  widget.orders[index].customerCompleteSign == 0 ?
                                Padding(
                                  padding: const EdgeInsets.all(kDefaultPadding / 2),
                                  child: GestureDetector(
                                      onTap: () async {
                                        var authProvider = Provider.of<Auth>(context, listen: false);
                                        Map formData = {
                                          'customerId': authProvider.user.id,
                                          'orderId': widget.orders[index].id
                                        };
                                        bool check = await updateOrder(formData: formData);
                                        if(check){
                                          Navigator.pushNamed(context,
                                            EvaluationScreen.routeName,
                                            arguments: widget.orders[index]);
                                        }
                                        
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            width: getScreenSize(context) * 4.0,
                                            height: getScreenSize(context) * 4.0,
                                            decoration: BoxDecoration(
                                                color: kPrimaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            child: const Padding(
                                              padding: EdgeInsets.all(
                                                  kDefaultPadding / 2),
                                              child: Icon(Icons.check, color: Colors.white),
                                            ),
                                          ),
                                          const Text(
                                            "تم الاستلام",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: kTextColor
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ): const Text(""),
                                Divider(color: kTextColor.withOpacity(0.2)),
                              ],
                            ))),
              )));
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: kDefaultPadding / 2, bottom: kDefaultPadding / 2),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: const Center(
            child: Text(
              "لا توجد طلبات لعرضها حاليا",
              style: TextStyle(fontSize: 16, color: kTextColor),
            ),
          ),
        ),
      );
    }
  }
}
