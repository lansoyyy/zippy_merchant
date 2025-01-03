import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zippy/screens/tabs/edit_tab.dart';
import 'package:zippy/screens/tabs/shop_tab.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? businessName;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
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
                                onTap: () {},
                                child: _buildCravingOption(
                                    Icons.home, 'Home', true)),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 0; i < 6; i++)
                  Container(
                    width: 45,
                    height: 70,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: secondary,
                      ),
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextWidget(
                          text: 'Aug',
                          fontSize: 12,
                          fontFamily: 'Medium',
                          color: secondary,
                        ),
                        TextWidget(
                          text: '${i + 1}',
                          fontSize: 32,
                          fontFamily: 'Bold',
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            TextWidget(
              text: '₱18,760',
              fontSize: 64,
              fontFamily: 'Bold',
              color: secondary,
            ),
            TextWidget(
              text: 'total earned this week',
              fontSize: 18,
              fontFamily: 'Medium',
              color: secondary,
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
              height: 500,
              width: double.infinity,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          text: '78 orders',
                          fontSize: 40,
                          fontFamily: 'Bold',
                          color: Colors.white,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextWidget(
                              text: '15.2%',
                              fontSize: 24,
                              fontFamily: 'Regular',
                              color: Colors.white,
                            ),
                            TextWidget(
                              text: 'higher than last week',
                              fontSize: 8,
                              fontFamily: 'Regular',
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    height: 434,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget(
                                    text: 'Transactions',
                                    fontSize: 40,
                                    fontFamily: 'Bold',
                                    color: secondary,
                                  ),
                                  TextWidget(
                                    text: 'recent orders made in the week',
                                    fontSize: 16,
                                    fontFamily: 'Regular',
                                    color: secondary,
                                  ),
                                ],
                              ),
                              Image.asset(
                                'assets/images/star.png',
                                height: 35,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return Center(
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  height: 80,
                                  width: 320,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: secondary,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextWidget(
                                              text: '₱570.00',
                                              fontSize: 16,
                                              fontFamily: 'Bold',
                                              color: secondary,
                                            ),
                                            TextWidget(
                                              text: '111 2222 3333 444',
                                              fontSize: 12,
                                              fontFamily: 'Medium',
                                              color: Colors.black,
                                            ),
                                            TextWidget(
                                              text:
                                                  'Completed on 13/08/24 at 4:50PM',
                                              fontSize: 12,
                                              fontFamily: 'Medium',
                                              color: secondary,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            TextWidget(
                                              text: 'Preparing',
                                              fontSize: 14,
                                              fontFamily: 'Bold',
                                              color: Colors.red,
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            TextWidget(
                                              text: 'View List',
                                              fontSize: 14,
                                              fontFamily: 'Bold',
                                              color: secondary,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

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
