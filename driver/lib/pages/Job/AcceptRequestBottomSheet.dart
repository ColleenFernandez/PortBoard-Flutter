import 'package:driver/assets/AppColors.dart';
import 'package:driver/assets/Assets.dart';
import 'package:driver/model/JobModel.dart';
import 'package:driver/widget/StsImgView.dart';
import 'package:fdottedline/fdottedline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AcceptRequestBottomSheet{
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
                            margin: EdgeInsets.only(top: 35),
                            padding: EdgeInsets.only(top: 40), width: double.infinity,
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
                                  SizedBox(height: 5),
                                ]
                            )),
                        Align(
                            alignment: Alignment.topCenter,
                            child: ClipOval(child: StsImgView(image: Assets.NELSON_IMG, width: 70, height: 70))
                        )
                      ]
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 15),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                            children: [
                              Container(margin: EdgeInsets.only(top: 0.5), color: Colors.black12, width: double.infinity, height: 2),
                              Container(color: AppColors.green, width: 30, height: 3)]),
                        SizedBox(height: 5),
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
                                  Text('[NJ] Red Hook New Jersey', maxLines: 1 , style: TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.bold)),
                                  SizedBox(height: 15),
                                  Container(width: MediaQuery.of(context).size.width - 120, height: 1, color: Colors.black12),
                                  SizedBox(height: 15),
                                  Text('6701 Tonnelle Avenue, North Bergen NJm USA', maxLines: 1, style: TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.bold))
                                ]),
                            SizedBox(width: 10)],
                        ),
                        SizedBox(height: 10),
                        Text('DETAILS', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        Stack(
                            children: [
                              Container(margin: EdgeInsets.only(top: 0.5), color: Colors.black12, width: double.infinity, height: 2),
                              Container(color: AppColors.green, width: 70, height: 3)]),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Icon(Icons.pin_outlined, size: 15),
                            SizedBox(width: 15),
                            Text('ID Number:'),
                            Spacer(),
                            Text('PB262NJ', style: TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.bold, fontSize: 25))
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.tram_outlined, size: 15),
                            SizedBox(width: 15),
                            Text('Container Type:'),
                            Spacer(),
                            Text('40` HC', style: TextStyle(color: AppColors.darkBlue))
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.watch_later_outlined, size: 15),
                            SizedBox(width: 15),
                            Text('Gross Weight:'),
                            Spacer(),
                            Text('40` HC', style: TextStyle(color: AppColors.darkBlue))
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.event_note_outlined, size: 15),
                            SizedBox(width: 15),
                            Text('Pickup Date:'),
                            Spacer(),
                            Text('40` HC', style: TextStyle(color: AppColors.darkBlue))
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.watch_later_outlined, size: 15),
                            SizedBox(width: 15),
                            Text('Pickup Time:'),
                            Spacer(),
                            Text('40` HC', style: TextStyle(color: AppColors.darkBlue))
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.event_note_outlined, size: 15),
                            SizedBox(width: 15),
                            Text('Dropoff Date:'),
                            Spacer(),
                            Text('40` HC', style: TextStyle(color: AppColors.darkBlue))
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.place_outlined, size: 15),
                            SizedBox(width: 15),
                            Text('Distance:'),
                            Spacer(),
                            Text('40` HC', style: TextStyle(color: AppColors.darkBlue))
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.watch_later_outlined, size: 15),
                            SizedBox(width: 15),
                            Text('Estimated time:'),
                            Spacer(),
                            Text('40` HC', style: TextStyle(color: AppColors.darkBlue))
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.local_fire_department_outlined, size: 15),
                            SizedBox(width: 15),
                            Text('Fuel Gallons:'),
                            Spacer(),
                            Text('40` HC', style: TextStyle(color: AppColors.darkBlue))
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.handyman_outlined, size: 15),
                            SizedBox(width: 15),
                            Text('Tolls roads:'),
                            Spacer(),
                            Text('40` HC', style: TextStyle(color: AppColors.darkBlue))
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.monetization_on_outlined, size: 15),
                            SizedBox(width: 15),
                            Text('Estimate Price:'),
                            Spacer(),
                            Text('\$1,348.21', style: TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.bold, fontSize: 25))
                          ],
                        ),
                        SizedBox(height: 10,),
                        Stack(
                            children: [
                              Container(margin: EdgeInsets.only(top: 0.5), color: Colors.black12, width: double.infinity, height: 2),
                              Container(color: AppColors.green, width: 70, height: 3)]),
                        SizedBox(height: 20,),
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