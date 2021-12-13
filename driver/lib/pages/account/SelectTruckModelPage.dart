import 'package:driver/assets/AppColors.dart';
import 'package:flutter/material.dart';

class SelectTruckModelPage extends StatefulWidget {
  @override
  State<SelectTruckModelPage> createState() => _SelectTruckModelPageState();
}

class _SelectTruckModelPageState extends State<SelectTruckModelPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        elevation: 1,
        title: Text('Select Truck Model'),
      ),
    );
  }
}