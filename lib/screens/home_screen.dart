import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:zippy/screens/auth/login_screen.dart';
import 'package:zippy/screens/tabs/edit_tab.dart';
import 'package:zippy/screens/tabs/shop_tab.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/widgets/button_widget.dart';
import 'package:zippy/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zippy/widgets/toast_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? businessName;
  String? merchantId;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int orderCount = 0;
  double totalEarned = 0.0;
  String selectedStatus = 'Pending';

  @override
  void initState() {
    super.initState();
    fetchUserData();
    // fetchOrderCount();
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
            merchantId = userDoc.get('id');
          });
          fetchOrderCount();
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchOrderCount() async {
    if (merchantId == null) {
      print("Merchant ID is null. Cannot fetch orders.");
      return;
    }
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Orders')
          .where('merchantId', isEqualTo: merchantId)
          .get();

      double calculatedTotalPrice = 0.0;
      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null &&
            data.containsKey('items') &&
            data['items'] is List) {
          for (var item in data['items']) {
            if (item.containsKey('price')) {
              calculatedTotalPrice += item['price'];
            }
          }
        }
      }

      setState(() {
        orderCount = querySnapshot.size;
        totalEarned = calculatedTotalPrice;
      });
    } catch (e) {
      print('Error fetching order count: $e');
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
              height: MediaQuery.of(context).size.height * 0.21,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidget(
                            text: '...',
                            fontSize: 22,
                            fontFamily: 'Bold',
                            color: Colors.transparent,
                          ),
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
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: secondary,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: secondary,
                                                ),
                                              ),
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
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
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: secondary,
                                                ),
                                              ),
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  _auth.signOut();
                                                  Navigator.of(context)
                                                      .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const LoginScreen()),
                                                    (Route<dynamic> route) =>
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
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     for (int i = 0; i < 6; i++)
            //       Container(
            //         width: 45,
            //         height: 70,
            //         decoration: BoxDecoration(
            //           border: Border.all(
            //             color: secondary,
            //           ),
            //           borderRadius: BorderRadius.circular(
            //             10,
            //           ),
            //         ),
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           children: [
            //             TextWidget(
            //               text: 'Aug',
            //               fontSize: 12,
            //               fontFamily: 'Medium',
            //               color: secondary,
            //             ),
            //             TextWidget(
            //               text: '${i + 1}',
            //               fontSize: 32,
            //               fontFamily: 'Bold',
            //               color: Colors.black,
            //             ),
            //           ],
            //         ),
            //       ),
            //   ],
            // ),

            // const SizedBox(
            //   height: 10,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(7, (index) {
                DateTime now = DateTime.now();
                DateTime date =
                    now.subtract(Duration(days: now.weekday - 1 - index));
                bool isToday = date.day == now.day &&
                    date.month == now.month &&
                    date.year == now.year;
                return Container(
                  width: MediaQuery.of(context).size.width * 0.12,
                  height: MediaQuery.of(context).size.width * 0.2,
                  decoration: BoxDecoration(
                    color: isToday ? secondary : Colors.transparent,
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
                        text: [
                          'Jan',
                          'Feb',
                          'Mar',
                          'Apr',
                          'May',
                          'Jun',
                          'Jul',
                          'Aug',
                          'Sep',
                          'Oct',
                          'Nov',
                          'Dec'
                        ][date.month - 1],
                        fontSize: 12,
                        fontFamily: 'Medium',
                        color: isToday ? Colors.white : secondary,
                      ),
                      TextWidget(
                        text: '${date.day}',
                        fontSize: 32,
                        fontFamily: 'Bold',
                        color: isToday ? Colors.white : Colors.black,
                      ),
                    ],
                  ),
                );
              }),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Orders')
                  .where('merchantId', isEqualTo: merchantId)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }

                final orders = snapshot.data!.docs;
                double calculatedTotalPrice = 0.0;
                for (var doc in orders) {
                  final data = doc.data() as Map<String, dynamic>?;
                  if (data != null &&
                      data.containsKey('items') &&
                      data['items'] is List) {
                    for (var item in data['items']) {
                      if (item.containsKey('price')) {
                        calculatedTotalPrice += item['price'];
                      }
                    }
                  }
                }

                orderCount = orders.length;
                totalEarned = calculatedTotalPrice;

                return Column(
                  children: [
                    TextWidget(
                      text: '₱${totalEarned.toStringAsFixed(2)}',
                      fontSize: 64,
                      fontFamily: 'Bold',
                      color: secondary,
                    ),
                  ],
                );
              },
            ),
            TextWidget(
              text: 'total earned',
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
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Orders')
                        .where('merchantId', isEqualTo: merchantId)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Text('Something went wrong'));
                      }

                      final orders = snapshot.data!.docs;
                      double calculatedTotalPrice = 0.0;
                      for (var doc in orders) {
                        final data = doc.data() as Map<String, dynamic>?;
                        if (data != null &&
                            data.containsKey('items') &&
                            data['items'] is List) {
                          for (var item in data['items']) {
                            if (item.containsKey('price')) {
                              calculatedTotalPrice += item['price'];
                            }
                          }
                        }
                      }

                      orderCount = orders.length;
                      totalEarned = calculatedTotalPrice;

                      return Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextWidget(
                              text: orderCount == 1
                                  ? '1 order'
                                  : '$orderCount orders',
                              fontSize: 40,
                              fontFamily: 'Bold',
                              color: Colors.white,
                            ),
                            Row(
                              children: [
                                TextWidget(
                                  text: 'Filter by',
                                  fontSize: 17,
                                  fontFamily: 'Bold',
                                  color: white,
                                ),
                                PopupMenuButton<String>(
                                  onSelected: (String value) {
                                    setState(() {
                                      selectedStatus = value;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: white,
                                  ),
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      PopupMenuItem(
                                        value: 'Pending',
                                        child: TextWidget(
                                          text: 'Pending',
                                          fontSize: 18,
                                          color: primary,
                                          fontFamily: 'Regular',
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'Preparing',
                                        child: TextWidget(
                                          text: 'Preparing',
                                          fontSize: 18,
                                          color: primary,
                                          fontFamily: 'Regular',
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'For Pick-up',
                                        child: TextWidget(
                                          text: 'For Pick-up',
                                          fontSize: 18,
                                          color: primary,
                                          fontFamily: 'Regular',
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'On the way',
                                        child: TextWidget(
                                          text: 'On the way',
                                          fontSize: 18,
                                          color: primary,
                                          fontFamily: 'Regular',
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'Delivered',
                                        child: TextWidget(
                                          text: 'Delivered',
                                          fontSize: 18,
                                          color: primary,
                                          fontFamily: 'Regular',
                                        ),
                                      ),
                                    ];
                                  },
                                ),
                              ],
                            )
                            // Column(
                            //   crossAxisAlignment: CrossAxisAlignment.center,
                            //   children: [
                            //     TextWidget(
                            //       text: '15.2%',
                            //       fontSize: 24,
                            //       fontFamily: 'Regular',
                            //       color: Colors.white,
                            //     ),
                            //     TextWidget(
                            //       text: 'higher than last week',
                            //       fontSize: 8,
                            //       fontFamily: 'Regular',
                            //       color: Colors.white,
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height,
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
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextWidget(
                                  text: 'Transactions',
                                  fontSize: 40,
                                  fontFamily: 'Bold',
                                  color: secondary,
                                ),
                              ],
                            ),
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('Orders')
                                .where('merchantId', isEqualTo: merchantId)
                                .where('status', isEqualTo: selectedStatus)
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(child: Text('Loading'));
                              } else if (snapshot.hasError) {
                                return const Center(
                                    child: Text('Something went wrong'));
                              } else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              final orders = snapshot.data!.docs;

                              if (orders.isEmpty) {
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

                              return Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: orders.map((order) {
                                      final data =
                                          order.data() as Map<String, dynamic>?;

                                      final price = data != null &&
                                              data.containsKey('items') &&
                                              data['items'] is List &&
                                              data['items'].isNotEmpty
                                          ? data['items'][0]['price']
                                          : 'N/A';
                                      final tip = data != null &&
                                              data.containsKey('tip')
                                          ? data['tip']
                                          : 'N/A';
                                      final status = data != null &&
                                              data.containsKey('status')
                                          ? data['status']
                                          : 'Unknown';
                                      final completedAt = data != null &&
                                              data.containsKey('date')
                                          ? data['date']
                                          : null;

                                      final formattedDate =
                                          (completedAt != null &&
                                                  completedAt is Timestamp)
                                              ? DateFormat(
                                                      'MMMM d, y \'at\' h:mm a')
                                                  .format(completedAt.toDate())
                                              : 'N/A';

                                      final items =
                                          data?['items'] as List<dynamic>?;

                                      final groupedItems =
                                          <String, Map<String, dynamic>>{};
                                      if (items != null && items.isNotEmpty) {
                                        for (var item in items) {
                                          final itemName =
                                              item['name'] ?? 'Unnamed Item';
                                          final quantity =
                                              item['quantity'] ?? 1;
                                          final itemPrice = item['price'] ?? 0;

                                          if (groupedItems
                                              .containsKey(itemName)) {
                                            groupedItems[itemName]![
                                                'quantity'] += quantity;
                                          } else {
                                            groupedItems[itemName] = {
                                              'quantity': quantity,
                                              'price': itemPrice,
                                            };
                                          }
                                        }
                                      }

                                      double grandTotal = groupedItems.entries
                                          .fold(0, (sum, entry) {
                                        final quantity =
                                            entry.value['quantity'];
                                        final itemPrice = entry.value['price'];
                                        return sum + (quantity * itemPrice);
                                      });

                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Center(
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 07),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.15,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                1,
                                            decoration: BoxDecoration(
                                              border:
                                                  Border.all(color: secondary),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      TextWidget(
                                                        text: price != 'N/A'
                                                            ? 'Total: ₱${grandTotal.toStringAsFixed(2)}'
                                                            : 'Price unavailable',
                                                        fontSize: 19,
                                                        fontFamily: 'Bold',
                                                        color: secondary,
                                                      ),
                                                      TextWidget(
                                                        text:
                                                            'Order ID: ${order.id}',
                                                        fontSize: 14,
                                                        fontFamily: 'Bold',
                                                        color: secondary,
                                                      ),
                                                      TextWidget(
                                                        text: status ==
                                                                'Completed'
                                                            ? 'Completed on $formattedDate'
                                                            : 'Ordered on $formattedDate',
                                                        fontSize: 14,
                                                        fontFamily: 'Medium',
                                                        color: secondary,
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      TextWidget(
                                                        text: status,
                                                        fontSize: 15,
                                                        fontFamily: 'Bold',
                                                        color: status ==
                                                                'Completed'
                                                            ? Colors.green
                                                            : status ==
                                                                    'Pending'
                                                                ? Colors.red
                                                                : status ==
                                                                        'Preparing'
                                                                    ? Colors
                                                                        .orange
                                                                    : status ==
                                                                            'For Pick-up'
                                                                        ? Colors.yellow[
                                                                            800]
                                                                        : status ==
                                                                                'On the way'
                                                                            ? secondary
                                                                            : Colors.black,
                                                      ),
                                                      const SizedBox(height: 5),
                                                      TextWidget(
                                                        text: 'View List',
                                                        fontSize: 14,
                                                        fontFamily: 'Bold',
                                                        color: secondary,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          showDialog(
                                                            barrierDismissible:
                                                                true,
                                                            context: context,
                                                            builder: (context) {
                                                              final items = data?[
                                                                      'items']
                                                                  as List<
                                                                      dynamic>?;

                                                              // Group items by name
                                                              final groupedItems =
                                                                  <String,
                                                                      Map<String,
                                                                          dynamic>>{};
                                                              if (items !=
                                                                      null &&
                                                                  items
                                                                      .isNotEmpty) {
                                                                for (var item
                                                                    in items) {
                                                                  final itemName =
                                                                      item['name'] ??
                                                                          'Unnamed Item';
                                                                  final quantity =
                                                                      item['quantity'] ??
                                                                          1;
                                                                  final itemPrice =
                                                                      item['price'] ??
                                                                          0;

                                                                  if (groupedItems
                                                                      .containsKey(
                                                                          itemName)) {
                                                                    groupedItems[itemName]![
                                                                            'quantity'] +=
                                                                        quantity;
                                                                  } else {
                                                                    groupedItems[
                                                                        itemName] = {
                                                                      'quantity':
                                                                          quantity,
                                                                      'price':
                                                                          itemPrice,
                                                                    };
                                                                  }
                                                                }
                                                              }
                                                              double
                                                                  grandTotal =
                                                                  groupedItems
                                                                      .entries
                                                                      .fold(0, (sum,
                                                                          entry) {
                                                                final quantity =
                                                                    entry.value[
                                                                        'quantity'];
                                                                final itemPrice =
                                                                    entry.value[
                                                                        'price'];
                                                                return sum +
                                                                    (quantity *
                                                                        itemPrice);
                                                              });

                                                              return AlertDialog(
                                                                title:
                                                                    TextWidget(
                                                                  text:
                                                                      "Order Details",
                                                                  fontSize: 22,
                                                                  color:
                                                                      secondary,
                                                                  fontFamily:
                                                                      "Bold",
                                                                ),
                                                                content: groupedItems
                                                                        .isNotEmpty
                                                                    ? SizedBox(
                                                                        width: double
                                                                            .maxFinite,
                                                                        child:
                                                                            ListView(
                                                                          shrinkWrap:
                                                                              true,
                                                                          children: groupedItems
                                                                              .entries
                                                                              .map((entry) {
                                                                            final itemName =
                                                                                entry.key;
                                                                            final quantity =
                                                                                entry.value['quantity'];
                                                                            final itemPrice =
                                                                                entry.value['price'];

                                                                            return Column(
                                                                              children: [
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    TextWidget(
                                                                                      text: 'x$quantity $itemName ',
                                                                                      fontSize: 18,
                                                                                      color: secondary,
                                                                                      fontFamily: "Bold",
                                                                                    ),
                                                                                    TextWidget(
                                                                                      text: '₱${(itemPrice * quantity).toStringAsFixed(2)}',
                                                                                      fontSize: 18,
                                                                                      color: secondary,
                                                                                      fontFamily: "Bold",
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                const Divider(
                                                                                  color: secondary,
                                                                                  thickness: .5,
                                                                                ),
                                                                              ],
                                                                            );
                                                                          }).toList(),
                                                                        ),
                                                                      )
                                                                    : TextWidget(
                                                                        text:
                                                                            "No items available.",
                                                                        fontSize:
                                                                            16,
                                                                        color:
                                                                            secondary,
                                                                        fontFamily:
                                                                            "Regular",
                                                                      ),
                                                                actions: [
                                                                  Column(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          TextWidget(
                                                                            text:
                                                                                'Total: ₱${grandTotal.toStringAsFixed(2)}',
                                                                            fontSize:
                                                                                18,
                                                                            color:
                                                                                secondary,
                                                                            fontFamily:
                                                                                'Bold',
                                                                          ),
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              FirebaseFirestore.instance.collection('Orders').doc(order.id).update({
                                                                                'status': status == 'Pending'
                                                                                    ? 'Preparing'
                                                                                    : status == 'Preparing'
                                                                                        ? 'For Pick-up'
                                                                                        : status == 'For Pick-up'
                                                                                            ? 'On the way'
                                                                                            : 'Pending',
                                                                              });
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              width: 140,
                                                                              padding: const EdgeInsets.all(10),
                                                                              decoration: BoxDecoration(
                                                                                color: secondary,
                                                                                borderRadius: BorderRadius.circular(20),
                                                                              ),
                                                                              child: TextWidget(
                                                                                text: status == 'Pending'
                                                                                    ? 'Prepare Food'
                                                                                    : status == 'Preparing'
                                                                                        ? 'Ready to Pick Up'
                                                                                        : status == 'For Pick-up'
                                                                                            ? 'Picked Up'
                                                                                            : status == 'On the way'
                                                                                                ? 'Close'
                                                                                                : 'Close',
                                                                                fontSize: 18,
                                                                                color: white,
                                                                                fontFamily: "Bold",
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              10),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          TextWidget(
                                                                            text:
                                                                                'Payment Method: ${data?['mop'] ?? 'N/A'}',
                                                                            fontSize:
                                                                                18,
                                                                            color:
                                                                                secondary,
                                                                            fontFamily:
                                                                                'Bold',
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child: const Icon(
                                                          Icons.receipt,
                                                          color: secondary,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  )
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
                  const SizedBox(height: 20),
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
}
