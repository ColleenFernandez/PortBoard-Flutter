import 'package:driver/assets/AppColors.dart';
import 'package:flutter/material.dart';

class SelectColorPage extends StatefulWidget {
  @override
  State<SelectColorPage> createState() => _SelectColorPageState();
}

class _SelectColorPageState extends State<SelectColorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        elevation: 1,
        title: Text('Select Color'),
      ),
    );
  }
}