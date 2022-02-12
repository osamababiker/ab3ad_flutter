import 'package:ab3ad/constants.dart';
import 'package:flutter/material.dart';
import 'package:ab3ad/screens/components/no_account_text.dart';
import '../../../size_config.dart';
import 'sign_form.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: kDefaultPadding / 2,
      ),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(kDefaultPadding / 2),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: getScreenSize(context) * 2.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: getScreenSize(context) * 4.0),
                  Text(
                    "أهلا بك من جديد",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: getScreenSize(context) * 2.8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const VerticalSpacing(of: 1.0),
                  const SignForm(), 
                  const VerticalSpacing(of: 1.0),
                  SizedBox(height: getScreenSize(context) * 2.0),
                  const NoAccountText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
