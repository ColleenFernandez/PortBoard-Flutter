import 'package:driver/assets/AppColors.dart';
import 'package:flutter/material.dart';

class SelectMakePage extends StatefulWidget {
  @override
  State<SelectMakePage> createState() => _SelectMakePageState();
}

class _SelectMakePageState extends State<SelectMakePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        elevation: 1,
        title: Text('Select Make'),
      ),
    );
  }
}