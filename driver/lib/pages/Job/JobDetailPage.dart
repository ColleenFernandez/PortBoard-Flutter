import 'package:driver/assets/AppColors.dart';
import 'package:driver/assets/Assets.dart';
import 'package:driver/widget/StsImgView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class JobDetailPage extends StatefulWidget {
  @override
  State<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: AppColors.green,
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  ClipOval(child: StsImgView(image: Assets.DEFAULT_IMG, width: 70, height: 70)),
                  Column(
                    children: [
                      Text('Ramirez Shipping', style: TextStyle(color: Colors.white, fontSize: 17)),
                      Row(
                        children: [
                          Text('4.9', style: TextStyle(color: Colors.white, fontSize: 13)),
                          RatingBar.builder(
                              initialRating: 3,
                              minRating: 1,
                              itemSize: 25,
                              itemCount: 5,
                              allowHalfRating: true,
                              itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                              itemBuilder: (context, _) => Icon(Icons.star),
                              onRatingUpdate: (rating) {

                              })
                        ],
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}