import 'package:ab3ad/constants.dart';
import 'package:ab3ad/controllers/driversController.dart';
import 'package:ab3ad/models/Order.dart';
import 'package:ab3ad/screens/components/coustom_bottom_nav_bar.dart';
import 'package:ab3ad/screens/home/home_screen.dart';
import 'package:ab3ad/size_config.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocode/geocode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/authController.dart';
import '../../enums.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../components/default_button.dart';

class TakeOrderScreen extends StatelessWidget {
  const TakeOrderScreen({Key? key}) : super(key: key);
  static String routeName = "/take_order";
  @override
  Widget build(BuildContext context) {
    final Order agrs = ModalRoute.of(context)!.settings.arguments as Order;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "قبول هذا  الطلب",
            style: TextStyle(color: kTextColor, fontSize: 16),
          ),
        ),
        body: Body(order: agrs),
        bottomNavigationBar:
            const CustomBottomNavBar(selectedMenu: MenuState.orders),
      ),
    );
  }
}

class Body extends StatefulWidget {
  const Body({Key? key, required this.order}) : super(key: key);
  final Order order;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool isPressed = false;

  @override
  void initState() {
    super.initState();
    _getDeliveryAddress();
  }

  Address? _deliveryAddress;

  Future _getDeliveryAddress() async {
    GeoCode geoCode = GeoCode();
    try {
      Address _address = await geoCode.reverseGeocoding(
          latitude: double.parse(widget.order.customerLat),
          longitude: double.parse(widget.order.customerLng));
      setState(() {
        _deliveryAddress = _address;
      });
    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height * 0.8,
      child: Stack(
        alignment: Alignment.center,
        children: [
          FlutterMap(
            options: MapOptions(
              center: LatLng(double.parse(widget.order.customerLat), double.parse(widget.order.customerLng)),
              zoom: 13.0,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c']
              ),
              MarkerLayerOptions(
                markers: [
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: LatLng(double.parse(widget.order.customerLat), double.parse(widget.order.customerLng)),
                    builder: (ctx) =>
                    const Icon(Icons.location_on),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: size.width,
              decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30))),
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "عنوان التوصيل",
                        style: TextStyle(fontSize: 16, color: kTextColor),
                      ),
                      const VerticalSpacing(of: 2.0),
                      _deliveryAddress != null
                          ? Text(
                              "${_deliveryAddress!.countryName} - ${_deliveryAddress!.city} - ${_deliveryAddress!.streetAddress}",
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: kTextColor,
                                  fontWeight: FontWeight.bold),
                            )
                          : const Text(""),
                      const VerticalSpacing(of: 2.0),
                      !isPressed ?
                      DefaultButton(
                        text: "توصيل الطلبية",
                        press: () async {
                          setState(() {
                            isPressed = true;
                          });
                          var authProvider =
                              Provider.of<Auth>(context, listen: false);
                          Map formData = {
                            'customerId': widget.order.user.id,
                            'driverId': authProvider.user.id,
                            'orderId': widget.order.id
                          };
                          bool check = 
                              await sendDeliveryRequest(formData: formData);
                          if (check) {
                            Fluttertoast.showToast(
                                msg: "تمت ارسال طلب التوصيل بنجاح  ",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: kPrimaryColor,
                                textColor: Colors.white,
                                fontSize: 16.0);
                              setState(() {
                            isPressed = false;
                          });
                          Navigator.pushNamed(context, HomeScreen.routeName);
                          } 
                        },
                      ): const Center(child: CircularProgressIndicator())
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
