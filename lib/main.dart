import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/data_handler/app_data.dart';
import 'package:uber_clone/screens/login_screen.dart';
import 'package:uber_clone/screens/main_screen.dart';
import 'package:uber_clone/screens/registration_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

DatabaseReference userRef =
    FirebaseDatabase.instance.reference().child("users");

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'Uber Clone',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "Brand-Regular",
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: MainScreen.idScreen,
        routes: {
          LoginScreen.idScreen: (context) => LoginScreen(),
          RegistrationScreen.idScreen: (context) => RegistrationScreen(),
          MainScreen.idScreen: (context) => MainScreen(),
        },
      ),
    );
  }
}
