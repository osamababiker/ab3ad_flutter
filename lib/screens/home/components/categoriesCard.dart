import 'package:ab3ad/constants.dart';
import 'package:ab3ad/controllers/categoriesController.dart';
import 'package:ab3ad/size_config.dart';
import 'package:flutter/material.dart';

import 'category_card.dart';

class CategoriesCard extends StatelessWidget {
  const CategoriesCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) { 
    return FutureBuilder(
        future: fetchCategories(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "ماذا تريد ان تطلب",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const VerticalSpacing(of: 2.0),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                        children: List.generate(snapshot.data.length, (index) {
                        return CategoryCard(category: snapshot.data[index]);
                    })),
                  )
                ],
              ),
            );
          } else {
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  "هنا مشكلة في الاتصال الرجاء المحاولة لاحقا",
                  style: TextStyle(fontSize: 14),
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
