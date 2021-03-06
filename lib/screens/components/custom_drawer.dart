import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ab3ad/controllers/authController.dart';
import 'package:ab3ad/screens/home/home_screen.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../size_config.dart';



class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<Auth>(context, listen: false); 
    Size size = MediaQuery.of(context).size;
    return Drawer(
      child: ListView(
        children: <Widget>[
          authProvider.authenticated ? 
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
            ),
            accountName: Text(
              authProvider.user.name,
              style: const TextStyle(color: kTextColor),
            ),
            accountEmail: Text(
              authProvider.user.phone,
              style: const TextStyle(color: kTextColor),
            ),
            currentAccountPicture: Padding(
              padding: const EdgeInsets.all(kDefaultPadding / 1.5),
              child: ClipOval(
                child: Image.asset("assets/images/logos_black.png"),
              ),
            )
          ) : 
          Container(
            width: size.width,
            padding: const EdgeInsets.all(kDefaultPadding),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: getScreenSize(context) * 5.0,
                  height: getScreenSize(context) * 5.0,
                  child: ClipOval(
                    child: Image.asset("assets/images/logos_black.png"),
                  ),
                ),
                const VerticalSpacing(of: 1.0),
                GestureDetector(
                  onTap: () {
                    
                  },
                  child: Container(
                    padding: const EdgeInsets.all(kDefaultPadding / 2),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [BoxShadow(
                        offset: const Offset(0 , 2),
                        blurRadius: 1,
                        color: Colors.black.withOpacity(0.9),
                      )]
                    ),
                    child: const Text(
                      "?????????? ????????",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(
                offset: const Offset(0 , 2),
                blurRadius: 1,
                color: Colors.black.withOpacity(0.16),
              )]
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, HomeScreen.routeName);
              },
              child: const ListTile(
                title: Text("????????????????", style: TextStyle(fontSize: 14)),
                trailing:  SizedBox(
                  width: 20,
                  height: 20,
                  child: Icon(Icons.home_outlined),
                ),
              ),
            ),
          ),
          const VerticalSpacing(of: 1.0),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(
                offset: const Offset(0, 2),
                blurRadius: 1,
                color: Colors.black.withOpacity(0.16)
              )]
            ),
            child: GestureDetector(
              onTap: (){},
              child: const ListTile(
                title: Text("????????????", style: TextStyle(fontSize: 14)),
                trailing:  SizedBox(
                  width: 20,
                  height: 20,
                  child: Icon(Icons.shopping_bag_outlined),
                ),
              )
            ),
          ),
          const VerticalSpacing(of: 1.0),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(
                offset: const Offset(0, 2),
                blurRadius: 1,
                color: Colors.black.withOpacity(0.16)
              )]
            ),
            child: GestureDetector(
              onTap: (){},
              child: const ListTile(
                title: Text("??????????????????", style: TextStyle(fontSize: 14)),
                trailing:  SizedBox(
                  width: 20,
                  height: 20,
                  child: Icon(Icons.notifications_outlined),
                ),
              )
            ),
          ),
          const VerticalSpacing(of: 1.0),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(
                offset: const Offset(0, 2),
                blurRadius: 1,
                color: Colors.black.withOpacity(0.16)
              )]
            ),
            child: GestureDetector(
              onTap: (){},
              child: const ListTile(
                title: Text("???? ??????????????", style: TextStyle(fontSize: 14)),
                trailing:  SizedBox(
                  width: 20,
                  height: 20,
                  child: Icon(Icons.info_outline),
                ),
              )
            ),
          ),
        ],
      ),
    );
  }
}

