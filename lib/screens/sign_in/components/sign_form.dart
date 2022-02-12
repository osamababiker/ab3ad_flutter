import 'dart:io';

import 'package:ab3ad/controllers/authController.dart';
import 'package:ab3ad/screens/components/custom_suffix_icon.dart';
import 'package:ab3ad/screens/components/default_button.dart';
import 'package:ab3ad/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:ab3ad/screens/components/form_error.dart';
import 'package:device_info/device_info.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class SignForm extends StatefulWidget {
  const SignForm({Key? key}) : super(key: key);

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // device info
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  late String _deviceName;
  final List<String> errors = [];
  bool isPressed = false; 

  @override
  void initState() {
    super.initState();
    getDeviceName();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void getDeviceName() async {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        _deviceName = androidInfo.model;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        _deviceName = iosInfo.utsname.machine;
      }
    } catch (e) {
      print(e);
    }
  }

  void addError({required String error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
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
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildPhoneFormField(),
          SizedBox(height: getScreenSize(context) * 3.0),
          buildPasswordFormField(),
          SizedBox(height: getScreenSize(context) * 3.0),
          FormError(errors: errors),
          SizedBox(height: getScreenSize(context) * 2.0),
          !isPressed
              ? DefaultButton(
                  text: "تسجيل دخول",
                  press: () async {
                    Map creds = {
                      'phone': _phoneController.text,
                      'password': _passwordController.text,
                      'device_name': _deviceName
                    };
                    if (_formKey.currentState!.validate()) {
                      errors.clear();
                      setState(() {
                        isPressed = true;
                      });
                      var provider = Provider.of<Auth>(context, listen: false);
                      await provider.login(creds: creds);
                      if (provider.authenticated) {
                        Navigator.pushNamed(context, HomeScreen.routeName);
                      } else {
                        addError(error: "الرجاء التأكد من صحة البيانات");
                        setState(() {
                          isPressed = false;
                        });
                        _passwordController.text = '';
                      }
                    }
                  })
              : const CircularProgressIndicator()
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      controller: _passwordController,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "كلمة المرور",
        hintText: "ادخل كلمة المرور",
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Lock.svg",
        ),
      ),
    );
  }

  TextFormField buildPhoneFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      controller: _phoneController,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPhoneNumberNullError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "رقم الهاتف",
        hintText: "ادخل رقم الهاتف",
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Phone.svg",
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
