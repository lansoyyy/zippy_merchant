import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zippy/screens/pages/arrived_page.dart';
import 'package:zippy/screens/pages/profile_page.dart';
import 'package:zippy/screens/tabs/history_tab.dart';
import 'package:zippy/screens/tabs/sales_tab.dart';

import 'package:zippy/utils/colors.dart';
import 'package:zippy/widgets/button_widget.dart';
import 'package:zippy/widgets/text_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Expanded(
            child: GoogleMap(
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              initialCameraPosition: HomeScreen._kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
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
                  padding: const EdgeInsets.only(top: 25, left: 15, right: 15),
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          text: 'Good day! Rider Robert',
                          fontSize: 22,
                          fontFamily: 'Bold',
                          color: Colors.white,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => const ProfilePage()),
                            );
                          },
                          child: const CircleAvatar(
                            maxRadius: 25,
                            minRadius: 25,
                            backgroundImage: AssetImage(
                              'assets/images/sample_avatar.png',
                            ),
                          ),
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
                          GestureDetector(
                              onTap: () {},
                              child: _buildCravingOption(
                                  Icons.home, 'Home', true)),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const SalesTab()),
                              );
                            },
                            child: _buildCravingOption(
                                Icons.add_chart_rounded, 'Sales', false),
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const HistoryScreen()),
                                );
                              },
                              child: _buildCravingOption(
                                  Icons.history, 'History', false)),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              height: 90,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                    20,
                  ),
                  topRight: Radius.circular(
                    20,
                  ),
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ButtonWidget(
                  color: secondary,
                  label: 'Search Bookings',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const ArrivedPage()),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
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
