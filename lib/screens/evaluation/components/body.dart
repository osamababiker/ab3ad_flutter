import 'package:ab3ad/controllers/driversController.dart';
import 'package:ab3ad/models/DeliveryRequest.dart';
import 'package:ab3ad/models/Order.dart';
import 'package:ab3ad/screens/components/default_button.dart';
import 'package:flutter/material.dart';
import 'package:ab3ad/constants.dart';
import 'package:ab3ad/controllers/evaluationController.dart';
import 'package:ab3ad/screens/home/home_screen.dart';
import 'package:ab3ad/screens/components/form_error.dart';
import 'package:ab3ad/screens/components/custom_suffix_icon.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ab3ad/controllers/authController.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  final Order order;
  Body({required this.order});
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _reviewController = TextEditingController();
  double _rating = 0.0;
  final List<String> errors = [];
  bool isPressed = false;

  void addError({required String error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _reviewController.dispose();
  }

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var provider = Provider.of<Auth>(context, listen: false);

    return FutureBuilder<DeliveryRequest>(
        future: fetchAcceptedDeliveryRequests(orderId: widget.order.id),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  const SizedBox(height: kDefaultPadding * 2),
                  Padding(
                    padding: const EdgeInsets.all(kDefaultPadding / 2),
                    child: Container(
                      width: size.width,
                      padding: const EdgeInsets.all(kDefaultPadding / 2),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "قيم تجربتك من 1 الى 5",
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: kDefaultPadding),
                            RatingBar.builder(
                              initialRating: 3,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                setState(() {
                                  _rating = rating;
                                });
                              },
                            ),
                            const SizedBox(height: kDefaultPadding),
                            TextFormField(
                              controller: _reviewController,
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  removeError(error: 'الرجاء كتابة التعليق');
                                }
                                return;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  addError(error: 'الرجاء كتابة التعليق');
                                  return "";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                labelText: "رجاءا اخبرنا اكثر عن تجربتك",
                                suffixIcon: CustomSuffixIcon(
                                  svgIcon: "assets/icons/Question mark.svg",
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                              ),
                            ),
                            const SizedBox(height: kDefaultPadding / 2),
                            FormError(errors: errors),
                            const SizedBox(height: kDefaultPadding / 2),
                            DefaultButton(
                                text: "ارسال التقييم",
                                press: () async {
                                  if (_formKey.currentState!.validate()) {
                                    errors.clear();
                                    setState(() => isPressed = true);

                                    int userId = 0;
                                    if (snapshot.data.customer.id ==
                                        provider.user.id) {
                                      userId = snapshot.data.driver.id;
                                    } else {
                                      userId = snapshot.data.customer.id;
                                    }
                                    Map data = {
                                      'raterId': provider.user.id,
                                      'userId': userId,
                                      'rating': _rating,
                                      'review': _reviewController.text
                                    };
                                    bool check =
                                        await saveEvaluation(data: data);
                                    if (!check) {
                                      addError(
                                          error:
                                              'هناك مشكلة في ارسال التقييم ');
                                    } else {
                                      await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Directionality(
                                                textDirection:
                                                    TextDirection.rtl,
                                                child: AlertDialog(
                                                    content: const Text(
                                                      "شكرا لك على تقييم هذا المستخدم",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                              kFontFamily),
                                                    ),
                                                    actions: [
                                                      Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: ElevatedButton(
                                                            onPressed: () {
                                                              Navigator
                                                                  .pushReplacementNamed(
                                                                context,
                                                                HomeScreen
                                                                    .routeName,
                                                              );
                                                            },
                                                            child: const Text(
                                                              "اغلاق",
                                                              style: TextStyle(
                                                                  fontSize: 14),
                                                            )),
                                                      )
                                                    ]));
                                          });
                                    }
                                  }
                                })
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            if (snapshot.hasError) {
              return Padding(
                  padding: const EdgeInsets.only(top: kDefaultPadding / 2),
                  child: Container(
                      color: Colors.white,
                      child: const Center(
                        child: Text(
                            "هناك مشكلة في الاتصال , الرجاء المحاولة لاجقا",
                            style: TextStyle(color: kTextColor, fontSize: 16)),
                      )));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }
        });
  }
}
