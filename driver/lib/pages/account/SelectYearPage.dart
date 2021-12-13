import 'package:driver/assets/AppColors.dart';
import 'package:flutter/material.dart';

class SelectYearPage extends StatefulWidget {
  @override
  State<SelectYearPage> createState() => _SelectYearPageState();
}

class _SelectYearPageState extends State<SelectYearPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        elevation: 1,
        title: Text('Select Year'),
      ),
    );
  }
}