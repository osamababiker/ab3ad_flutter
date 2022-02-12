import 'package:ab3ad/constants.dart';
import 'package:ab3ad/screens/sign_in/sign_in_screen.dart';
import 'package:ab3ad/screens/sign_up/sign_up_screen.dart';
import 'package:ab3ad/size_config.dart';
import 'package:flutter/material.dart';


class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          " لا تمتلك حسابا ؟ ",
          style: TextStyle(fontSize: getScreenSize(context) * 1.6),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, SignUpScreen.routeName),
          child: Text(
            "انشاء حساب",
            style: TextStyle(
                fontSize: getScreenSize(context) * 1.6,
                color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}
