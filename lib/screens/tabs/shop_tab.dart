import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zippy/screens/home_screen.dart';
import 'package:zippy/screens/tabs/edit_tab.dart';
import 'package:zippy/services/add_menu.dart';

import 'package:zippy/utils/colors.dart';
import 'package:zippy/utils/const.dart';
import 'package:zippy/widgets/button_widget.dart';
import 'package:zippy/widgets/text_widget.dart';
import 'package:zippy/widgets/textfield_widget.dart';
import 'package:zippy/widgets/toast_widget.dart';

class ShopTab extends StatefulWidget {
  const ShopTab({super.key});

  @override
  State<ShopTab> createState() => _ShopTabState();
}

class _ShopTabState extends State<ShopTab> {
  bool _isLoading = false;
  File? _image;
  String _voucherOption = '';
  final name = TextEditingController();
  final price = TextEditingController();
  final desc = TextEditingController();
  String? businessName;
  List<dynamic> categories = [];
  String? selectedCategory;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
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
      body: Stack(
        children: [
          Column(
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
              SizedBox(
                child: Card(
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
                                      color: isSelected ? black : primary,
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
              // This is the main body
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Menu')
                    .where('uid',
                        isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(child: Text('Error fetching data'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                        child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Image.asset(
                          'assets/images/Group 121 (2).png',
                          width: 200,
                          height: 200,
                        ),
                        TextWidget(
                          text: 'No menu items available',
                          fontSize: 25,
                          fontFamily: 'Bold',
                          color: secondary,
                        ),
                      ],
                    ));
                  }

                  final menuItems = snapshot.data!.docs;

                  return Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 8.0, 0),
                        child: Column(
                          children: menuItems.map((item) {
                            return Row(
                              children: [
                                Card(
                                  elevation: 3,
                                  child: Container(
                                    width: 100,
                                    height: 112.5,
                                    decoration: BoxDecoration(
                                      image: item['imageUrl'] != ''
                                          ? DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  item['imageUrl']),
                                            )
                                          : null,
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: secondary,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: 33,
                                          decoration: const BoxDecoration(
                                            color: secondary,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(7.5),
                                              topRight: Radius.circular(7.5),
                                            ),
                                          ),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                TextWidget(
                                                  text: item['name'] ??
                                                      'Unavailable',
                                                  fontSize: 18,
                                                  fontFamily: 'Bold',
                                                  color: white,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return StatefulBuilder(
                                                          builder: (context,
                                                              setState) {
                                                            return AlertDialog(
                                                              content:
                                                                  SingleChildScrollView(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        StatefulBuilder(
                                                                          builder:
                                                                              (BuildContext context, StateSetter setState) {
                                                                            return Card(
                                                                              child: Stack(
                                                                                children: [
                                                                                  Container(
                                                                                    width: 100,
                                                                                    height: 112.5,
                                                                                    decoration: BoxDecoration(
                                                                                      image: _image != null
                                                                                          ? DecorationImage(
                                                                                              fit: BoxFit.fill,
                                                                                              image: FileImage(_image!),
                                                                                            )
                                                                                          : null,
                                                                                      color: Colors.white,
                                                                                      borderRadius: BorderRadius.circular(10),
                                                                                      border: Border.all(
                                                                                        color: secondary,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Center(
                                                                                    child: IconButton(
                                                                                      onPressed: () async {
                                                                                        await _pickImage();
                                                                                        setState(() {});
                                                                                      },
                                                                                      icon: const Icon(
                                                                                        Icons.add_a_photo_rounded,
                                                                                        color: primary,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            );
                                                                          },
                                                                        ),
                                                                        const SizedBox(
                                                                            width:
                                                                                5),
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            SizedBox(
                                                                              width: 100,
                                                                              child: TextFormField(
                                                                                style: const TextStyle(color: primary),
                                                                                controller: name,
                                                                                decoration: const InputDecoration(
                                                                                  hintText: 'Enter Food Name',
                                                                                  hintStyle: TextStyle(
                                                                                    color: primary,
                                                                                    fontSize: 12,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 100,
                                                                              child: TextFormField(
                                                                                style: const TextStyle(color: primary),
                                                                                keyboardType: TextInputType.number,
                                                                                controller: price,
                                                                                decoration: const InputDecoration(
                                                                                  hintText: 'Enter Price Amount',
                                                                                  hintStyle: TextStyle(
                                                                                    color: primary,
                                                                                    fontSize: 12,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            TextWidget(
                                                                              text: 'Accept Voucher',
                                                                              fontSize: 18,
                                                                              fontFamily: 'Medium',
                                                                              color: primary,
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                Radio<String>(
                                                                                  value: 'Yes',
                                                                                  groupValue: _voucherOption,
                                                                                  onChanged: (String? value) {
                                                                                    setState(() {
                                                                                      _voucherOption = value!;
                                                                                    });
                                                                                  },
                                                                                ),
                                                                                const Text('Yes'),
                                                                                Radio<String>(
                                                                                  value: 'No',
                                                                                  groupValue: _voucherOption,
                                                                                  onChanged: (String? value) {
                                                                                    setState(() {
                                                                                      _voucherOption = value!;
                                                                                    });
                                                                                  },
                                                                                ),
                                                                                const Text('No'),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    TextFormField(
                                                                      controller:
                                                                          desc,
                                                                      decoration:
                                                                          const InputDecoration(
                                                                        hintText:
                                                                            'Enter Description',
                                                                        hintStyle:
                                                                            TextStyle(
                                                                          color:
                                                                              primary,
                                                                          fontSize:
                                                                              12,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        TextWidget(
                                                                          text:
                                                                              'Categories',
                                                                          fontSize:
                                                                              15,
                                                                          fontFamily:
                                                                              "Medium",
                                                                          color:
                                                                              primary,
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            GestureDetector(
                                                                              onTap: () {},
                                                                              child: const Icon(
                                                                                Icons.add,
                                                                                color: primary,
                                                                              ),
                                                                            ),
                                                                            TextWidget(
                                                                              text: 'category',
                                                                              fontSize: 12,
                                                                              color: primary,
                                                                              fontFamily: "Regular",
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              actions: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    ButtonWidget(
                                                                        width:
                                                                            115,
                                                                        label:
                                                                            'Cancel',
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        }),
                                                                    const SizedBox(
                                                                      width: 15,
                                                                    ),
                                                                    ButtonWidget(
                                                                        width:
                                                                            115,
                                                                        label:
                                                                            'Update',
                                                                        onPressed:
                                                                            () async {
                                                                          FirebaseFirestore
                                                                              .instance
                                                                              .collection('Menu')
                                                                              .doc(item.id)
                                                                              .delete();
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          await addMenu(
                                                                            name.text,
                                                                            price.text,
                                                                            desc.text,
                                                                            _voucherOption,
                                                                            _image,
                                                                          );
                                                                          showToast(
                                                                              'Successfully updated!');
                                                                          Navigator.of(context)
                                                                              .pushReplacement(
                                                                            MaterialPageRoute(builder: (context) => const ShopTab()),
                                                                          );
                                                                        }),
                                                                  ],
                                                                )
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.edit,
                                                        color: white,
                                                        size: 20,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          showDialog(
                                                              barrierDismissible:
                                                                  true,
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return AlertDialog(
                                                                  title:
                                                                      TextWidget(
                                                                    text:
                                                                        'Are you sure you want to remove from the list?',
                                                                    fontSize:
                                                                        23,
                                                                    color:
                                                                        secondary,
                                                                    fontFamily:
                                                                        "Bold",
                                                                  ),
                                                                  actions: [
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child:
                                                                            TextWidget(
                                                                          text:
                                                                              'Cancel',
                                                                          fontSize:
                                                                              18,
                                                                          color:
                                                                              secondary,
                                                                          fontFamily:
                                                                              "Bold",
                                                                        )),
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          FirebaseFirestore
                                                                              .instance
                                                                              .collection('Menu')
                                                                              .doc(item.id)
                                                                              .delete();
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          showToast(
                                                                              'Successfully removed!');
                                                                        },
                                                                        child:
                                                                            TextWidget(
                                                                          text:
                                                                              'OK',
                                                                          fontSize:
                                                                              18,
                                                                          fontFamily:
                                                                              "Bold",
                                                                          color:
                                                                              secondary,
                                                                        )),
                                                                  ],
                                                                );
                                                              });
                                                        },
                                                        child: Icon(
                                                          Icons.delete,
                                                          color: white,
                                                          size: 20,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        TextWidget(
                                          text: item['description'] ??
                                              'Unavailable',
                                          fontSize: 12,
                                          fontFamily: 'Medium',
                                          color: Colors.black,
                                        ),
                                        const SizedBox(height: 5),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextWidget(
                                                text: item['price'] != null
                                                    ? '₱ ${item['price']}.00'
                                                    : 'Unavailable',
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
                                                    Icons
                                                        .arrow_right_alt_outlined,
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
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  );
                },
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
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      content: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                StatefulBuilder(
                                                  builder: (BuildContext
                                                          context,
                                                      StateSetter setState) {
                                                    return Card(
                                                      child: Stack(
                                                        children: [
                                                          Container(
                                                            width: 100,
                                                            height: 112.5,
                                                            decoration:
                                                                BoxDecoration(
                                                              image: _image !=
                                                                      null
                                                                  ? DecorationImage(
                                                                      fit: BoxFit
                                                                          .fill,
                                                                      image: FileImage(
                                                                          _image!),
                                                                    )
                                                                  : null,
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              border:
                                                                  Border.all(
                                                                color:
                                                                    secondary,
                                                              ),
                                                            ),
                                                          ),
                                                          Center(
                                                            child: IconButton(
                                                              onPressed:
                                                                  () async {
                                                                await _pickImage();
                                                                setState(() {});
                                                              },
                                                              icon: const Icon(
                                                                Icons
                                                                    .add_a_photo_rounded,
                                                                color: primary,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                                const SizedBox(width: 5),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // TextWidget(
                                                    //   text: 'Food Name',
                                                    //   fontSize: 18,
                                                    //   fontFamily: 'Regular',
                                                    //   color: primary,
                                                    // ),
                                                    SizedBox(
                                                      width: 100,
                                                      child: TextFormField(
                                                        style: const TextStyle(
                                                            color: primary),
                                                        controller: name,
                                                        decoration:
                                                            const InputDecoration(
                                                          hintText:
                                                              'Enter Food Name',
                                                          hintStyle: TextStyle(
                                                            color: primary,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    // TextWidget(
                                                    //   text: 'Price',
                                                    //   fontSize: 18,
                                                    //   fontFamily: 'Regular',
                                                    //   color: primary,
                                                    // ),
                                                    SizedBox(
                                                      width: 100,
                                                      child: TextFormField(
                                                        style: const TextStyle(
                                                            color: primary),
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        controller: price,
                                                        decoration:
                                                            const InputDecoration(
                                                          hintText:
                                                              'Enter Price Amount',
                                                          hintStyle: TextStyle(
                                                            color: primary,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    TextWidget(
                                                      text: 'Accept Voucher',
                                                      fontSize: 18,
                                                      fontFamily: 'Medium',
                                                      color: primary,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Radio<String>(
                                                          value: 'Yes',
                                                          groupValue:
                                                              _voucherOption,
                                                          onChanged:
                                                              (String? value) {
                                                            setState(() {
                                                              _voucherOption =
                                                                  value!;
                                                            });
                                                          },
                                                        ),
                                                        const Text('Yes'),
                                                        Radio<String>(
                                                          value: 'No',
                                                          groupValue:
                                                              _voucherOption,
                                                          onChanged:
                                                              (String? value) {
                                                            setState(() {
                                                              _voucherOption =
                                                                  value!;
                                                            });
                                                          },
                                                        ),
                                                        const Text('No'),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            TextFormField(
                                              controller: desc,
                                              decoration: const InputDecoration(
                                                hintText: 'Enter Description',
                                                hintStyle: TextStyle(
                                                  color: primary,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextWidget(
                                                  text: 'Categories',
                                                  fontSize: 15,
                                                  fontFamily: "Medium",
                                                  color: primary,
                                                ),
                                                Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {},
                                                      child: const Icon(
                                                        Icons.add,
                                                        color: primary,
                                                      ),
                                                    ),
                                                    TextWidget(
                                                      text: 'category',
                                                      fontSize: 12,
                                                      color: primary,
                                                      fontFamily: "Regular",
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                              onPressed: () async {
                                                setState(() {
                                                  _isLoading = true;
                                                });

                                                await addMenu(
                                                  name.text,
                                                  price.text,
                                                  desc.text,
                                                  _voucherOption,
                                                  _image,
                                                );
                                                setState(() {
                                                  _isLoading = false;
                                                });
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const ShopTab(),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
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
          if (_isLoading) const CircularProgressIndicator(),
        ],
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
