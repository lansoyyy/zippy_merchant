import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zippy/screens/auth/login_screen.dart';
import 'package:zippy/screens/tabs/edit_tab.dart';
import 'package:zippy/screens/tabs/shop_tab.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/widgets/button_widget.dart';
import 'package:zippy/widgets/text_widget.dart';
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
    if (merchantId == null) return;

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Orders')
          .where('merchantId', isEqualTo: merchantId)
          .get();

      double calculatedTotalPrice = calculateTotalPrice(querySnapshot.docs);

      setState(() {
        orderCount = querySnapshot.size;
        totalEarned = calculatedTotalPrice;
      });
    } catch (e) {
      print('Error fetching order count: $e');
    }
  }

  double calculateTotalPrice(List<QueryDocumentSnapshot> docs) {
    return docs.fold(0.0, (sum, doc) {
      final data = doc.data() as Map<String, dynamic>?;
      if (data != null &&
          data['status'] == 'Delivered' &&
          data.containsKey('items') &&
          data['items'] is List) {
        for (var item in data['items']) {
          if (item.containsKey('price')) {
            sum += item['price'];
          }
        }
      }
      return sum;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildDateRow(),
            _buildTotalEarned(),
            _buildOrderList(),
          ],
        ),
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
                    onPressed: _confirmLogout,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCravingOption(Icons.home, 'Home', true),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ShopTab(),
                      ),
                    );
                  },
                  child: _buildCravingOption(
                      Icons.store_mall_directory_outlined, 'Shop', false),
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditScreen(),
                        ),
                      );
                    },
                    child:
                        _buildCravingOption(Icons.edit_square, 'Edit', false)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(7, (index) {
        DateTime now = DateTime.now();
        DateTime date = now.subtract(Duration(days: now.weekday - 1 - index));
        bool isToday = date.day == now.day &&
            date.month == now.month &&
            date.year == now.year;
        return _buildDateContainer(date, isToday);
      }),
    );
  }

  Widget _buildDateContainer(DateTime date, bool isToday) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.12,
      height: MediaQuery.of(context).size.width * 0.2,
      decoration: BoxDecoration(
        color: isToday ? secondary : Colors.transparent,
        border: Border.all(color: secondary),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextWidget(
            text: DateFormat('MMM').format(date),
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
  }

  Widget _buildTotalEarned() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Orders')
          .where('merchantId', isEqualTo: merchantId)
          .where('status', isEqualTo: 'Delivered')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        final orders = snapshot.data!.docs;

        if (orders.isEmpty) {
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
                  text: 'Order Empty',
                  fontSize: 20,
                  fontFamily: 'Bold',
                  color: secondary,
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            TextWidget(
              text: '₱${totalEarned.toStringAsFixed(2)}',
              fontSize: 64,
              fontFamily: 'Bold',
              color: secondary,
            ),
            TextWidget(
              text: 'total earned',
              fontSize: 18,
              fontFamily: 'Medium',
              color: secondary,
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Widget _buildOrderList() {
    return Container(
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
          _buildOrderHeader(),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: _buildOrderStream(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextWidget(
            text: orderCount == 1 ? '1 order' : '$orderCount orders',
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
              _buildStatusFilter(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilter() {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        setState(() {
          selectedStatus = value;
        });
      },
      icon: Icon(Icons.arrow_drop_down, color: white),
      itemBuilder: (BuildContext context) {
        return [
          'Pending',
          'Preparing',
          'For Pick-up',
          'On the way',
          'Delivered'
        ]
            .map((status) => PopupMenuItem(
                  value: status,
                  child: TextWidget(
                    text: status,
                    fontSize: 18,
                    color: primary,
                    fontFamily: 'Regular',
                  ),
                ))
            .toList();
      },
    );
  }

  Widget _buildOrderStream() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Orders')
          .where('merchantId', isEqualTo: merchantId)
          .where('status', isEqualTo: selectedStatus)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        final orders = snapshot.data!.docs;

        if (orders.isEmpty) {
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

        return ListView(
          children: orders.map((order) => _buildOrderItem(order)).toList(),
        );
      },
    );
  }

  Widget _buildOrderItem(QueryDocumentSnapshot order) {
    final data = order.data() as Map<String, dynamic>?;
    final status = data?['status'] ?? 'Unknown';
    final completedAt = data?['date'] as Timestamp?;
    final formattedDate = completedAt != null
        ? DateFormat('MMMM d, y \'at\' h:mm a').format(completedAt.toDate())
        : 'N/A';

    final items = data?['items'] as List<dynamic>?;
    final groupedItems = _groupItems(items);
    final grandTotal = _calculateGrandTotal(groupedItems);

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 7),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
        height: MediaQuery.of(context).size.height * 0.1,
        decoration: BoxDecoration(
          border: Border.all(color: secondary),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextWidget(
                    text: 'Total: ₱${grandTotal.toStringAsFixed(2)}',
                    fontSize: 20,
                    fontFamily: 'Bold',
                    color: secondary,
                  ),
                  TextWidget(
                    text: 'Order ID: ${order.id}',
                    fontSize: 10,
                    fontFamily: 'Bold',
                    color: secondary,
                  ),
                  TextWidget(
                    text: status == 'Completed'
                        ? 'Completed on $formattedDate'
                        : 'Ordered on $formattedDate',
                    fontSize: 10,
                    fontFamily: 'Medium',
                    color: secondary,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextWidget(
                    text: status,
                    fontSize: 15,
                    fontFamily: 'Bold',
                    color: _getStatusColor(status),
                  ),
                  const SizedBox(height: 5),
                  TextWidget(
                    text: 'View List',
                    fontSize: 12,
                    fontFamily: 'Bold',
                    color: secondary,
                  ),
                  GestureDetector(
                    onTap: () => _showOrderDetails(
                        context, order, status, groupedItems, grandTotal),
                    child: const Icon(Icons.receipt, color: secondary),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'Pending':
        return Colors.red;
      case 'Preparing':
        return Colors.orange;
      case 'For Pick-up':
        return Colors.yellow[800]!;
      case 'On the way':
        return secondary;
      default:
        return Colors.black;
    }
  }

  void _showOrderDetails(
      BuildContext context,
      QueryDocumentSnapshot order,
      String status,
      Map<String, Map<String, dynamic>> groupedItems,
      double grandTotal) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: TextWidget(
            text: "Order Details",
            fontSize: 22,
            color: secondary,
            fontFamily: "Bold",
          ),
          content: groupedItems.isNotEmpty
              ? SizedBox(
                  width: double.maxFinite,
                  child: ListView(
                    shrinkWrap: true,
                    children: groupedItems.entries.map((entry) {
                      final itemName = entry.key;
                      final quantity = entry.value['quantity'];
                      final itemPrice = entry.value['price'];

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
                                text:
                                    '₱${(itemPrice * quantity).toStringAsFixed(2)}',
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
                  text: "No items available.",
                  fontSize: 16,
                  color: secondary,
                  fontFamily: "Regular",
                ),
          actions: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      text: 'Total: ₱${grandTotal.toStringAsFixed(2)}',
                      fontSize: 18,
                      color: secondary,
                      fontFamily: 'Bold',
                    ),
                    GestureDetector(
                      onTap: () {
                        FirebaseFirestore.instance
                            .collection('Orders')
                            .doc(order.id)
                            .update({
                          'status': status == 'Pending'
                              ? 'Preparing'
                              : status == 'Preparing'
                                  ? 'For Pick-up'
                                  : status == 'For Pick-up'
                                      ? 'On the way'
                                      : 'On the way',
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: secondary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextWidget(
                          text: status == 'Pending'
                              ? 'Prepare Food'
                              : status == 'Preparing'
                                  ? 'Ready for Pick-up'
                                  : status == 'For Pick-up'
                                      ? 'Picked Up'
                                      : status == 'On the way'
                                          ? 'Close'
                                          : 'Close',
                          fontSize: 14,
                          color: white,
                          fontFamily: "Bold",
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      text: 'Payment Method: ${order['mop'] ?? 'N/A'}',
                      fontSize: 18,
                      color: secondary,
                      fontFamily: 'Bold',
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Map<String, Map<String, dynamic>> _groupItems(List<dynamic>? items) {
    final groupedItems = <String, Map<String, dynamic>>{};
    if (items != null && items.isNotEmpty) {
      for (var item in items) {
        final itemName = item['name'] ?? 'Unnamed Item';
        final quantity = item['quantity'] ?? 1;
        final itemPrice = item['price'] ?? 0;

        if (groupedItems.containsKey(itemName)) {
          groupedItems[itemName]!['quantity'] += quantity;
        } else {
          groupedItems[itemName] = {
            'quantity': quantity,
            'price': itemPrice,
          };
        }
      }
    }
    return groupedItems;
  }

  double _calculateGrandTotal(Map<String, Map<String, dynamic>> groupedItems) {
    return groupedItems.entries.fold(0, (sum, entry) {
      final quantity = entry.value['quantity'];
      final itemPrice = entry.value['price'];
      return sum + (quantity * itemPrice);
    });
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

  void _confirmLogout() {
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
}
