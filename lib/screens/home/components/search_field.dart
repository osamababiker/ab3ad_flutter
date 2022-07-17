import 'package:flutter/material.dart';
import 'package:ab3ad/screens/location/location_screen.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class SearchField extends StatelessWidget {
  const SearchField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        onTap: () {
          Navigator.pushNamed(context, LocationScreen.routeName);
        },
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                horizontal: getScreenSize(context) * 2.0,
                vertical: getScreenSize(context) * 2.0),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            hintText: " حدد مكان التوصيل ",
            hintStyle: const TextStyle(color: kTextColor),
            prefixIcon: const Icon(Icons.location_on_outlined)),
      ),
    );
  }
}
