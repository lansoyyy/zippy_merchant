import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zippy/utils/const.dart';
import 'package:zippy/widgets/button_widget.dart';

import '../../utils/colors.dart';
import '../../widgets/text_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.arrow_back_ios_new,
                            color: secondary,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          TextWidget(
                            text: 'Back',
                            fontSize: 15,
                            color: secondary,
                            fontFamily: 'Medium',
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        TextWidget(
                          text: 'Logout',
                          fontSize: 15,
                          color: secondary,
                          fontFamily: 'Medium',
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.logout,
                          color: secondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: secondary,
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: CircleAvatar(
                        minRadius: 75,
                        maxRadius: 75,
                        backgroundImage: AssetImage(
                          'assets/images/sample_avatar.png',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 120, top: 110, bottom: 20),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: secondary),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: TextWidget(
                text: 'Paula Baresco',
                fontSize: 28,
                color: secondary,
                fontFamily: 'Bold',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                width: 320,
                height: 40,
                decoration: BoxDecoration(
                  color: secondary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: 'Personal Information',
                        fontSize: 15,
                        color: Colors.white,
                        fontFamily: 'Medium',
                      ),
                      TextWidget(
                        text: 'Edit',
                        fontSize: 14,
                        color: Colors.white,
                        fontFamily: 'Medium',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextWidget(
                    text: 'EMAIL ADDRESS',
                    fontSize: 10,
                    color: secondary,
                    fontFamily: 'Regular',
                  ),
                  const SizedBox(
                    width: 120,
                  ),
                  TextWidget(
                    text: 'MOBILE NUMBER',
                    fontSize: 10,
                    color: secondary,
                    fontFamily: 'Regular',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextWidget(
                    text: 'Paula.baresco@gmail.com',
                    fontSize: 14,
                    color: secondary,
                    fontFamily: 'Medium',
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  TextWidget(
                    text: '+6399 9999 9999',
                    fontSize: 14,
                    color: secondary,
                    fontFamily: 'Medium',
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Divider(
                color: secondary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: TextWidget(
                text: 'BIRTHDATE',
                fontSize: 10,
                color: secondary,
                fontFamily: 'Regular',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: TextWidget(
                text: 'January 01, 2000',
                fontSize: 14,
                color: secondary,
                fontFamily: 'Medium',
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Divider(
                color: secondary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: 'Address',
                        fontSize: 10,
                        color: secondary,
                        fontFamily: 'Regular',
                      ),
                      TextWidget(
                        text: '999 Home Street, House Avenue ',
                        fontSize: 14,
                        color: secondary,
                        fontFamily: 'Medium',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Divider(
                color: secondary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: 'Vehicle Model',
                        fontSize: 10,
                        color: secondary,
                        fontFamily: 'Regular',
                      ),
                      TextWidget(
                        text: 'Red Toyota Vios',
                        fontSize: 14,
                        color: secondary,
                        fontFamily: 'Medium',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Divider(
                color: secondary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: 'Plate Number',
                        fontSize: 10,
                        color: secondary,
                        fontFamily: 'Regular',
                      ),
                      SizedBox(
                        child: TextWidget(
                          align: TextAlign.start,
                          text: 'A1B2C3',
                          fontSize: 14,
                          color: secondary,
                          fontFamily: 'Medium',
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: 'Registration No.',
                        fontSize: 10,
                        color: secondary,
                        fontFamily: 'Regular',
                      ),
                      SizedBox(
                        child: TextWidget(
                          align: TextAlign.start,
                          text: '99988877-6',
                          fontSize: 14,
                          color: secondary,
                          fontFamily: 'Medium',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Divider(
                color: secondary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: 'License No.',
                        fontSize: 10,
                        color: secondary,
                        fontFamily: 'Regular',
                      ),
                      SizedBox(
                        child: TextWidget(
                          align: TextAlign.start,
                          text: 'C10-12-123456',
                          fontSize: 14,
                          color: secondary,
                          fontFamily: 'Medium',
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: 'Expiry',
                        fontSize: 10,
                        color: secondary,
                        fontFamily: 'Regular',
                      ),
                      SizedBox(
                        child: TextWidget(
                          align: TextAlign.start,
                          text: '2026/01/01',
                          fontSize: 14,
                          color: secondary,
                          fontFamily: 'Medium',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Divider(
                color: secondary,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget tileWidget(String title, Widget suffix) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Center(
        child: Container(
          width: 320,
          height: 40,
          decoration: BoxDecoration(
            color: secondary,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: title,
                  fontSize: 15,
                  color: Colors.white,
                  fontFamily: 'Medium',
                ),
                suffix
              ],
            ),
          ),
        ),
      ),
    );
  }

  showPrivacy(context, String label, String caption) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 500,
          width: double.infinity,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: secondary,
                    size: 50,
                  ),
                  TextWidget(
                    text: label,
                    fontSize: 24,
                    color: secondary,
                    fontFamily: 'Bold',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 300,
                    width: 320,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: secondary,
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextWidget(
                          align: TextAlign.start,
                          maxLines: 500,
                          text: caption,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ButtonWidget(
                    width: 320,
                    label: 'OKAY',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  showFavorites(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 500,
          width: double.infinity,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: secondary,
                    size: 50,
                  ),
                  TextWidget(
                    text: 'Favorites',
                    fontSize: 24,
                    color: secondary,
                    fontFamily: 'Bold',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextWidget(
                    text: 'click on the heart to remove from favorites',
                    fontSize: 15,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 375,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (int i = 0; i < 10; i++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Container(
                                width: 320,
                                height: 65,
                                decoration: BoxDecoration(
                                  color: secondary,
                                  borderRadius: BorderRadius.circular(
                                    20,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'assets/images/Rectangle 40.png',
                                      height: double.infinity,
                                      width: 120,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    TextWidget(
                                      text: 'Bluebird Coffee',
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontFamily: 'Bold',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
