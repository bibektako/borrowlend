import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class SliderScreen extends StatelessWidget {
  SliderScreen({super.key});

  final List<Map<String, dynamic>> imageList = [
    {"id": 1, "image_path": 'assets/image/slider1.png'},
    // Add more images as needed
  ];

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items:
          imageList.map((item) {
            return Image.asset(
              item['image_path'],
              fit: BoxFit.fill,
              width: double.infinity,
            );
          }).toList(),
      options: CarouselOptions(
        height: 163.0,

        autoPlay: true,
        enlargeCenterPage: false,
        viewportFraction: 1,
        aspectRatio: 16 / 9,
        autoPlayInterval: const Duration(seconds: 30),
      ),
    );
  }
}
