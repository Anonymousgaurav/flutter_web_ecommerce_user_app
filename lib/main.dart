import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_app/assistant_methods/address_changer.dart';
import 'package:user_app/assistant_methods/cart_item_counter.dart';
import 'package:user_app/assistant_methods/total_ammount.dart';
import 'package:user_app/splashScreen/splash_screen.dart';
import 'global/global.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyCggNojQ_lZTjb1Y5bIogdtmx-JvdKJ_PA",
    appId: "1:575578767034:web:41a403451543ea102f8c83",
    messagingSenderId: "575578767034",
    projectId: "flutter--web-2cf96",
    authDomain: "flutter--web-2cf96.firebaseapp.com",
    storageBucket: "flutter--web-2cf96.appspot.com",
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartItemCounter()),
        ChangeNotifierProvider(create: (context) => TotalAmmount()),
        ChangeNotifierProvider(create: (context) => AddressChanger()),
      ],
      child: MaterialApp(
        title: 'Grocery App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MySplashScreen(),
      ),
    );
  }
}
