import 'package:cityguide/res/app_colors/app_clolrs.dart';
import 'package:cityguide/res/app_images/app_images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// for verifying that email is vlaid or not
import 'dart:core';
// import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';

import '../../model/authentication/userAuthentication.dart';
import '../../widgets/roundButton/roundButton.dart';
import '../../widgets/textFields/textFormFields.dart';
import '../homePage/homepage.dart';
import '../signup/signuppage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// for checking the fields are empty or not globaly
  final formKey = GlobalKey<FormState>();

  final authentacation = FirebaseAuth.instance;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  /// removing the variables when they are not in use to free the space
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void login() {
    authentacation
        .signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((value) {
      FireBaseFuncationalities().uploadUserFCMToken();
      debugPrint("${value}User Logged in Successfully");
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ));

      //Messagess().textMessage(value.toString() + "User Logged in Successfully");
    }).onError((error, stackTrace) {
      debugPrint("${error}User Logged in Successfully");

      // Messagess().textMessage(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        /// close the application
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            'Login Screen',
            style: TextStyle(
                color: Appcolor.textcolor,
                fontSize: 30,
                fontWeight: FontWeight.bold),
          ),
          automaticallyImplyLeading: false,
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: ListView(scrollDirection: Axis.vertical, children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: SizedBox(
                            height: 300,
                            child: Image(
                              image: AssetImage(images.welcomeimage),
                            ),
                          ),
                        ),
                        TextFormFields(
                          controllerValue: emailController,
                          hintValue: 'Email',
                          icon: Icons.email,
                        ),
                        const SizedBox(height: 10),
                        TextFormFields(
                          controllerValue: passwordController,
                          hintValue: 'Password',
                          icon: Icons.lock,
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 30,
                ),
                RoundButton(
                  title: 'Login',
                  ontap: () {
                    if (formKey.currentState!.validate()) {
                      login();
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have account'),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()));
                      },
                      child: const Text(
                        "Sign up",
                        style: TextStyle(color: Appcolor.buttonclolor),
                      ),
                    )
                  ],
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
