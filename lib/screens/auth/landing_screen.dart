import 'package:flutter/material.dart';
import 'package:zippy/screens/auth/login_screen.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/utils/const.dart';
import 'package:zippy/widgets/button_widget.dart';
import 'package:zippy/widgets/text_widget.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 275,
            ),
            Image.asset(
              logo,
              width: 250,
              height: 104,
              color: secondary,
            ),
            TextWidget(
              text: 'RIDERS',
              fontSize: 30,
              fontFamily: 'Bold',
              color: secondary,
            ),
            const SizedBox(
              height: 100,
            ),
            ButtonWidget(
              textColor: Colors.white,
              color: secondary,
              label: 'Get Started',
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
