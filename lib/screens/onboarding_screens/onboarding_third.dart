import 'package:flutter/material.dart';
import 'package:zippy/screens/auth/landing_screen.dart';
import 'package:zippy/screens/onboarding_screens/onboarding_fourth.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/utils/const.dart';
import 'package:zippy/widgets/text_widget.dart';

class OnboardingThird extends StatelessWidget {
  const OnboardingThird({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      for (int i = 0; i < 3; i++)
                        Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: Icon(
                            Icons.circle,
                            size: 10,
                            color: i == 2 ? secondary : Colors.grey,
                          ),
                        ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const LandingScreen()));
                    },
                    child: Row(
                      children: [
                        TextWidget(
                          text: 'next',
                          fontSize: 16,
                          color: secondary,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.arrow_circle_right_outlined,
                          color: secondary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextWidget(
                    text: 'with',
                    fontSize: 32,
                    fontFamily: 'Regular',
                    color: secondary,
                  ),
                  TextWidget(
                    text: 'Zippy',
                    fontSize: 32,
                    fontFamily: 'Bold',
                    color: secondary,
                  ),
                ],
              ),
              TextWidget(
                text: 'you can customize your shop based on\nyour preference.',
                fontSize: 16,
                color: Colors.black,
              ),
              const Expanded(
                child: SizedBox(
                  height: 25,
                ),
              ),
              Image.asset(
                'assets/images/cat/CAT #6 1.png',
                width: 250,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
