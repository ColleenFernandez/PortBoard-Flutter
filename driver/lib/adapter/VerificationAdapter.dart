import 'package:driver/assets/AppColors.dart';
import 'package:driver/common/Common.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/model/VerificationModel.dart';
import 'package:driver/utils/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VerificationAdapter {

  Widget verificationItem(BuildContext context, VerificationModel model){

    final bottomColor;
    if (model.status == Constants.ACCEPT){
      bottomColor = AppColors.green;
    }else {
      bottomColor = AppColors.darkBlue;
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: AppColors.grey_10
        ),
        width: double.infinity,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(15),
              child: Row(
                children: [
                  Icon(Icons.insert_drive_file_outlined, color: Colors.black87),
                  SizedBox(width: 10),
                  Text(model.documentName),
                  Spacer(),
                  Visibility(
                    visible: model.status == Constants.ACCEPT,
                      child: Icon(Icons.check_circle, color: AppColors.green))
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
              decoration: BoxDecoration(
                color: bottomColor,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                      visible: model.status != Constants.REJECT,
                      child: Spacer()),
                  Visibility(
                    visible: model.status == Constants.REJECT,
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Reject Reason', style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
                          Text(model.reason, style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic))
                        ],
                      ),
                    ),
                  ),
                  Text(Utils.getStatus(model.status), style: TextStyle(color: model.status == Constants.NOT_SUBMITTED ? Colors.white : Colors.white))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}