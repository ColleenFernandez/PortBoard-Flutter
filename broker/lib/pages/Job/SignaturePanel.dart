
import 'package:driver/assets/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class SignaturePanel extends StatefulWidget {
  @override
  State<SignaturePanel> createState() => _SignaturePanelState();
}

class _SignaturePanelState extends State<SignaturePanel> {

  SignatureController signatureController = SignatureController(
      penStrokeWidth: 1,
      penColor: Colors.black,
      exportBackgroundColor: Colors.black,
      onDrawStart: () {},
      onDrawEnd: () {}
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        title: Text('Signature'),
        elevation: 1,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Signature(
          controller: signatureController,
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}