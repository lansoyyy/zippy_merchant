import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zippy/screens/home_screen.dart';
import 'package:zippy/screens/tabs/shop_tab.dart';

import 'package:zippy/utils/colors.dart';
import 'package:zippy/utils/const.dart';
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
  String? businessName;
  String? description;
  String? add;
  String? id;
  String? hours;
  String? days;
  String? name;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<dynamic> categories = [];
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
            name = userDoc.get('name');
            businessName = userDoc.get('businessName');
            description = userDoc.get('desc');
            add = userDoc.get('address');
            id = userDoc.get('merchantId');
            hours = userDoc.get('operatingHours');
            days = userDoc.get('operatingDays');
            categories = userDoc.get('categories');
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
                            text: businessName ?? '..',
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
              width: 500,
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
              decoration: BoxDecoration(
                color: white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              height: 430,
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
                            color: primary,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.edit,
                              color: primary,
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
                              color: secondary,
                            ),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TextWidget(
                                text: description ?? 'No description available',
                                fontSize: 12,
                                color: black,
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
                            color: primary,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.edit,
                              color: primary,
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
                        borderColor: secondary,
                        color: secondary,
                        hintColor: secondary,
                        label: businessName ?? '...',
                        controller: bname,
                        labelcolor: black,
                      ),
                      TextFieldWidget(
                        fontSize: 14,
                        radius: 5,
                        height: 35,
                        borderColor: secondary,
                        color: secondary,
                        hintColor: secondary,
                        label: add ?? '...',
                        controller: address,
                        labelcolor: black,
                      ),
                      TextFieldWidget(
                        fontSize: 14,
                        radius: 5,
                        height: 35,
                        borderColor: secondary,
                        color: secondary,
                        hintColor: secondary,
                        label: id ?? '...',
                        controller: merchantId,
                        labelcolor: black,
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
                              borderColor: secondary,
                              color: secondary,
                              hintColor: secondary,
                              label: hours ?? '...',
                              controller: operatingHours,
                              labelcolor: black,
                            ),
                          ),
                          SizedBox(
                            width: 185,
                            child: TextFieldWidget(
                              hintSize: 12,
                              fontSize: 14,
                              radius: 5,
                              height: 35,
                              borderColor: secondary,
                              color: secondary,
                              hintColor: secondary,
                              label: days ?? '...',
                              controller: operatingDays,
                              labelcolor: black,
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
                            color: primary,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.edit,
                              color: primary,
                            ),
                          ),
                        ],
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
                                  bool isSelected =
                                      category == selectedCategory;
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
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Icon(
                                    Icons.add,
                                    color: white,
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
                                color: black,
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
                            color: primary,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.edit,
                              color: primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: white,
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
