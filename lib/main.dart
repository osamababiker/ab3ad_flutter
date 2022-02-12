import 'package:ab3ad/controllers/categoriesController.dart';
import 'package:flutter/material.dart';
import 'package:ab3ad/utils/cart_db_helper.dart';
import 'package:ab3ad/screens/errors/no_internet.dart';
import 'package:ab3ad/screens/splash/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:ab3ad/controllers/authController.dart';
import 'package:ab3ad/screens/home/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'route.dart';
import 'theme.dart';


// flutter build appbundle
 
Future main() async{

  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp(); 
  
  runApp( 
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
         ChangeNotifierProvider(create: (context) => CartDatabaseHelper()), 
      ],
      child: const MyApp()
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchCategories(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'أبعاد',
            theme: theme(), 
            routes: routes, 
            home: const SplashScreen()
          ); 
        } 
        if(snapshot.hasError){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "أبعاد",
            theme: theme(),  
            routes: routes,
            home: const NoInternetScreen(),  
          );
        }
        else{
          return MaterialApp(
            debugShowCheckedModeBanner: false, 
            title: "أبعاد",
            theme: theme(),  
            routes: routes,
            home: const HomeScreen(),  
          );
        }
      }
    );
  }
}
