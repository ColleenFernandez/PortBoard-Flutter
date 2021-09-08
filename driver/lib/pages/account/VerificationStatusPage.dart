import 'package:driver/adapter/VerificationAdapter.dart';
import 'package:driver/assets/AppColors.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/model/VerificationModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VerificationStatusPage extends StatefulWidget {
  @override
  _VerificationStatusPageState createState() => _VerificationStatusPageState();
}

class _VerificationStatusPageState extends State<VerificationStatusPage> {

  List<VerificationModel> allData = [];

  @override
  void initState() {
    super.initState();
    getVerificationData();
  }

  void getVerificationData(){
    VerificationModel model1 = new VerificationModel();
    model1.status = Constants.NOT_SUBMITTED;
    model1.documentName = 'Driver License';
    model1.expireDate = 0;
    model1.reason = '';

    VerificationModel model2 = new VerificationModel();
    model2.status = Constants.REJECTED;
    model2.documentName = 'Twic Card';
    model2.expireDate = 0;
    model2.reason = 'Twic card picture is not clear, Please take out picture with high quality, and submit again.';

    VerificationModel model3 = new VerificationModel();
    model3.status = Constants.NOT_SUBMITTED;
    model3.documentName = 'Sealink Card';
    model3.expireDate = 0;
    model3.reason = '';

    allData.add(model1); allData.add(model2); allData.add(model3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: AppColors.darkBlue,
          title: Text('Verification Status', style: TextStyle(color: Colors.white, fontSize: 16)),
          elevation: 2,
          iconTheme: IconThemeData(color: Colors.white)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Note', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 15)),
                  SizedBox(width: 10),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('To prevent inconvenients, make sure your documents.', style: TextStyle(color: Colors.black54, fontSize: 13)),
                      Text('Are not blurry / are current (no expired)', style: TextStyle(color: Colors.black54, fontSize: 13)),
                      Text('Includes all four corners of the card.', style: TextStyle(color: Colors.black54, fontSize: 13))
                    ],
                  ))
                ],
              ),
            ),
            ListView.builder(
              itemCount: allData.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      VerificationModel model = allData[index];
                      if (model.status != Constants.APPROVED){
                        Navigator.pushNamed(context, '/SubmitDriverLicensePage');
                      }
                    }, child: VerificationAdapter().verificationItem(context, allData[index]));
                }
            )
          ],
        ),
      )
    );
  }
}