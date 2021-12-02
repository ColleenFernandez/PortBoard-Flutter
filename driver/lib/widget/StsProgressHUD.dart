import 'package:driver/assets/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

Widget StsProgressHUD(BuildContext context, Widget _widget ,  bool loading){
  return ModalProgressHUD(
    progressIndicator: Container(
      width: 80, height: 80, padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.white),
      child: CircularProgressIndicator(color: AppColors.darkBlue,),
    ),
    inAsyncCall: loading,
    child: _widget,);
}