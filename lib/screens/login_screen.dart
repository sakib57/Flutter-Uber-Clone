import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uber_clone/constants.dart';
import 'package:uber_clone/widgets/progress_dialogue.dart';

import '../main.dart';
import 'main_screen.dart';
import 'registration_screen.dart';

class LoginScreen extends StatelessWidget {
  static const String idScreen = "login";
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 45.0,
              ),
              Container(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  "images/logo.png",
                  width: 250,
                  height: 250,
                ),
              ),
              Text(
                "Login as rider",
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand-Bold"),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(fontSize: 14.0),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10.0)),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(fontSize: 14.0),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10.0)),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      onPressed: () {
                        if (!emailController.text.contains("@")) {
                          displayTost(context, "Invalid Email");
                        } else if (passwordController.text.length < 1) {
                          displayTost(context, "Please enter your password");
                        } else {
                          userLogin(context);
                        }
                      },
                      color: Colors.yellow,
                      child: Container(
                          height: 50.0,
                          child: Center(
                              child: Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 18.0, fontFamily: "Brand-Bold"),
                          ))),
                    )
                  ],
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, RegistrationScreen.idScreen, (route) => false);
                },
                child: Text("Don\'t have an account register here"),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Functions =========
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void userLogin(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return ProgressDialog(
            msg: "Logging In",
          );
        });

    final User firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text)
            .catchError((errorMsg) {
      Navigator.pop(context);
      displayTost(context, "Error: " + errorMsg);
    }))
        .user;

    if (firebaseUser != null) {
      //displayTost(context, "Something happen right");

      userRef.child(firebaseUser.uid).once().then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          Navigator.pop(context);
          Navigator.pushNamedAndRemoveUntil(
              context, MainScreen.idScreen, (route) => false);
          displayTost(context, "Login successful");
        } else {
          Navigator.pop(context);
          displayTost(context, "email or password incorrect");
        }
      });
    } else {
      //error occured
      Navigator.pop(context);
      displayTost(context, "Something happen wrong");
    }
  }
}
