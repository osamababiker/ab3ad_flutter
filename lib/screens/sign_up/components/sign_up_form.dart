import 'dart:io';
import 'package:ab3ad/controllers/authController.dart';
import 'package:ab3ad/screens/components/custom_suffix_icon.dart';
import 'package:ab3ad/size_config.dart';
import 'package:flutter/material.dart';
import 'package:ab3ad/screens/components/custom_surfix_icon.dart';
import 'package:ab3ad/screens/components/default_button.dart';
import 'package:ab3ad/screens/components/form_error.dart';
import 'package:device_info/device_info.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../constants.dart';


class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  // device info
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  late String _deviceName;
  late String _notificationToken; 
  String email = '';
  String password = '';
  String conformPassword = '';
  bool remember = false;
  final List<String> errors = [];

   bool isPressed = false;


  Future<Position> _getCurrentPosition() async {
    // to get current user location 
    final _currentPosition =  await Geolocator
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return _currentPosition;
  }

  @override
  void initState() {
    super.initState();
    getDeviceName();
    FirebaseMessaging.instance.getToken().then((value) => _notificationToken = value.toString());
  }
  

   void getDeviceName() async {
    try{
      if(Platform.isAndroid){
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        _deviceName = androidInfo.model;
      } else if(Platform.isIOS){
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        _deviceName = iosInfo.utsname.machine;
      }
    } catch(e){
      print(e);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error!);
      });
    }
  }

  void removeError({String? error}) {
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
          buildNameFormField(),
          SizedBox(height: getScreenSize(context) * 2.0),
          buildPhoneFormField(),
          SizedBox(height: getScreenSize(context) * 2.0),
          buildAddressFormField(),
          SizedBox(height: getScreenSize(context) * 2.0),
          buildPasswordFormField(),
          SizedBox(height: getScreenSize(context) * 2.0),
          buildConformPassFormField(),
          FormError(errors: errors),
          SizedBox(height: getScreenSize(context) * 2.0),
          DefaultButton(
            text: "انشاء حساب",
            press: () async{
              var location = await _getCurrentPosition();
              Map fields = {
                'name': _nameController.text,
                'password': _passwordController.text,
                'password_confirmation': _confirmPasswordController.text,
                'address': _addressController.text,
                'phone': _phoneController.text,
                'lat': location.latitude,
                'lng': location.longitude,
                'device_name': _deviceName,
                'notificationToken': _notificationToken
              };
              if(_formKey.currentState!.validate()){
                errors.clear();
                setState(() {
                  isPressed = true;
                });
                var provider = Provider.of<Auth>(context, listen: false);
                var apiResult = await provider.register(fields: fields);
              }
            },
          ),
        ],
      ),
    );
  }


  TextFormField buildNameFormField() {
    return TextFormField(
      keyboardType: TextInputType.name,
      onChanged: (value){ 
        if(value.isNotEmpty){
          removeError(error: kNamelNullError);
        }
        return ;
      },
      validator: (value){
        if(value!.isEmpty){
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "الاسم",
        hintText: "ادخل الاسم كاملا",
        suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/User.svg",),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildAddressFormField() {
    return TextFormField(
      keyboardType: TextInputType.streetAddress,
      onChanged: (value){
        if(value.isNotEmpty){
          removeError(error: kAddressNullError);
        }
        return;
      },
      validator: (value){
        if(value!.isEmpty){
          addError(error: kAddressNullError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "العنوان",
        hintText: "ادخل عنوان السكن",
        suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/Location_point.svg",),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildPhoneFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onChanged: (value){
        if(value.isNotEmpty){
          removeError(error: kPhoneNumberNullError);
        }
        return ;
      },
      validator: (value){
        if(value!.isEmpty){
          addError(error: kPhoneNumberNullError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "رقم الهاتف",
        hintText: "ادخل رقم الهاتف",
        suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/Phone.svg",),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildConformPassFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => conformPassword = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.isNotEmpty && password == conformPassword) {
          removeError(error: kMatchPassError);
        }
        conformPassword = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if ((password != value)) {
          addError(error: kMatchPassError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "تأكيد كلمة المرور",
        hintText: "قم باعادة ادخال كلمة المرور",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        password = value;
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
        hintText: "قم بادخال كلمة المرور",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }
}
