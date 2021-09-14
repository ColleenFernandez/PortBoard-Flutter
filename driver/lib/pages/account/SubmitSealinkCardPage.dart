import 'package:driver/assets/AppColors.dart';
import 'package:flutter/material.dart';

class SubmitSealinkCardPage extends StatefulWidget {
  @override
  _SubmitSealinkCardPageState createState() => _SubmitSealinkCardPageState();
}

class _SubmitSealinkCardPageState extends State<SubmitSealinkCardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        title: Text('Submit sealink card'),
      ),
    );
  }
}