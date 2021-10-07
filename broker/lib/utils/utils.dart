import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class Utils {

  static String getAgoFromNow(String createdAt){
    DateTime to = new DateTime.now();
    DateTime from  = DateTime.parse(createdAt);

    final diffDays = to.difference(from).inDays;

    if (diffDays > 30){
      return '${(diffDays % 30).toString()} months' ;
    }else if ( diffDays > 6){
      return '${(diffDays % 6).toString()} weeks' ;
    }

    if ( diffDays  == 0){
      return 'Today';
    }
    return '${(diffDays).toString()} days' ;
  }

  static getDate(int timeStamp){
    return DateFormat('MM/dd/yyyy').format(DateTime.fromMillisecondsSinceEpoch(timeStamp));
  }
}

void showToast(String msg){
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0
  );
}