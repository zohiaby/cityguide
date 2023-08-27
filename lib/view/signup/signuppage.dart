import 'package:cityguide/res/app_colors/app_clolrs.dart';
import 'package:cityguide/res/app_images/app_images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'dart:core';

import '../../model/authentication/userAuthentication.dart';
import '../../widgets/roundButton/roundButton.dart';
import '../../widgets/textFields/textFormFields.dart';
import '../login/loginPage.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool loading = false;

  // ignore: prefer_typing_uninitialized_variables
  late var userId;

  /// for checking the fields are empty or not globaly
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  /// removing the variables when they are not in use to free the space
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Sign Up Screen',
          style: TextStyle(
              color: Appcolor.textcolor,
              fontSize: 30,
              fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: ListView(scrollDirection: Axis.vertical, children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                      controllerValue: fullNameController,
                      hintValue: 'Full Name',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 10),
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
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              RoundButton(
                loading: loading,
                title: 'Sign up',
                ontap: () {
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      loading = true;
                    });

                    firebaseAuth
                        .createUserWithEmailAndPassword(
                            email: emailController.text.toString(),
                            password: passwordController.text.toString())
                        .then((value) {
                      userId = value.user!.uid;
                      debugPrint(value.user!.uid);
                      debugPrint("id is above");

                      FireBaseFuncationalities().uploadUserData(
                        value.user!.uid,
                        fullNameController.text,
                        emailController.text,
                        passwordController.text,
                      );
                      setState(() {
                        loading = false;
                      });
                      // Messagess().textMessage('Usere  Added Successfully');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    }).onError((error, stackTrace) {
                      setState(() {
                        loading = false;
                      });
                      //  Messagess().textMessage(error.toString());
                    });
                    //var id = Fire

                    debugPrint(fullNameController.text);
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account'),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Appcolor.buttonclolor),
                      ))
                ],
              )
            ],
          ),
        ]),
      ),
    );
  }
}
