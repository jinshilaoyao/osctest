import 'package:flutter/material.dart';

class SlideViewIndicator extends StatefulWidget {

  @override
  SlideViewIndicatorState createState() => SlideViewIndicatorState();
}

class SlideViewIndicatorState extends State<SlideViewIndicator> {

  final double dotWidth = 8.0;
  int selectedIndex = 0;

    setSelectedIndex(int index) {
    setState(() {
      this.selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}