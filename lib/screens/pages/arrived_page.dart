import 'package:flutter/material.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/widgets/button_widget.dart';
import 'package:zippy/widgets/text_widget.dart';

class ArrivedPage extends StatelessWidget {
  const ArrivedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 75,
              ),
              TextWidget(
                text: 'Arrived at Destination',
                fontSize: 22,
                fontFamily: 'Bold',
                color: secondary,
              ),
              const SizedBox(
                height: 20,
              ),
              const CircleAvatar(
                minRadius: 75,
                maxRadius: 75,
              ),
              const SizedBox(
                height: 20,
              ),
              TextWidget(
                text: 'Submit a photo for verification',
                fontSize: 16,
                fontFamily: 'Regular',
              ),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 30, right: 30, bottom: 20),
                child: Divider(
                  color: secondary,
                ),
              ),
              Container(
                width: 300,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: secondary,
                  ),
                  borderRadius: BorderRadius.circular(
                    15,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: secondary),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextWidget(
                        text: 'Take a Photo',
                        fontSize: 16,
                        fontFamily: 'Regular',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                width: 300,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: secondary,
                  ),
                  borderRadius: BorderRadius.circular(
                    100,
                  ),
                ),
                child: Center(
                  child: TextWidget(
                    text: 'Retake Photo',
                    fontSize: 25,
                    fontFamily: 'Bold',
                    color: secondary,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 30, right: 30, bottom: 20),
                child: Divider(
                  color: secondary,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  itemButton(Icons.phone, 'Call Customer'),
                  itemButton(Icons.message, 'Open Chat'),
                  itemButton(Icons.warning, 'Report'),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              ButtonWidget(
                label: 'Order Received',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  itemButton(IconData icon, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 66,
          height: 66,
          decoration: BoxDecoration(
            color: secondary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 40,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        TextWidget(
          text: label,
          fontSize: 12,
          fontFamily: 'Regular',
        ),
      ],
    );
  }
}
