import 'package:driver/assets/AppColors.dart';
import 'package:driver/assets/Assets.dart';
import 'package:driver/model/JobModel.dart';
import 'package:driver/widget/StsImgView.dart';
import 'package:fdottedline/fdottedline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ConfirmBottomSheet {
  Widget show(BuildContext context, JobModel model){
    return Container(
        height: MediaQuery.of(context).size.height * 0.85,
        margin: EdgeInsets.only(left: 15, right: 15),
        width: double.infinity,
        child: SingleChildScrollView(
            child: Column(
                children: [
                  Stack(
                      children: [
                        Container(
                          height: 130,
                          margin: EdgeInsets.only(top: 35),
                          padding: EdgeInsets.only(top: 40), width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(3), topRight: Radius.circular(3)),
                            color: AppColors.green,),
                        ),
                        Align(
                            alignment: Alignment.topCenter,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(width: 20),
                                    Column(
                                      children: [
                                        ClipOval(child: StsImgView(image: Assets.NELSON_IMG, width: 70, height: 70)),
                                        SizedBox(height: 10),
                                        Text('Nelson Buldier', style: TextStyle(color: Colors.white, fontSize: 16)),
                                        Row(
                                          children: [
                                            Text('4.9', style: TextStyle(color: Colors.white)),
                                            RatingBar.builder(ignoreGestures: true, initialRating: 4, minRating: 1, allowHalfRating: true, itemCount: 5, itemSize: 20,
                                                itemPadding: EdgeInsets.symmetric(horizontal: 1),
                                                itemBuilder: (context, _) => Icon(Icons.star, color: Colors.white),
                                                onRatingUpdate: (rating) {}),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Column(
                                      children: [
                                        ClipOval(child: StsImgView(image: Assets.NELSON_IMG, width: 70, height: 70)),
                                        SizedBox(height: 10),
                                        Text('Nelson Buldier', style: TextStyle(color: Colors.white, fontSize: 16)),
                                        Row(
                                          children: [
                                            Text('4.9', style: TextStyle(color: Colors.white)),
                                            RatingBar.builder(ignoreGestures: true, initialRating: 4, minRating: 1, allowHalfRating: true, itemCount: 5, itemSize: 20,
                                                itemPadding: EdgeInsets.symmetric(horizontal: 1),
                                                itemBuilder: (context, _) => Icon(Icons.star, color: Colors.white),
                                                onRatingUpdate: (rating) {}),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 20),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Load ID', style: TextStyle(fontSize: 16,  color: Colors.white)),
                                    SizedBox(width: 10),
                                    Text('PB262NJ', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500)),
                                  ],
                                )
                              ],
                            )
                        )
                      ]
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: Assets.TWO_HANDS_IGM, height: 90),
                        SizedBox(height: 15),
                        Text('Note: offert cannot be change after', style: TextStyle(color: Colors.black45),),
                        SizedBox(height: 10),
                        Stack(
                            children: [
                              Container(margin: EdgeInsets.only(top: 0.5), color: Colors.black12, width: double.infinity, height: 2),
                              Container(color: AppColors.green, width: 30, height: 3)]),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            SizedBox(width: 5),
                            Column(
                                children: [
                                  SizedBox(height: 12),
                                  Container(width: 12, height: 12,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(6)), color: AppColors.darkBlue)),
                                  Container(margin: EdgeInsets.only(left: 1, top: 1.5),
                                      child: FDottedLine(
                                          color: Colors.black38,
                                          height: 35,
                                          strokeWidth: 2,
                                          dottedLength: 5,
                                          space: 2)),
                                  Container(width: 12, height: 12,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6)),
                                          color: AppColors.green))
                                ]),
                            SizedBox(width: 20),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10),
                                  Text('[NJ] Red Hook New Jersey', style: TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.bold)),
                                  SizedBox(height: 15),
                                  Container(width: MediaQuery.of(context).size.width - 120, height: 1, color: Colors.black12),
                                  SizedBox(height: 15),
                                  Text('6701 Tonnelle Avenue, North Bergen NJm USA', style: TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.bold), maxLines: 1)
                                ]),
                            SizedBox(width: 10)],
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                            child: Text('DETAILS', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                        Stack(
                            children: [
                              Container(margin: EdgeInsets.only(top: 0.5), color: Colors.black12, width: double.infinity, height: 2),
                              Container(color: AppColors.green, width: 80, height: 3)]),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('CONTAINER:', style: TextStyle(color: Colors.black54)),
                            SizedBox(width: 5),
                            Text('40HC', style: TextStyle(color: AppColors.darkBlue)),
                            SizedBox(width: 5),
                            Text('/', style: TextStyle(color: Colors.black87)),
                            SizedBox(width: 5),
                            Text('GROSS WEIGHT:', style: TextStyle(color: Colors.black54)),
                            SizedBox(width: 5),
                            Text('30K', style: TextStyle(color: AppColors.darkBlue)),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('DISTANCE:', style: TextStyle(color: Colors.black54)),
                            SizedBox(width: 5),
                            Text('236.7 MI', style: TextStyle(color: AppColors.darkBlue)),
                            SizedBox(width: 5),
                            Text('/', style: TextStyle(color: Colors.black87)),
                            SizedBox(width: 5),
                            Text('TIME:', style: TextStyle(color: Colors.black54)),
                            SizedBox(width: 5),
                            Text('5H 55 MIN', style: TextStyle(color: AppColors.darkBlue)),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('PUP DATE:', style: TextStyle(color: Colors.black54)),
                            SizedBox(width: 5),
                            Text('04/15/2020', style: TextStyle(color: AppColors.darkBlue)),
                            SizedBox(width: 5),
                            Text('/', style: TextStyle(color: Colors.black87)),
                            SizedBox(width: 5),
                            Text('DOFF DATE:', style: TextStyle(color: Colors.black54)),
                            SizedBox(width: 5),
                            Text('04/16/2020', style: TextStyle(color: AppColors.darkBlue)),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('PICKUP TIME:', style: TextStyle(color: Colors.black54)),
                            SizedBox(width: 5),
                            Text('11:00 AM', style: TextStyle(color: AppColors.darkBlue)),
                            SizedBox(width: 5),
                            Text('/', style: TextStyle(color: Colors.black87)),
                            SizedBox(width: 5),
                            Text('DROPOFF TIME:', style: TextStyle(color: Colors.black54)),
                            SizedBox(width: 5),
                            Text('05:00 PM', style: TextStyle(color: AppColors.darkBlue)),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('FUEL GALLONS:', style: TextStyle(color: Colors.black54)),
                            SizedBox(width: 5),
                            Text('73.97', style: TextStyle(color: AppColors.darkBlue)),
                            SizedBox(width: 5),
                            Text('/', style: TextStyle(color: Colors.black87)),
                            SizedBox(width: 5),
                            Text('TOLLS ROADS:', style: TextStyle(color: Colors.black54)),
                            SizedBox(width: 5),
                            Text('\$175.83', style: TextStyle(color: AppColors.darkBlue)),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.monetization_on, size: 30, color: AppColors.darkBlue),
                            SizedBox(width: 10),
                            Text('Estimate Price', style: TextStyle(fontSize: 17, color: Colors.black54)),
                            Spacer(),
                            Text('\$1348.21', style: TextStyle(color: AppColors.darkBlue, fontSize: 25, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        SizedBox(height: 10),
                        Stack(
                            children: [
                              Container(margin: EdgeInsets.only(top: 0.5), color: Colors.black12, width: double.infinity, height: 2),
                              Container(color: AppColors.green, width: 80, height: 3)]),
                        SizedBox(height: 10),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  width: (MediaQuery.of(context).size.width - 50) / 2 - 20,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(primary: AppColors.darkBlue),
                                    onPressed: () {

                                    },
                                    child: Text('DECLINE'),
                                  )
                              ),
                              Container(
                                  width: (MediaQuery
                                      .of(context)
                                      .size
                                      .width - 50) / 2 - 20,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: AppColors.green),
                                    onPressed: () {
                                      Navigator.pop(context, true);
                                    },
                                    child: Text('ACCEPT'),
                                  ))]),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ]
            )
        )
    );
  }
}