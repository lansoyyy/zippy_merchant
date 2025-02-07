import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zippy/screens/home_screen.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/widgets/button_widget.dart';
import 'package:zippy/widgets/text_widget.dart';
import 'package:zippy/widgets/textfield_widget.dart';
import 'package:zippy/widgets/toast_widget.dart';

import '../../utils/const.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final merchantId = TextEditingController();
  final password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Image.asset(
                    logo,
                    width: 191,
                    height: 80,
                    color: secondary,
                  ),
                  const SizedBox(
                    height: 12.5,
                  ),
                  TextWidget(
                    text: 'Hi! Welcome',
                    fontSize: 25,
                    color: secondary,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              height: 450,
              decoration: const BoxDecoration(
                  color: secondary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                      30,
                    ),
                    topRight: Radius.circular(
                      30,
                    ),
                  )),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    TextWidget(
                      text: 'Log in',
                      fontSize: 32,
                      color: Colors.white,
                      fontFamily: 'Medium',
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFieldWidget(
                      labelcolor: Colors.white,
                      hintColor: Colors.white,
                      borderColor: Colors.white,
                      height: 80,
                      inputType: TextInputType.number,
                      color: Colors.white,
                      label: 'Merchant ID',
                      controller: merchantId,
                      hint: 'Enter you 12-digit Merchant ID',
                    ),
                    TextFieldWidget(
                      showEye: true,
                      isObscure: true,
                      labelcolor: Colors.white,
                      height: 80,
                      color: Colors.white,
                      label: 'Password',
                      controller: password,
                      hint: 'Enter your Password',
                      hintColor: Colors.white,
                      borderColor: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 25),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            forgotPassword();
                          },
                          child: TextWidget(
                            text: 'Forgot Password?',
                            fontSize: 15,
                            color: Colors.white,
                            fontFamily: 'Bold',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ButtonWidget(
                      textColor: secondary,
                      color: Colors.white,
                      height: 50,
                      width: 320,
                      fontSize: 20,
                      label: 'Log in',
                      onPressed: () {
                        login(context);
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextWidget(
                      text: 'Want to become a Merchant?',
                      fontSize: 14,
                      color: Colors.white,
                      fontFamily: 'Medium',
                    ),
                    const SizedBox(
                      height: 2.5,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: TextWidget(
                        text: 'Learn how',
                        fontSize: 15,
                        color: Colors.white,
                        fontFamily: 'Bold',
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  forgotPassword() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: TextWidget(
              text: 'For forgotten password, Please contact our Administrator',
              fontSize: 20,
              color: secondary,
              fontFamily: 'Bold',
              maxLines: 3,
              align: TextAlign.start,
            ),
            actions: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                decoration: BoxDecoration(
                    color: secondary, borderRadius: BorderRadius.circular(10)),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: TextWidget(
                    text: 'Close',
                    fontSize: 18,
                    color: white,
                    fontFamily: "Medium",
                  ),
                ),
              ),
            ],
          );
        });
  }

  login(context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: '${merchantId.text}@zippy.merchant', password: password.text);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showToast("No merchant found with that id.");
      } else if (e.code == 'wrong-password') {
        showToast("Wrong password provided for that merchant.");
      } else if (e.code == 'invalid-email') {
        showToast("Invalid merchant id provided.");
      } else if (e.code == 'user-disabled') {
        showToast("merchant account has been disabled.");
      } else {
        showToast("An error occurred: ${e.message}");
      }
    } on Exception catch (e) {
      showToast("An error occurred: $e");
    }
  }
}
