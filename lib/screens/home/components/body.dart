import 'package:ab3ad/constants.dart';
import 'package:flutter/material.dart';
import 'categoriesCard.dart';
import 'discount_banner.dart';
import 'home_header.dart';


class Body extends StatelessWidget {
  const Body({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: kDefaultPadding / 2),
          child: Column(
            children: const [
              HomeHeader(),
              DiscountBanner(),
              CategoriesCard()
            ],
          ),
        ),
      ),
    );
  }
}

