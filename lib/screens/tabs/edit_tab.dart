import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zippy/screens/home_screen.dart';
import 'package:zippy/screens/pages/arrived_page.dart';
import 'package:zippy/screens/pages/completed_page.dart';
import 'package:zippy/screens/pages/profile_page.dart';
import 'package:zippy/screens/tabs/shop_tab.dart';

import 'package:zippy/utils/colors.dart';
import 'package:zippy/utils/const.dart';
import 'package:zippy/widgets/button_widget.dart';
import 'package:zippy/widgets/text_widget.dart';
import 'package:zippy/widgets/textfield_widget.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final bname = TextEditingController();
  final address = TextEditingController();
  final merchantId = TextEditingController();
  final operatingHours = TextEditingController();
  final operatingDays = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 190,
              decoration: const BoxDecoration(
                color: secondary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(
                    40,
                  ),
                  bottomRight: Radius.circular(
                    40,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 25, left: 15, right: 15),
                    child: SafeArea(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextWidget(
                            text: 'Bluebird’s Coffee',
                            fontSize: 22,
                            fontFamily: 'Bold',
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScreen()),
                                  );
                                },
                                child: _buildCravingOption(
                                    Icons.home, 'Home', false)),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => const ShopTab()),
                                );
                              },
                              child: _buildCravingOption(
                                  Icons.store_mall_directory_outlined,
                                  'Shop',
                                  false),
                            ),
                            GestureDetector(
                                onTap: () {},
                                child: _buildCravingOption(
                                    Icons.edit_square, 'Edit', true)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 375,
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      'assets/images/Rectangle 38.png',
                    ),
                    fit: BoxFit.cover),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: const BoxDecoration(
                color: secondary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              height: 600,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          TextWidget(
                            text: 'Description',
                            fontSize: 28,
                            fontFamily: 'Bold',
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Container(
                          height: 70,
                          width: 320,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.white,
                            ),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TextWidget(
                                text:
                                    'Looking for a cozy rustic quiet workplace to do some productive work? enjoy all these at bluebird cakes, coffee’s, and pasta’s that will pique your taste buds.',
                                fontSize: 12,
                                color: Colors.white,
                                maxLines: 5,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          TextWidget(
                            text: 'Information',
                            fontSize: 28,
                            fontFamily: 'Bold',
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFieldWidget(
                        fontSize: 14,
                        radius: 5,
                        height: 35,
                        borderColor: Colors.white,
                        color: Colors.white,
                        hintColor: Colors.white,
                        label: 'Business Name',
                        controller: bname,
                      ),
                      TextFieldWidget(
                        fontSize: 14,
                        radius: 5,
                        height: 35,
                        borderColor: Colors.white,
                        color: Colors.white,
                        hintColor: Colors.white,
                        label: 'Business Address',
                        controller: address,
                      ),
                      TextFieldWidget(
                        fontSize: 14,
                        radius: 5,
                        height: 35,
                        borderColor: Colors.white,
                        color: Colors.white,
                        hintColor: Colors.white,
                        label: 'Merchant ID',
                        controller: merchantId,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 185,
                            child: TextFieldWidget(
                              hintSize: 12,
                              fontSize: 14,
                              radius: 5,
                              height: 35,
                              borderColor: Colors.white,
                              color: Colors.white,
                              hintColor: Colors.white,
                              label: 'Operating Hours',
                              controller: operatingHours,
                            ),
                          ),
                          SizedBox(
                            width: 185,
                            child: TextFieldWidget(
                              hintSize: 12,
                              fontSize: 14,
                              radius: 5,
                              height: 35,
                              borderColor: Colors.white,
                              color: Colors.white,
                              hintColor: Colors.white,
                              label: 'Operating Days',
                              controller: operatingDays,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          TextWidget(
                            text: 'Categories',
                            fontSize: 28,
                            fontFamily: 'Bold',
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 225,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                for (int i = 0; i < 3; i++)
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      TextWidget(
                                        text: shopCategories[i],
                                        fontSize: 15,
                                        fontFamily: 'Medium',
                                        color: Colors.white,
                                      ),
                                      i == 0
                                          ? const Icon(
                                              Icons.circle,
                                              color: Colors.white,
                                              size: 15,
                                            )
                                          : const SizedBox(
                                              height: 15,
                                            ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle),
                                child: const Padding(
                                  padding: EdgeInsets.all(3.0),
                                  child: Icon(
                                    Icons.add,
                                    color: secondary,
                                    size: 15,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              TextWidget(
                                text: 'add categories',
                                fontSize: 14,
                                fontFamily: 'Medium',
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          TextWidget(
                            text: 'Wallet',
                            fontSize: 28,
                            fontFamily: 'Bold',
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                gcash,
                                width: 80,
                                height: 25,
                              ),
                              TextWidget(
                                text: '+639 9999 9999',
                                fontSize: 12,
                                color: secondary,
                                fontFamily: 'Medium',
                              ),
                              Container(
                                width: 60,
                                height: 18,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: secondary,
                                ),
                                child: Center(
                                  child: TextWidget(
                                    text: 'Unlink',
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontFamily: 'Medium',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                paymaya,
                                width: 80,
                                height: 25,
                              ),
                              const SizedBox(),
                              Container(
                                width: 60,
                                height: 18,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: secondary,
                                  ),
                                ),
                                child: Center(
                                  child: TextWidget(
                                    text: 'Link',
                                    fontSize: 10,
                                    color: secondary,
                                    fontFamily: 'Medium',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    bpi,
                                    width: 25,
                                    height: 25,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  TextWidget(
                                    text: 'BPI',
                                    fontSize: 15,
                                    color: secondary,
                                  ),
                                ],
                              ),
                              TextWidget(
                                text: '123 1234 1234',
                                fontSize: 12,
                                color: secondary,
                                fontFamily: 'Medium',
                              ),
                              Container(
                                width: 60,
                                height: 18,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: secondary,
                                ),
                                child: Center(
                                  child: TextWidget(
                                    text: 'Unlink',
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontFamily: 'Medium',
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCravingOption(IconData icon, String label, bool selected) {
    return Column(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(height: 5.0),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontFamily: 'Medium'),
        ),
        if (selected)
          Container(
            margin: const EdgeInsets.only(top: 4.0),
            height: 2.0,
            width: 40.0,
            color: Colors.white,
          ),
      ],
    );
  }
}
