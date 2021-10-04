import 'dart:ui';

import 'package:driver/assets/AppColors.dart';
import 'package:driver/assets/Assets.dart';
import 'package:driver/widget/StsImgView.dart';
import 'package:fdottedline/fdottedline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CompleteService {
  Widget show(BuildContext context){
    return Container(
        height: MediaQuery.of(context).size.height * 0.83,
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
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Stack(
                            children: [
                              Container(margin: EdgeInsets.only(top: 0.5), color: Colors.black12, width: double.infinity, height: 2),
                              Container(color: AppColors.green, width: 30, height: 3)]),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Column(
                                children: [
                                  SizedBox(height: 12),
                                  Container(width: 12, height: 12,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(6)), color: AppColors.darkBlue)),
                                  Container(margin: EdgeInsets.only(left: 1, top: 1.5),
                                      child: FDottedLine(
                                          color: Colors.black38,
                                          height: 42,
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
                                  SizedBox(height: 20),
                                  Container(width: MediaQuery.of(context).size.width - 90, height: 1, color: Colors.black12),
                                  SizedBox(height: 20),
                                  Text('6701 Tonnelle Avenue, North Bergen NJm USA', style: TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.bold), maxLines: 1)
                                ]),
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: AppColors.grey_10,
                          margin: EdgeInsets.only(top: 5, bottom: 5),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.sort_outlined, size: 15),
                            SizedBox(width: 15),
                            Text('ID Number:'),
                            Spacer(),
                            Text('PB262NJ', style: TextStyle(color: AppColors.darkBlue, fontSize: 20, fontWeight: FontWeight.bold))
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.train_outlined, size: 15),
                            SizedBox(width: 15),
                            Text('Port Terminal:'),
                            Spacer(),
                            Text('Maher Terminal', style: TextStyle(color: AppColors.darkBlue))
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Image(image: Assets.IC_BAR_CODE, width: 15),
                            SizedBox(width: 15),
                            Text('Container Number:'),
                            Spacer(),
                            Text('EGSU 9163140', style: TextStyle(color: AppColors.darkBlue))
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Image(image: Assets.IC_BAR_CODE, width: 15),
                            SizedBox(width: 15),
                            Text('Chasis Number:'),
                            Spacer(),
                            Text('CHZZ 4057377', style: TextStyle(color: AppColors.darkBlue))
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Image(image: Assets.IC_BAR_CODE, width: 15),
                            SizedBox(width: 15),
                            Text('Container Type:'),
                            Spacer(),
                            Text('40 HC', style: TextStyle(color: AppColors.darkBlue))
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.train_outlined, size: 15),
                            SizedBox(width: 15),
                            Text('Steamship Line:'),
                            Spacer(),
                            Text('Evergreen', style: TextStyle(color: AppColors.darkBlue))
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.train_outlined, size: 15),
                            SizedBox(width: 15),
                            Text('Port of loading:'),
                            Spacer(),
                            Text('Evergreen', style: TextStyle(color: AppColors.darkBlue))
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.insert_drive_file_outlined, size: 15),
                            SizedBox(width: 15),
                            Text('Bill of Lading:'),
                            Spacer(),
                            Text('012345678900', style: TextStyle(color: AppColors.darkBlue))
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.insert_drive_file_outlined, size: 15),
                            SizedBox(width: 15),
                            Text('Seal Number:'),
                            Spacer(),
                            Text('3458613', style: TextStyle(color: AppColors.darkBlue))
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.train_outlined, size: 15),
                            SizedBox(width: 15),
                            Text('Vessel Name:'),
                            Spacer(),
                            Text('GreenX', style: TextStyle(color: AppColors.darkBlue))
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.insert_drive_file_outlined, size: 15),
                            SizedBox(width: 15),
                            Text('Reference Number:'),
                            Spacer(),
                            Text('6789234924', style: TextStyle(color: AppColors.darkBlue))
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.schedule, size: 15),
                            SizedBox(width: 15),
                            Text('Gross Weight:'),
                            Spacer(),
                            Text('30K', style: TextStyle(color: AppColors.darkBlue))
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
                        SizedBox(height: 5),
                        Container(
                          margin: EdgeInsets.only(top: 10, bottom: 20),
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(primary: AppColors.darkBlue),
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: Text('Complete Container Service'),
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