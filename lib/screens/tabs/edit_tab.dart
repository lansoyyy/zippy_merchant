import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:zippy/screens/auth/login_screen.dart';
import 'package:zippy/screens/home_screen.dart';
import 'package:zippy/screens/tabs/shop_tab.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/utils/const.dart';
import 'package:zippy/utils/keys.dart';
import 'package:zippy/widgets/text_widget.dart';
import 'package:google_maps_webservice/places.dart' as location;

import 'package:zippy/widgets/textfield_widget.dart';
import 'package:zippy/widgets/toast_widget.dart';
import 'package:google_api_headers/google_api_headers.dart';

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
  Map<String, dynamic>? userData;
  String? businessName;
  String? description;
  String? add;
  String? id;
  String? hours;
  String? days;
  String? name;
  bool isEditing = false;
  bool isBusinessNameEditing = false;
  bool isDescEditing = false;
  bool isAddEditing = false;
  bool isTimeEditing = false;
  bool isDayEditing = false;
  bool isMerchantEditing = false;

  TextEditingController businessNameController = TextEditingController();
  TextEditingController merchantController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController addController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dayController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<dynamic> categories = [];
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> updateDesc() async {
    try {
      await FirebaseFirestore.instance
          .collection('Merchant')
          .doc(userId)
          .update({'desc': descController.text});
      setState(() {
        userData!['name'] = descController.text;
        isEditing = false;
      });
    } catch (e) {
      print("Error updating name: $e");
    }
  }

  Future<void> updateBusinessName() async {
    try {
      await FirebaseFirestore.instance
          .collection('Merchant')
          .doc(userId)
          .update({'businessName': businessNameController.text});
      setState(() {
        userData!['businessName'] = businessNameController.text;
        isBusinessNameEditing = false;
      });
    } catch (e) {
      print("Error updating name: $e");
    }
  }

  Future<void> updateAddress() async {
    try {
      await FirebaseFirestore.instance
          .collection('Merchant')
          .doc(userId)
          .update({'address': addController.text});
      setState(() {
        userData!['address'] = addController.text;
        isAddEditing = false;
      });
    } catch (e) {
      print("Error updating name: $e");
    }
  }

  Future<void> updateMerchantId() async {
    try {
      await FirebaseFirestore.instance
          .collection('Merchant')
          .doc(userId)
          .update({'merchantId': merchantController.text});
      setState(() {
        userData!['merchantId'] = merchantController.text;
        isMerchantEditing = false;
      });
    } catch (e) {
      print("Error updating name: $e");
    }
  }

  Future<void> updateOpeHours() async {
    try {
      await FirebaseFirestore.instance
          .collection('Merchant')
          .doc(userId)
          .update({'operatingHours': timeController.text});
      setState(() {
        userData!['operatingHours'] = timeController.text;
        isTimeEditing = false;
      });
    } catch (e) {
      print("Error updating name: $e");
    }
  }

  Future<void> updateOpeDays() async {
    try {
      await FirebaseFirestore.instance
          .collection('Merchant')
          .doc(userId)
          .update({'operatingDays': dayController.text});
      setState(() {
        userData!['operatingDays'] = dayController.text;
        isDayEditing = false;
      });
    } catch (e) {
      print("Error updating name: $e");
    }
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
            Stack(
              clipBehavior: Clip.none,
              children: [
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Merchant')
                      .doc(userId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: secondary,
                      ));
                    }
                    if (snapshot.hasError) {
                      return Center(
                          child: TextWidget(
                        text: 'Error loading image',
                        fontSize: 18,
                        color: secondary,
                        fontFamily: "Medium",
                      ));
                    }
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return Center(
                          child: TextWidget(
                        text: 'No image available',
                        fontSize: 18,
                        color: secondary,
                        fontFamily: "Medium",
                      ));
                    }
                    var userDoc = snapshot.data!;
                    var imageUrl =
                        userDoc.get('img') ?? 'assets/images/Rectangle 38.png';
                    return Positioned(
                      top: MediaQuery.of(context).size.height * 0.17,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: 500,
                        height: 250,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.25,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.transparent,
                                  )),
                              TextWidget(
                                text: businessName ?? '...',
                                fontSize: 22,
                                fontFamily: 'Bold',
                                color: Colors.white,
                              ),
                              IconButton(
                                icon: Icon(Icons.logout, color: white),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: TextWidget(
                                            text:
                                                'Are you sure you want to logout?',
                                            fontSize: 20,
                                            fontFamily: "ExtraBold",
                                          ),
                                          actions: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.25,
                                                  // padding:
                                                  //     const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                    color: secondary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                      color: secondary,
                                                    ),
                                                  ),
                                                  child: TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: TextWidget(
                                                      text: 'No',
                                                      fontSize: 17,
                                                      color: white,
                                                      fontFamily: "Bold",
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.25,
                                                  // padding:
                                                  //     const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                      color: secondary,
                                                    ),
                                                  ),
                                                  child: TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      _auth.signOut();
                                                      Navigator.of(context)
                                                          .pushAndRemoveUntil(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const LoginScreen()),
                                                        (Route<dynamic>
                                                                route) =>
                                                            false,
                                                      );
                                                      showToast(
                                                          'Logout Successful');
                                                    },
                                                    child: TextWidget(
                                                      text: 'Logout',
                                                      fontSize: 17,
                                                      color: secondary,
                                                      fontFamily: "Bold",
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        );
                                      });
                                },
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
                                          builder: (context) =>
                                              const ShopTab()),
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
              ],
            ),
            const SizedBox(
              height: 190,
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              height: MediaQuery.of(context).size.height * 0.6,
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
                            onPressed: () {
                              showToast('Click the field to edit');
                              // setState(() {
                              //   isDescEditing = true;
                              //   descController.text = description ?? '';
                              // });
                            },
                            icon: const Icon(
                              Icons.help_outlined,
                              color: primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: isDescEditing
                            ? Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: descController,
                                      maxLines: 4,
                                      maxLength: 150,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                              color: secondary),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.all(10),
                                      ),
                                      style: TextStyle(
                                        color: black,
                                        fontSize: 15,
                                        fontFamily: "Bold",
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.check,
                                          color: Colors.green,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          updateDesc();
                                          setState(() {
                                            description = descController
                                                .text; // Update description
                                            isDescEditing = false;
                                          });
                                        },
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.cancel,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isDescEditing = false;
                                            descController.text = description ??
                                                'No description available'; // Revert changes
                                          });
                                        },
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isDescEditing = true;
                                    descController.text = description ?? '';
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  height:
                                      MediaQuery.of(context).size.height * 0.15,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: secondary,
                                    ),
                                  ),
                                  child: Center(
                                    child: TextWidget(
                                      text: description ??
                                          'No description available',
                                      fontSize: 15,
                                      fontFamily: "Bold",
                                      color: grey,
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
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            onPressed: () {
                              showToast('Click the field to edit');
                              // setState(() {
                              //   isBusinessNameEditing = true;
                              //   businessNameController.text =
                              //       businessName ?? '';
                              //   isMerchantEditing = true;
                              //   merchantController.text = id ?? '';
                              //   isAddEditing = true;
                              //   addController.text = add ?? '';
                              //   isTimeEditing = true;
                              //   timeController.text = hours ?? '';
                              //   isDayEditing = true;
                              //   dayController.text = days ?? '';
                              // });
                            },
                            icon: const Icon(
                              Icons.help_outlined,
                              color: primary,
                            ),
                          ),
                        ],
                      ),
                      TextWidget(
                          text: 'Business Name', fontSize: 18, color: black),
                      // THis is for businessName
                      isBusinessNameEditing
                          ? Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                  child: TextField(
                                    decoration: const InputDecoration(
                                        border: InputBorder.none),
                                    controller: businessNameController,
                                    style: TextStyle(
                                      color: black,
                                      fontSize: 23,
                                      fontFamily: 'Bold',
                                    ),
                                  ),
                                ),
                                IconButton(
                                    icon: const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      updateBusinessName();
                                      setState(() {
                                        businessName = businessNameController
                                            .text; // Update description
                                        isBusinessNameEditing = false;
                                      });
                                    } // Confirm number update

                                    ),
                                const Padding(padding: EdgeInsets.zero),
                                IconButton(
                                  icon: const Icon(Icons.cancel,
                                      color: Colors.red, size: 17),
                                  onPressed: () {
                                    setState(() {
                                      isBusinessNameEditing = false;
                                      businessNameController.text = businessName ??
                                          'No name available'; // Revert changes
                                    });
                                  },
                                ),
                              ],
                            )
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  isBusinessNameEditing = true;
                                  businessNameController.text =
                                      businessName ?? '';
                                });
                              },
                              child: TextWidget(
                                text: businessName ?? '...',
                                fontSize: 23,
                                color: grey,
                                fontFamily: 'Bold',
                              ),
                            ),
                      const Divider(
                        color: primary,
                        thickness: 1,
                        endIndent: 0,
                      ),
                      TextWidget(text: 'Address', fontSize: 18, color: black),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              {
                                location.Prediction? p =
                                    await PlacesAutocomplete.show(
                                        mode: Mode.overlay,
                                        context: context,
                                        apiKey: kGoogleApiKey,
                                        language: 'en',
                                        strictbounds: false,
                                        types: [""],
                                        decoration: InputDecoration(
                                            hintText: 'Search Address',
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: const BorderSide(
                                                    color: Colors.white))),
                                        components: [
                                          location.Component(
                                              location.Component.country, "ph")
                                        ]);

                                if (p != null) {
                                  location.GoogleMapsPlaces places =
                                      location.GoogleMapsPlaces(
                                          apiKey: kGoogleApiKey,
                                          apiHeaders:
                                              await const GoogleApiHeaders()
                                                  .getHeaders());

                                  location.PlacesDetailsResponse detail =
                                      await places
                                          .getDetailsByPlaceId(p.placeId!);

                                  await FirebaseFirestore.instance
                                      .collection('Merchant')
                                      .doc(userId)
                                      .update({
                                    'address': detail.result.name,
                                    'lat': detail.result.geometry!.location.lat,
                                    'lng': detail.result.geometry!.location.lng,
                                  });

                                  setState(() {
                                    add = detail.result.name;
                                    addController.text = detail.result.name;
                                  });
                                }
                              }
                            },
                            child: TextWidget(
                              text: add ?? '...',
                              fontSize: 23,
                              color: grey,
                              fontFamily: 'Bold',
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        color: primary,
                        thickness: 1,
                        endIndent: 0,
                      ),
                      TextWidget(
                          text: 'Merchant ID', fontSize: 18, color: black),
                      isMerchantEditing
                          ? Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                  child: TextField(
                                    decoration: const InputDecoration(
                                        border: InputBorder.none),
                                    controller: merchantController,
                                    style: TextStyle(
                                      color: black,
                                      fontSize: 23,
                                      fontFamily: 'Bold',
                                    ),
                                  ),
                                ),
                                IconButton(
                                    icon: const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      updateMerchantId();
                                      setState(() {
                                        id = merchantController
                                            .text; // Update description
                                        isMerchantEditing = false;
                                      });
                                    } // Confirm number update

                                    ),
                                const Padding(padding: EdgeInsets.zero),
                                IconButton(
                                  icon: const Icon(Icons.cancel,
                                      color: Colors.red, size: 17),
                                  onPressed: () {
                                    setState(() {
                                      isMerchantEditing = false;
                                      merchantController.text = id ??
                                          'No Id available'; // Revert changes
                                    });
                                  },
                                ),
                              ],
                            )
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  isMerchantEditing = true;
                                  merchantController.text = id ?? '';
                                });
                              },
                              child: TextWidget(
                                text: id ?? '...',
                                fontSize: 23,
                                color: grey,
                                fontFamily: 'Bold',
                              ),
                            ),
                      const Divider(
                        color: primary,
                        thickness: 1,
                        endIndent: 0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextWidget(
                              text: 'Operating Hours',
                              fontSize: 18,
                              color: black),
                          TextWidget(
                              text: 'Operating Days',
                              fontSize: 18,
                              color: black),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          isTimeEditing
                              ? Row(
                                  children: [
                                    SizedBox(
                                      width: 55,
                                      child: TextField(
                                        decoration: const InputDecoration(
                                            border: InputBorder.none),
                                        controller: timeController,
                                        style: TextStyle(
                                          color: black,
                                          fontSize: 23,
                                          fontFamily: 'Bold',
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                        icon: const Icon(
                                          Icons.check,
                                          color: Colors.green,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          updateOpeHours();
                                          setState(() {
                                            hours = timeController
                                                .text; // Update description
                                            isTimeEditing = false;
                                          });
                                        } // Confirm number update

                                        ),
                                    const Padding(padding: EdgeInsets.zero),
                                    IconButton(
                                      icon: const Icon(Icons.cancel,
                                          color: Colors.red, size: 17),
                                      onPressed: () {
                                        setState(() {
                                          isTimeEditing = false;
                                          timeController.text = hours ??
                                              'No time available'; // Revert changes
                                        });
                                      },
                                    ),
                                  ],
                                )
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isTimeEditing = true;
                                      timeController.text = hours ?? '';
                                    });
                                  },
                                  child: TextWidget(
                                    text: hours ?? '...',
                                    fontSize: 23,
                                    color: grey,
                                    fontFamily: 'Bold',
                                  ),
                                ),
                          // Days daun ni
                          isDayEditing
                              ? Row(
                                  children: [
                                    SizedBox(
                                      width: 55,
                                      child: TextField(
                                        decoration: const InputDecoration(
                                            border: InputBorder.none),
                                        controller: dayController,
                                        style: TextStyle(
                                          color: black,
                                          fontSize: 23,
                                          fontFamily: 'Bold',
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                        icon: const Icon(
                                          Icons.check,
                                          color: Colors.green,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          updateOpeDays();
                                          setState(() {
                                            days = dayController
                                                .text; // Update description
                                            isDayEditing = false;
                                          });
                                        } // Confirm number update

                                        ),
                                    const Padding(padding: EdgeInsets.zero),
                                    IconButton(
                                      icon: const Icon(Icons.cancel,
                                          color: Colors.red, size: 17),
                                      onPressed: () {
                                        setState(() {
                                          isDayEditing = false;
                                          dayController.text = days ??
                                              'No days available'; // Revert changes
                                        });
                                      },
                                    ),
                                  ],
                                )
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isDayEditing = true;
                                      dayController.text = days ?? '';
                                    });
                                  },
                                  child: TextWidget(
                                    text: days ?? '...',
                                    fontSize: 23,
                                    color: grey,
                                    fontFamily: 'Bold',
                                  ),
                                ),
                        ],
                      ),
                      const Divider(
                        color: primary,
                        thickness: 1,
                        endIndent: 0,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // Row(
                      //   children: [
                      //     TextWidget(
                      //       text: 'Categories',
                      //       fontSize: 28,
                      //       fontFamily: 'Bold',
                      //       color: primary,
                      //     ),
                      //     const SizedBox(
                      //       width: 10,
                      //     ),
                      //     IconButton(
                      //       onPressed: () {},
                      //       icon: const Icon(
                      //         Icons.edit,
                      //         color: primary,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     SizedBox(
                      //       width: 250,
                      //       child: SingleChildScrollView(
                      //         scrollDirection: Axis.horizontal,
                      //         child: Row(
                      //           children: categories.map((category) {
                      //             bool isSelected =
                      //                 category == selectedCategory;
                      //             return Row(
                      //               children: [
                      //                 InkWell(
                      //                   onTap: () {
                      //                     setState(() {
                      //                       selectedCategory = category;
                      //                     });
                      //                   },
                      //                   child: Container(
                      //                     padding: const EdgeInsets.symmetric(
                      //                         vertical: 3, horizontal: 5),
                      //                     decoration: BoxDecoration(
                      //                       color: isSelected
                      //                           ? secondary
                      //                           : Colors.transparent,
                      //                       borderRadius:
                      //                           BorderRadius.circular(8),
                      //                     ),
                      //                     child: Text(
                      //                       category,
                      //                       style: TextStyle(
                      //                         fontSize: 15,
                      //                         fontFamily: 'Medium',
                      //                         color: isSelected
                      //                             ? Colors.white
                      //                             : Colors.black,
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ),
                      //                 const SizedBox(width: 10),
                      //               ],
                      //             );
                      //           }).toList(),
                      //         ),
                      //       ),
                      //     ),
                      //     const SizedBox(
                      //       width: 15,
                      //     ),
                      //     Row(
                      //       children: [
                      //         Container(
                      //           decoration: const BoxDecoration(
                      //               color: secondary, shape: BoxShape.circle),
                      //           child: Padding(
                      //             padding: const EdgeInsets.all(3.0),
                      //             child: Icon(
                      //               Icons.add,
                      //               color: white,
                      //               size: 15,
                      //             ),
                      //           ),
                      //         ),
                      //         const SizedBox(
                      //           width: 5,
                      //         ),
                      //         TextWidget(
                      //           text: 'Add',
                      //           fontSize: 14,
                      //           fontFamily: 'Medium',
                      //           color: black,
                      //         ),
                      //       ],
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // Row(
                      //   children: [
                      //     TextWidget(
                      //       text: 'Wallet',
                      //       fontSize: 28,
                      //       fontFamily: 'Bold',
                      //       color: primary,
                      //     ),
                      //     const SizedBox(
                      //       width: 10,
                      //     ),
                      //     IconButton(
                      //       onPressed: () {},
                      //       icon: const Icon(
                      //         Icons.edit,
                      //         color: primary,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // Container(
                      //   decoration: BoxDecoration(
                      //     color: white,
                      //     borderRadius: BorderRadius.circular(10),
                      //   ),
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(left: 30, right: 30),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         Image.asset(
                      //           gcash,
                      //           width: 80,
                      //           height: 25,
                      //         ),
                      //         TextWidget(
                      //           text: '+639 9999 9999',
                      //           fontSize: 12,
                      //           color: secondary,
                      //           fontFamily: 'Medium',
                      //         ),
                      //         Container(
                      //           width: 60,
                      //           height: 18,
                      //           decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(20),
                      //             color: secondary,
                      //           ),
                      //           child: Center(
                      //             child: TextWidget(
                      //               text: 'Unlink',
                      //               fontSize: 10,
                      //               color: Colors.white,
                      //               fontFamily: 'Medium',
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // Container(
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.circular(10),
                      //   ),
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(left: 30, right: 30),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         Image.asset(
                      //           paymaya,
                      //           width: 80,
                      //           height: 25,
                      //         ),
                      //         const SizedBox(),
                      //         Container(
                      //           width: 60,
                      //           height: 18,
                      //           decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(20),
                      //             border: Border.all(
                      //               color: secondary,
                      //             ),
                      //           ),
                      //           child: Center(
                      //             child: TextWidget(
                      //               text: 'Link',
                      //               fontSize: 10,
                      //               color: secondary,
                      //               fontFamily: 'Medium',
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // Container(
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.circular(10),
                      //   ),
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(left: 30, right: 30),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         Row(
                      //           crossAxisAlignment: CrossAxisAlignment.center,
                      //           children: [
                      //             Image.asset(
                      //               bpi,
                      //               width: 25,
                      //               height: 25,
                      //             ),
                      //             const SizedBox(
                      //               width: 5,
                      //             ),
                      //             TextWidget(
                      //               text: 'BPI',
                      //               fontSize: 15,
                      //               color: secondary,
                      //             ),
                      //           ],
                      //         ),
                      //         TextWidget(
                      //           text: '123 1234 1234',
                      //           fontSize: 12,
                      //           color: secondary,
                      //           fontFamily: 'Medium',
                      //         ),
                      //         Container(
                      //           width: 60,
                      //           height: 18,
                      //           decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(20),
                      //             color: secondary,
                      //           ),
                      //           child: Center(
                      //             child: TextWidget(
                      //               text: 'Unlink',
                      //               fontSize: 10,
                      //               color: Colors.white,
                      //               fontFamily: 'Medium',
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
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
