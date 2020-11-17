import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uber_clone/constants.dart';
import 'package:uber_clone/main.dart';
import 'package:uber_clone/screens/main_screen.dart';
import 'package:uber_clone/widgets/progress_dialogue.dart';

import 'login_screen.dart';

class RegistrationScreen extends StatelessWidget {
  static const String idScreen = "register";
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confPasswordController = TextEditingController();

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
                "Register as rider",
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand-Bold"),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Name",
                          labelStyle: TextStyle(fontSize: 14.0),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10.0)),
                      style: TextStyle(fontSize: 14.0),
                    ),
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
                    TextField(
                      controller: confPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: "Confirm Password",
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
                        if (nameController.text.length < 4) {
                          displayTost(
                              context, "Name must be atleast 3 character");
                        } else if (!emailController.text.contains("@")) {
                          displayTost(context, "Invalid Email");
                        } else if (passwordController.text.length < 4) {
                          displayTost(
                              context, "Password must be atleast 4 character");
                        } else if (passwordController.text !=
                            confPasswordController.text) {
                          displayTost(
                              context, "Confirm password didn\'t match");
                        } else {
                          registerNewUser(context);
                        }
                      },
                      color: Colors.yellow,
                      child: Container(
                          height: 50.0,
                          child: Center(
                              child: Text(
                            "Register",
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
                      context, LoginScreen.idScreen, (route) => false);
                },
                child: Text("Already have an account login here"),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Functions
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  registerNewUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return ProgressDialog(
            msg: "Registering",
          );
        });
    final User user = (await _firebaseAuth
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text)
            .catchError((errorMsg) {
      Navigator.pop(context);
      displayTost(context, "Error" + errorMsg.toString());
    }))
        .user;

    if (user != null) {
      // save

      Map userDataMap = {
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "password": passwordController.text
      };

      userRef.child(user.uid).set(userDataMap);
      Navigator.pop(context);
      displayTost(context, "Account created successfully");
      Navigator.pushNamedAndRemoveUntil(
          context, MainScreen.idScreen, (route) => false);
    } else {
      //error occured
      Navigator.pop(context);
      displayTost(context, "User has not been created");
    }
  }
}
