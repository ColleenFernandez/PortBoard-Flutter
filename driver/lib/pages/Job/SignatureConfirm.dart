import 'package:driver/assets/AppColors.dart';
import 'package:driver/assets/Assets.dart';
import 'package:driver/utils/log_utils.dart';
import 'package:driver/widget/StsImgView.dart';
import 'package:fdottedline/fdottedline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:signature/signature.dart';

class SignatureConfirm {

  SignatureController signatureController = SignatureController(
    penStrokeWidth: 1,
    penColor: Colors.black,
    exportBackgroundColor: Colors.black,
    onDrawStart: () {},
    onDrawEnd: () {}
  );

  Widget show(BuildContext context){
    return Container(
        height: MediaQuery.of(context).size.height * 0.87,
        margin: EdgeInsets.only(left: 15, right: 15),
        width: double.infinity,
        child: SingleChildScrollView(
            child: Column(
                children: [
                  Stack(
                      children: [
                        Container(
                            margin: EdgeInsets.only(top: 40),
                            padding: EdgeInsets.only(top: 45), width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(3), topRight: Radius.circular(3)),
                              color: AppColors.green,),
                            child: Column(
                                children: [
                                  Text('Nelson Buldier', style: TextStyle(color: Colors.white)),
                                  RatingBar.builder(ignoreGestures: true, initialRating: 4, minRating: 1, allowHalfRating: true, itemCount: 5, itemSize: 20,
                                      itemPadding: EdgeInsets.symmetric(horizontal: 3),
                                      itemBuilder: (context, _) => Icon(Icons.star, color: Colors.white),
                                      onRatingUpdate: (rating) {}),
                                  SizedBox(height: 5)])),
                        Align(
                            alignment: Alignment.topCenter,
                            child: ClipOval(child: StsImgView(image: Assets.NELSON_IMG, width: 80, height: 80))
                        )
                      ]
                  ),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.sort, size: 20),
                            SizedBox(width: 15),
                            Text('ID Number:'),
                            Spacer(),
                            Text('PB262NJ', style: TextStyle(color: AppColors.darkBlue, fontSize: 20, fontWeight: FontWeight.bold))
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('DISTANCE:'),
                            Text('236.7 MI / ', style: TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.bold),),
                            Text('ESTIMATE TIME:'),
                            Text('5 H 55 MIN', style: TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('PUT DATE:'),
                            Text('04/15/2020 / ', style: TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.bold),),
                            Text('DOFF DATE:'),
                            Text('04/16/2020', style: TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('PICKUP TIME:'),
                            Text('11:00 AM / ', style: TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.bold),),
                            Text('DROPOFF TIME:'),
                            Text('05:00 PM', style: TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('FUEL GALLONS:'),
                            Text('73.97 / ', style: TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.bold),),
                            Text('TOLLS ROADS:'),
                            Text('\$175.83', style: TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.monetization_on, size: 30),
                            SizedBox(width: 15),
                            Text('Estimate price:', style: TextStyle(color: AppColors.darkBlue, fontSize: 18)),
                            Spacer(),
                            Text('\$1348.21', style: TextStyle(color: AppColors.darkBlue, fontSize: 20, fontWeight: FontWeight.bold))
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Receiver Name', style: TextStyle(color: AppColors.darkBlue)),
                                Container(
                                  decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
                                  height: 40, width: MediaQuery.of(context).size.width / 2 - 45,
                                  child: Row(
                                    children: [
                                      SizedBox(width: 5,),
                                      Icon(Icons.person, size: 20),
                                      SizedBox(width: 5,),
                                      Text('Nelson Buldier'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 30,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Receiver Phone', style: TextStyle(color: AppColors.darkBlue)),
                                Container(
                                  decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
                                  height: 40, width: MediaQuery.of(context).size.width / 2 - 45,
                                  child: Row(
                                    children: [
                                      SizedBox(width: 5,),
                                      Icon(Icons.phone_enabled, size: 20,),
                                      SizedBox(width: 5,),
                                      Text('718-902-0903'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text('Signature Receiver *'),
                        SizedBox(height: 5),
                        Stack(
                          children: [
                            Image(image: Assets.IMG_BG_FOCUS,),
                            Signature(
                              controller: signatureController,
                              height: 200,
                              backgroundColor: Colors.transparent,
                            ),
                            Positioned(
                              bottom: 0, right: 0,
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/SignaturePanel');
                                  },
                                  icon: Icon(Icons.zoom_out_map)),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, bottom: 10),
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(primary: AppColors.darkBlue),
                            onPressed: () {

                            },
                            child: Text('Signature Confirm'),
                          ),
                        )
                      ],
                    ),
                  ),
                ]
            )
        )
    );
  }
}
