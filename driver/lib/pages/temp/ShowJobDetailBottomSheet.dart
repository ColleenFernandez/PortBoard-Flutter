import 'package:driver/assets/AppColors.dart';
import 'package:driver/assets/Assets.dart';
import 'package:driver/model/JobModel.dart';
import 'package:driver/pages/temp/AcceptRequestBottomSheet.dart';
import 'package:driver/widget/StsImgView.dart';
import 'package:fdottedline/fdottedline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShowJobDetailBottomSheet{
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
                    color: AppColors.grey_10,
                    padding: EdgeInsets.only(top: 5),
                    child: Card(
                      elevation: 5,
                      child: Column(
                        children: [
                          SizedBox(height: 15),
                          Row(
                              children: [
                                SizedBox(width: 10),
                                Icon(Icons.schedule, size: 15),
                                SizedBox(width: 10),
                                Text('11:00 AM'),
                                Spacer(),
                                Text('\$ 1,048.21', style: TextStyle(fontSize: 25, color: AppColors.darkBlue, fontWeight: FontWeight.bold)),
                                SizedBox(width: 10)]),
                          SizedBox(height: 10),
                          Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: Stack(
                                  children: [
                                    Container(margin: EdgeInsets.only(top: 0.5), color: Colors.black12, width: double.infinity, height: 2),
                                    Container(color: AppColors.green, width: 30, height: 3)])),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              SizedBox(width: 10),
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
                              SizedBox(width: 10)],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            padding: EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
                            color: AppColors.grey_5,
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today_outlined, size: 15, color: Colors.black54),
                                SizedBox(width: 10),
                                Text('11:00 AM', style: TextStyle(color: Colors.black54)),
                                Spacer(),
                                Icon(Icons.location_on_sharp, size: 15, color: Colors.black54),
                                SizedBox(width: 10),
                                Text('236.7 mi', style: TextStyle(color: Colors.black54)),
                                Spacer(),
                                Icon(Icons.backpack, size: 15, color: Colors.black54),
                                SizedBox(width: 10),
                                Text('236.7 mi', style: TextStyle(color: Colors.black54))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                      color: Color(0xFFe5e5e3),
                      padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: (MediaQuery.of(context).size.width - 50) / 2 - 10,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(primary: AppColors.darkBlue),
                                  onPressed: () {

                                  },
                                  child: Text('DECLINE'),
                                )
                            ),
                            Container(
                                width: (MediaQuery.of(context).size.width - 50) / 2 - 10,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(primary: AppColors.green),
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                  child: Text('DETAILS'),
                                ))])),
                  Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.white,
                    height: 220,
                    child: GoogleMap(
                      zoomGesturesEnabled: true,
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                          target: LatLng(40.71839071308001, -74.22127424602945),
                          zoom: 15
                      ),
                      onMapCreated: (controller){

                      },
                    ),
                  )
                ]
            )
        )
    );
  }
}