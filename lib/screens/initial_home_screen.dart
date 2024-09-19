import 'package:flutter/material.dart';
import 'package:zippy/screens/home_screen.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/utils/const.dart';
import 'package:zippy/widgets/text_widget.dart';

class InitialHomeScreen extends StatelessWidget {
  const InitialHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
              height: 75,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 50),
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 160,
                  height: 90,
                  decoration: BoxDecoration(
                    border: Border.all(color: secondary, width: 1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(
                        10,
                      ),
                      topRight: Radius.circular(
                        10,
                      ),
                      bottomRight: Radius.circular(
                        10,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextWidget(
                        color: secondary,
                        fontFamily: 'Medium',
                        maxLines: 5,
                        text:
                            'Hi! Rider Robert. Ready to start your Zippy journey?',
                        fontSize: 16),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Image.asset(
                'assets/images/Group 205.png',
                height: 375,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, right: 20),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextWidget(
                      text: 'Proceed to home',
                      fontSize: 16,
                      fontFamily: 'Medium',
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: secondary,
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                          );
                        },
                        icon: const Icon(
                          Icons.keyboard_arrow_right_outlined,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
