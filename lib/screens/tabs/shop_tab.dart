import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zippy/screens/auth/login_screen.dart';
import 'package:zippy/screens/home_screen.dart';
import 'package:zippy/screens/tabs/edit_tab.dart';
import 'package:zippy/services/add_menu.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/widgets/button_widget.dart';
import 'package:zippy/widgets/text_widget.dart';
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
  bool isAvailable = true;
  String? img;

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

  Future<String> uploadImage(File image) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('menu_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
    final uploadTask = storageRef.putFile(image);
    final snapshot = await uploadTask.whenComplete(() => {});
    return await snapshot.ref.getDownloadURL();
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
            img = userDoc.get('img');
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
              _buildHeader(),
              const SizedBox(height: 10),
              _buildProfileCard(),
              _buildMenuList(),
              const SizedBox(height: 5),
              _buildAddMenuButton(),
              const SizedBox(height: 10),
            ],
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: secondary),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.25,
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
            padding: const EdgeInsets.only(top: 25, left: 15, right: 15),
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
                    onPressed: _showLogoutDialog,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCravingOption(Icons.home, 'Home', false, onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                      );
                    }),
                    _buildCravingOption(
                        Icons.store_mall_directory_outlined, 'Shop', true),
                    _buildCravingOption(Icons.edit_square, 'Edit', false,
                        onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const EditScreen()),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Merchant')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(color: secondary),
          );
        }

        var userDoc = snapshot.data!;
        var img = userDoc['img'];

        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          child: Card(
            child: Container(
              width: MediaQuery.of(context).size.width - 48,
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: secondary),
                borderRadius: BorderRadius.circular(10),
                image: img != null
                    ? DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(img),
                      )
                    : const DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/Rectangle 38.png'),
                      ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 15),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: _updateProfileImage,
                            icon: const Icon(
                              Icons.add_a_photo_rounded,
                              color: primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    height: 36,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(7.5),
                        bottomRight: Radius.circular(7.5),
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
                            fontSize: 20,
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
                              const SizedBox(width: 5),
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
        );
      },
    );
  }

  Widget _buildMenuList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Menu')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: secondary),
          );
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error fetching data'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              children: [
                const SizedBox(height: 10),
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
            ),
          );
        }

        final menuItems = snapshot.data!.docs;

        return Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: menuItems.map((item) {
                return _buildMenuItem(item);
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(DocumentSnapshot item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          elevation: 3,
          child: Container(
            width: MediaQuery.of(context).size.width / 4,
            height: MediaQuery.of(context).size.height * 0.17,
            decoration: BoxDecoration(
              image: item['imageUrl'] != ''
                  ? DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(item['imageUrl']),
                    )
                  : null,
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: secondary),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width - 150,
          height: MediaQuery.of(context).size.height * 0.17,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: secondary),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.05,
                decoration: const BoxDecoration(
                  color: secondary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(7.5),
                    topRight: Radius.circular(7.5),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextWidget(
                          text: item['name'] ?? 'Unavailable',
                          fontSize: 15,
                          fontFamily: 'Bold',
                          color: white,
                          maxLines: 2,
                          align: TextAlign.start,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () => _showEditDialog(item),
                            child: Icon(Icons.edit, color: white, size: 20),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () => _showDeleteDialog(item.id),
                            child: Icon(Icons.delete, color: white, size: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextWidget(
                maxLines: 2,
                text: item['description'] ?? 'Unavailable',
                fontSize: 15,
                fontFamily: 'Medium',
                color: Colors.black,
              ),
              // const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      text: item['price'] != null
                          ? '₱ ${item['price']}.00'
                          : 'Unavailable',
                      fontSize: 18,
                      fontFamily: 'Bold',
                      color: secondary,
                    ),
                    TextWidget(
                      text: item['availability'] == 'Not Available'
                          ? 'Not Available'
                          : "Available",
                      fontSize: 16,
                      color: secondary,
                      fontFamily: "Bold",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddMenuButton() {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width - 48,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: secondary),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration:
                  const BoxDecoration(color: secondary, shape: BoxShape.circle),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: GestureDetector(
                  onTap: _showAddMenuDialog,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ),
            // const SizedBox(height: 3),
            TextWidget(
              text: 'add menu item',
              fontSize: 16,
              fontFamily: 'Medium',
              color: secondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCravingOption(IconData icon, String label, bool selected,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
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
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: TextWidget(
            text: 'Are you sure you want to logout?',
            fontSize: 20,
            fontFamily: "ExtraBold",
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  // padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: secondary,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: secondary),
                  ),
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: TextWidget(
                      text: 'No',
                      fontSize: 17,
                      color: white,
                      fontFamily: "Bold",
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  // padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: secondary),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _auth.signOut();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                        (Route<dynamic> route) => false,
                      );
                      showToast('Logout Successful');
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
            ),
          ],
        );
      },
    );
  }

  void _updateProfileImage() async {
    await _pickImage();
    if (_image != null) {
      String imageUrl = await uploadImage(_image!);
      User? user = _auth.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('Merchant')
            .doc(user.uid)
            .update({'img': imageUrl});
      }
    }
  }

  void _showEditDialog(DocumentSnapshot item) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        name.text = item['name'] ?? '';
        price.text = item['price']?.toString() ?? '';
        desc.text = item['description'] ?? '';
        _voucherOption = item['voucherOption'] ?? 'No';
        _image = null;
        isAvailable = item['availability'] == 'Available';

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isAvailable = !isAvailable;
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: secondary),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    alignment: isAvailable
                                        ? Alignment.centerLeft
                                        : Alignment.centerRight,
                                    child: Container(
                                      width: double.infinity / 2,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: isAvailable
                                            ? secondary
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      alignment: Alignment.center,
                                      child: TextWidget(
                                        text: "AVAILABLE",
                                        fontSize: 18,
                                        color: isAvailable ? white : secondary,
                                        fontFamily: "Bold",
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    alignment: isAvailable
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Container(
                                      width: double.infinity / 2,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: !isAvailable
                                            ? secondary
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      alignment: Alignment.center,
                                      child: TextWidget(
                                        text: "NOT AVAILABLE",
                                        fontSize: 18,
                                        color: !isAvailable ? white : secondary,
                                        fontFamily: "Bold",
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                                              : item['imageUrl'] != ''
                                                  ? DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: NetworkImage(
                                                          item['imageUrl']),
                                                    )
                                                  : null,
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(color: secondary),
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
                            const SizedBox(width: 5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 300,
                                  child: TextFormField(
                                    style: const TextStyle(color: primary),
                                    controller: name,
                                    decoration: const InputDecoration(
                                      hintText: 'Food Name',
                                      hintStyle: TextStyle(
                                        color: primary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 300,
                                  child: TextFormField(
                                    style: const TextStyle(color: primary),
                                    keyboardType: TextInputType.number,
                                    controller: price,
                                    decoration: const InputDecoration(
                                      hintText: 'Price Amount',
                                      hintStyle: TextStyle(
                                        color: primary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                // const SizedBox(height: 10),
                                // TextWidget(
                                //   text: 'Accept Voucher',
                                //   fontSize: 12,
                                //   fontFamily: 'Medium',
                                //   color: primary,
                                // ),
                                // Row(
                                //   children: [
                                //     Radio<String>(
                                //       value: 'Yes',
                                //       groupValue: _voucherOption,
                                //       onChanged: (String? value) {
                                //         setState(() {
                                //           _voucherOption = value!;
                                //         });
                                //       },
                                //     ),
                                //     const Text('Yes'),
                                //     Radio<String>(
                                //       value: 'No',
                                //       groupValue: _voucherOption,
                                //       onChanged: (String? value) {
                                //         setState(() {
                                //           _voucherOption = value!;
                                //         });
                                //       },
                                //     ),
                                //     const Text('No'),
                                //   ],
                                // ),
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
                    const SizedBox(height: 10),
                  ],
                ),
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
                      },
                    ),
                    const SizedBox(width: 15),
                    ButtonWidget(
                      width: 115,
                      label: 'Update',
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        await FirebaseFirestore.instance
                            .collection('Menu')
                            .doc(item.id)
                            .update({
                          'name': name.text,
                          'price': num.parse(price.text),
                          'description': desc.text,
                          'voucherOption': _voucherOption,
                          'imageUrl': _image != null
                              ? await uploadImage(_image!)
                              : item['imageUrl'],
                          'availability':
                              isAvailable ? 'Available' : 'Not Available',
                        });

                        setState(() {
                          _isLoading = false;
                        });

                        showToast('Successfully updated!');
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const ShopTab()),
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
  }

  void _showDeleteDialog(String itemId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: TextWidget(
            text: 'Are you sure you want to remove from the list?',
            fontSize: 23,
            color: secondary,
            fontFamily: "Bold",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: TextWidget(
                text: 'Cancel',
                fontSize: 18,
                color: secondary,
                fontFamily: "Bold",
              ),
            ),
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('Menu')
                    .doc(itemId)
                    .delete();
                Navigator.of(context).pop();
                showToast('Successfully removed!');
              },
              child: TextWidget(
                text: 'OK',
                fontSize: 18,
                fontFamily: "Bold",
                color: secondary,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAddMenuDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Stack(
              children: [
                AlertDialog(
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(color: secondary),
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
                            const SizedBox(width: 5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 300,
                                  child: TextFormField(
                                    style: const TextStyle(color: primary),
                                    controller: name,
                                    decoration: const InputDecoration(
                                      hintText: 'Food Name',
                                      hintStyle: TextStyle(
                                        color: primary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 300,
                                  child: TextFormField(
                                    style: const TextStyle(color: primary),
                                    keyboardType: TextInputType.number,
                                    controller: price,
                                    decoration: const InputDecoration(
                                      hintText: 'Price Amount',
                                      hintStyle: TextStyle(
                                        color: primary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                // const SizedBox(height: 10),
                                // TextWidget(
                                //   text: 'Accept Voucher',
                                //   fontSize: 12,
                                //   fontFamily: 'Medium',
                                //   color: primary,
                                // ),
                                // Row(
                                //   children: [
                                //     Radio<String>(
                                //       value: 'Yes',
                                //       groupValue: _voucherOption,
                                //       onChanged: (String? value) {
                                //         setState(() {
                                //           _voucherOption = value!;
                                //         });
                                //       },
                                //     ),
                                //     const Text('Yes'),
                                //     Radio<String>(
                                //       value: 'No',
                                //       groupValue: _voucherOption,
                                //       onChanged: (String? value) {
                                //         setState(() {
                                //           _voucherOption = value!;
                                //         });
                                //       },
                                //     ),
                                //     const Text('No'),
                                //   ],
                                // ),
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
                        const SizedBox(height: 10),
                      ],
                    ),
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
                          },
                        ),
                        const SizedBox(width: 15),
                        ButtonWidget(
                          width: 115,
                          label: 'Add Menu',
                          onPressed: () async {
                            if (_image == null ||
                                name.text.isEmpty ||
                                price.text.isEmpty ||
                                desc.text.isEmpty ||
                                _voucherOption.isEmpty) {
                              showToast('Please fill all fields.');
                              return;
                            }

                            setState(() {
                              _isLoading = true;
                            });

                            await addMenu(
                              name.text,
                              num.parse(price.text),
                              desc.text,
                              _voucherOption,
                              _image,
                            );
                            showToast('Successfully added!');
                            setState(() {
                              _isLoading = false;
                            });
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const ShopTab(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(color: secondary),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
