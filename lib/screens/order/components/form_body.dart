import 'package:ab3ad/constants.dart';
import 'package:ab3ad/models/Category.dart';
import 'package:ab3ad/models/Item.dart';
import 'package:ab3ad/screens/components/default_button.dart';
import 'package:ab3ad/screens/components/form_error.dart';
import 'package:ab3ad/size_config.dart';
import 'package:ab3ad/utils/cart_db_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'top_rounded_container.dart';

class FormBody extends StatefulWidget {
  const FormBody({Key? key, required this.items, required this.category})
      : super(key: key);

  final List items;
  final Category category;
  @override
  State<FormBody> createState() => _BodyState();
}

class _BodyState extends State<FormBody> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedTime;
  Item? _selectedItem;
  final List<String> _timeList = [
    'خلال اليوم',
    'صباحا',
    'بعد الظهر',
    ' بعد العصر',
    ' مساءا'
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _notesController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  final _quantityController = TextEditingController();
  final _notesController = TextEditingController();

  final List<String> errors = [];
  bool isPressed = false;

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
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TopRoundedContainer(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding / 2),
                child: Column(
                  children: [
                    const VerticalSpacing(of: 2.0),
                    TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _quantityController,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            removeError(error: kQuantityNullError);
                          }
                          return;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            addError(error: kQuantityNullError);
                            return;
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: "العدد المطلوب",
                          hintText: "ادخل عدد العناصر التي تريد",
                          hintStyle: TextStyle(color: kTextColor, fontSize: 14),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: EdgeInsets.all(kDefaultPadding),
                        )),
                    const VerticalSpacing(of: 2.0),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                isExpanded: true,
                                hint: Row(
                                  children: const [
                                    Icon(
                                      Icons.list,
                                      size: 16,
                                      color: kTextColor,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'اختر موعد التوصيل',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: kTextColor,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                items: _timeList
                                    .map((time) => DropdownMenuItem<String>(
                                          value: time,
                                          child: Text(
                                            time,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: kTextColor,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ))
                                    .toList(),
                                value: _selectedTime,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedTime = value as String;
                                  });
                                },
                                icon: const Icon(
                                  Icons.arrow_forward_ios_outlined,
                                ),
                                iconSize: 14,
                                iconEnabledColor: kTextColor,
                                iconDisabledColor: Colors.grey,
                                buttonHeight: 50,
                                buttonWidth: 200,
                                buttonPadding:
                                    const EdgeInsets.only(left: 14, right: 14),
                                buttonDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      kDefaultPadding / 2),
                                  border: Border.all(
                                    color: Colors.black26,
                                  ),
                                  color: Colors.white,
                                ),
                                itemHeight: 40,
                                itemPadding:
                                    const EdgeInsets.only(left: 14, right: 14),
                                dropdownMaxHeight: 200,
                                dropdownWidth: 200,
                                dropdownPadding: null,
                                dropdownDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      kDefaultPadding / 2),
                                  color: Colors.white,
                                ),
                                scrollbarRadius:
                                    const Radius.circular(kDefaultPadding / 2),
                                scrollbarThickness: 6,
                                scrollbarAlwaysShow: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: kDefaultPadding / 2),
                          SizedBox(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                isExpanded: true,
                                hint: Row(
                                  children: const [
                                    Icon(
                                      Icons.list,
                                      size: 16,
                                      color: kTextColor,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'أختر نوع العنصر',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: kTextColor,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                items: widget.items
                                    .map((item) => DropdownMenuItem<Item>(
                                          value: item,
                                          child: Text(
                                            item.name,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: kTextColor,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ))
                                    .toList(),
                                value: _selectedItem,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedItem = value as Item;
                                  });
                                },
                                icon: const Icon(
                                  Icons.arrow_forward_ios_outlined,
                                ),
                                iconSize: 14,
                                iconEnabledColor: kTextColor,
                                iconDisabledColor: Colors.grey,
                                buttonHeight: 50,
                                buttonWidth: 160,
                                buttonPadding:
                                    const EdgeInsets.only(left: 14, right: 14),
                                buttonDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      kDefaultPadding / 2),
                                  border: Border.all(
                                    color: Colors.black26,
                                  ),
                                  color: Colors.white,
                                ),
                                itemHeight: 40,
                                itemPadding:
                                    const EdgeInsets.only(left: 14, right: 14),
                                dropdownMaxHeight: 200,
                                dropdownWidth: 200,
                                dropdownPadding: null,
                                dropdownDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      kDefaultPadding / 2),
                                  color: Colors.white,
                                ),
                                scrollbarRadius:
                                    const Radius.circular(kDefaultPadding / 2),
                                scrollbarThickness: 6,
                                scrollbarAlwaysShow: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const VerticalSpacing(of: 2.0),
                    TextField(
                        keyboardType: TextInputType.text,
                        controller: _notesController,
                        decoration: const InputDecoration(
                          labelText: "اي ملاحظات او تنبيهات ",
                          hintText: "ادخل اي ملاحظات او تنبيهات للطلب",
                          hintStyle: TextStyle(color: kTextColor, fontSize: 14),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: EdgeInsets.all(kDefaultPadding * 2),
                        )),
                    const VerticalSpacing(of: 2.0),
                    isPressed
                        ? const CircularProgressIndicator()
                        : DefaultButton(
                            text: "أضف للسلة",
                            press: () async {
                              if (_formKey.currentState!.validate() && _selectedItem != null && _selectedTime != null) {
                                errors.clear();
                                setState(() {
                                  isPressed = true;
                                });
                                var map = <String, dynamic>{};
                                map['itemId'] = _selectedItem!.id;
                                map['categoryId'] = widget.category.id;
                                map['name'] = _selectedItem!.name;
                                map['image'] = _selectedItem!.image;
                                map['price'] = _selectedItem!.price;
                                map['deliveryTime'] = _selectedTime;
                                map['deliveryNote'] = _notesController.text;
                                map['quantity'] = _quantityController.text;
                                var db = CartDatabaseHelper();
                                await db.addToCart(cartData: map);
                                Fluttertoast.showToast(
                                    msg: "تم اضافة المنتج لسلة التسوق",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: kPrimaryColor,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                setState(() {
                                  isPressed = false;
                                });
                              }else {
                                addError(error: "الرجاء ملئ جميع الحقول اولا");
                                setState(() {
                                  isPressed = false;
                                });
                              }
                            },
                          ),
                    const SizedBox(height: kDefaultPadding / 2),
                    FormError(errors: errors),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
