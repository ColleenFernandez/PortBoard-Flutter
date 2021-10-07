import 'package:driver/assets/AppColors.dart';
import 'package:driver/assets/Assets.dart';
import 'package:driver/widget/StsImgView.dart';
import 'package:fdottedline/fdottedline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class SaveChassisInfoBottomSheet {
  Widget show(BuildContext context){
    return Container(
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
                              color: AppColors.lightBlue,),
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
                        ),
                      ]
                  ),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(top: 5, left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(margin: EdgeInsets.only(top: 5),
                                child: Stack(
                                    children: [
                                      Container(margin: EdgeInsets.only(top: 0.5), color: Colors.black12, width: double.infinity, height: 2),
                                      Container(color: AppColors.lightBlue, width: 50, height: 3)])),
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
                                              borderRadius: BorderRadius.all(Radius.circular(6)),
                                              color: AppColors.lightBlue))
                                    ]),
                                SizedBox(width: 20),
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10),
                                      Text('[NJ] Red Hook New Jersey', style: TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.bold)),
                                      SizedBox(height: 20),
                                      Container(width: MediaQuery.of(context).size.width - 95, height: 1, color: Colors.black12),
                                      SizedBox(height: 20),
                                      Text('6701 Tonnelle Avenue, North Bergen NJm USA', style: TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.bold), maxLines: 1)
                                    ]),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10, bottom: 10),
                              height: 0.8,
                              color: Colors.black26,
                              width: double.infinity,
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(Icons.location_on_outlined, size: 15),
                                SizedBox(width: 15),
                                Text('Distance:'),
                                Spacer(),
                                Text('2367 mi', style: TextStyle(color: AppColors.darkBlue))
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(Icons.watch_later_outlined, size: 15),
                                SizedBox(width: 15),
                                Text('Estimate Time:'),
                                Spacer(),
                                Text('5h 5min', style: TextStyle(color: AppColors.darkBlue))
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(Icons.local_fire_department_outlined, size: 15),
                                SizedBox(width: 15),
                                Text('Fuel Gallons:'),
                                Spacer(),
                                Text('73.97', style: TextStyle(color: AppColors.darkBlue))
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(Icons.handyman_outlined, size: 15),
                                SizedBox(width: 15),
                                Text('Tolls Roads:'),
                                Spacer(),
                                Text('\$175.83', style: TextStyle(color: AppColors.darkBlue))
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(Icons.monetization_on, size: 25, color: AppColors.darkBlue),
                                SizedBox(width: 8),
                                Text('Estimate Price:', style: TextStyle(fontSize: 18)),
                                Spacer(),
                                Text('\$1,348.21', style: TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.bold, fontSize: 25))
                              ],
                            ),
                          ],
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            child: Stack(
                                children: [
                                  Container(margin: EdgeInsets.only(top: 0.5), color: Colors.black12, width: double.infinity, height: 2),
                                  Container(color: AppColors.lightBlue, width: 80, height: 3)])),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 48,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(primary: AppColors.darkBlue),
                                    onPressed: () {
                                      Navigator.pop(context, true);
                                    },
                                    child: Text('PICK UP', style: TextStyle(fontSize: 20))),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 15),
                              width: 48,  height: 48,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                  color: AppColors.darkBlue
                              ),
                              child: IconButton(
                                onPressed: () {

                                },
                                icon: Icon(Icons.forum_rounded, color: Colors.white, size: 35,),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 15),
                              width: 48, height: 48,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                  color: AppColors.lightBlue
                              ),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                    },
                                    child: Icon(Icons.file_upload_outlined, color: Colors.white, size: 30,),
                                  ),
                                  Text('UPLOAD', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),)
                                ],
                              ),
                            )
                          ],
                        ),
                        Container(margin: EdgeInsets.only(top: 10),
                            child: Stack(
                                children: [
                                  Container(margin: EdgeInsets.only(top: 0.5), color: Colors.black12, width: double.infinity, height: 2),
                                  Container(color: AppColors.lightBlue, width: 30, height: 3)])),
                        Container(margin: EdgeInsets.only(top: 15, bottom: 15),
                            child: Center(child: Image(image: Assets.IMG_CONTAINER, width: 230,))),
                        Row(
                          children: [
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Chassis Type'),
                                Container(
                                  decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
                                  height: 40, width: MediaQuery.of(context).size.width / 2 - 45,
                                  child: Center(child: Text('40')),
                                ),
                              ],
                            ),
                            SizedBox(width: 30,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Company Chassis'),
                                Container(
                                  decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
                                  height: 40, width: MediaQuery.of(context).size.width / 2 - 45,
                                  child: Center(child: Text('Super Chassis')),
                                ),
                              ],
                            ),
                            Spacer(),
                          ],
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text('Chassis Number')),
                        Container(
                          decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
                          height: 40, width: double.infinity,
                          child: Center(child: Text('EGSU9163140')),
                        ),
                        Container(margin: EdgeInsets.only(top: 10),
                            child: Stack(
                                children: [
                                  Container(margin: EdgeInsets.only(top: 0.5), color: Colors.black12, width: double.infinity, height: 2),
                                  Container(color: AppColors.lightBlue, width: 80, height: 3)])),
                        Container(
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            width: (MediaQuery.of(context).size.width), height: 40,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(primary: AppColors.lightBlue),
                              onPressed: () {
                              },
                              child: Text('SAVE CHASSIS INFORMATION'),
                            )),
                      ],
                    ),
                  ),
                ]
            )
        )
    );
  }
}