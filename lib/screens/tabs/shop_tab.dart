import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zippy/screens/home_screen.dart';
import 'package:zippy/screens/tabs/edit_tab.dart';

import 'package:zippy/utils/colors.dart';
import 'package:zippy/utils/const.dart';
import 'package:zippy/widgets/button_widget.dart';
import 'package:zippy/widgets/text_widget.dart';
import 'package:zippy/widgets/textfield_widget.dart';

class ShopTab extends StatefulWidget {
  const ShopTab({super.key});

  @override
  State<ShopTab> createState() => _ShopTabState();
}

class _ShopTabState extends State<ShopTab> {
  final name = TextEditingController();
  String? businessName;
  List<dynamic> categories = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('Merchant')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            businessName = userDoc.get('businessName');
            categories = userDoc.get('categories') ?? [];
            if (categories.isNotEmpty) {
              selectedCategory = categories[0];
            }
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

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
                            text: businessName ?? '...',
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
                              onTap: () {},
                              child: _buildCravingOption(
                                  Icons.store_mall_directory_outlined,
                                  'Shop',
                                  true),
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const EditScreen()),
                                  );
                                },
                                child: _buildCravingOption(
                                    Icons.edit_square, 'Edit', false)),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Card(
              child: Container(
                width: 320,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: secondary),
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                  image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      'assets/images/Rectangle 38.png',
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 10, right: 15),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 36,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(
                            7.5,
                          ),
                          bottomRight: Radius.circular(
                            7.5,
                          ),
                        ),
                        color: secondary,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextWidget(
                              text: businessName ?? '...',
                              fontSize: 15,
                              fontFamily: 'Bold',
                              color: Colors.white,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextWidget(
                                  text: '4.5',
                                  fontSize: 14,
                                  fontFamily: 'Regular',
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Icon(
                                  Icons.star_rate_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ],
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
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: categories.map((category) {
                        bool isSelected = category == selectedCategory;
                        return Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selectedCategory = category;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 5),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? secondary
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  category,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Medium',
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          color: secondary, shape: BoxShape.circle),
                      child: const Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    TextWidget(
                      text: 'Add',
                      fontSize: 14,
                      fontFamily: 'Medium',
                      color: secondary,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            for (int i = 0; i < 2; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 3,
                      child: Container(
                        width: 100,
                        height: 112.5,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              'assets/images/Rectangle 2.png',
                            ),
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: secondary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Card(
                      elevation: 3,
                      child: Container(
                        width: 210,
                        height: 112.5,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: secondary,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 33,
                              decoration: const BoxDecoration(
                                color: secondary,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                    7.5,
                                  ),
                                  topRight: Radius.circular(
                                    7.5,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: TextWidget(
                                  text: 'Coffee and Cake',
                                  fontSize: 15,
                                  fontFamily: 'Bold',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextWidget(
                              text:
                                  '1 serving of americano coffee and 1 slice of cake',
                              fontSize: 12,
                              fontFamily: 'Medium',
                              color: Colors.black,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextWidget(
                                    text: '₱ 159',
                                    fontSize: 12,
                                    fontFamily: 'Bold',
                                    color: secondary,
                                  ),
                                  Row(
                                    children: [
                                      TextWidget(
                                        text: 'Add to Cart',
                                        fontSize: 12,
                                        fontFamily: 'Bold',
                                        color: secondary,
                                      ),
                                      const Icon(
                                        Icons.arrow_right_alt_outlined,
                                        color: secondary,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 320,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(
                  color: secondary,
                ),
                borderRadius: BorderRadius.circular(
                  15,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: secondary, shape: BoxShape.circle),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Row(
                                  children: [
                                    Card(
                                      child: Container(
                                        width: 100,
                                        height: 112.5,
                                        decoration: BoxDecoration(
                                          image: const DecorationImage(
                                            fit: BoxFit.fill,
                                            image: AssetImage(
                                                'assets/images/Rectangle 2.png'),
                                          ),
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: secondary,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                ),
                                actions: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ButtonWidget(
                                          width: 115,
                                          label: 'Cancel',
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          }),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      ButtonWidget(
                                          width: 115,
                                          label: 'Done',
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          }),
                                    ],
                                  )
                                ],
                              );
                            },
                          );
                        },
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  TextWidget(
                    text: 'add menu item',
                    fontSize: 16,
                    fontFamily: 'Medium',
                    color: secondary,
                  ),
                ],
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
