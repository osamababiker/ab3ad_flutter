import 'package:flutter/material.dart';
import 'package:ab3ad/constants.dart';
import 'package:ab3ad/controllers/settingsController.dart';
import 'package:ab3ad/models/Setting.dart';



class Body extends StatelessWidget {
  const Body({ Key? key }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return FutureBuilder<Setting>(
      future: fetchSettings(),
      builder: (context, snapshot){
        if(snapshot.hasData){ 
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
            child: Container(
              width: size.width,
              padding: const EdgeInsets.all(kDefaultPadding),
              decoration: const BoxDecoration(
                color: Colors.white
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${snapshot.data!.appName} \n اصدار :  ${snapshot.data!.appVersion}",
                      style: const TextStyle(
                        fontSize: 16
                      )
                    ),
                    const SizedBox(height: 15),
                    Text.rich(
                      TextSpan(
                        text: " الايميل \n \n",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: snapshot.data!.email ,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            )
                          )
                        ]
                      )
                    ),
                    const Divider(),
                    const SizedBox(height: kDefaultPadding),
                    Text.rich(
                      TextSpan(
                        text: " سياسة الاستخدام والخصوصية \n \n",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: snapshot.data!.policy ,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            )
                          )
                        ]
                      )
                    ),
                  ]
                ),
              ),
            ),
          );
        } else{
          if(snapshot.hasError){
            return const Center(
              child: Text(
                "هناك مشكلة في الاتصال الرجاء المحاولة لاحقا",
                style: TextStyle(
                  fontSize: 14
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}