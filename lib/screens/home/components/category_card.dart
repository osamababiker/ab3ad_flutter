import 'package:ab3ad/constants.dart';
import 'package:ab3ad/models/Category.dart';
import 'package:ab3ad/screens/order/form.dart';
import 'package:ab3ad/size_config.dart';
import 'package:ab3ad/utils/.env.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.category,
  }) : super(key: key);

  final Category category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed( 
          context, 
          OrderFormScreen.routeName,
          arguments: category 
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding / 4),
        child: Container(
          width: getScreenSize(context) * 22.0,
          height: getScreenSize(context) * 22.0,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: getScreenSize(context) * 12.0,
                  height: getScreenSize(context) * 12.0,
                  child: FadeInImage.assetNetwork(
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        "assets/images/spinner.gif",
                      );
                    },
                    placeholder: "assets/images/spinner.gif", 
                    image: "$uploadUri/categories/${category.image}"
                  )),
              const VerticalSpacing(of: 2.0),
              Text(
                category.name,
                style: const TextStyle(
                    fontSize: 16,
                    color: kTextColor,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
