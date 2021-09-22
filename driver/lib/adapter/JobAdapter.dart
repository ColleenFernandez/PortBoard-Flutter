import 'package:driver/assets/AppColors.dart';
import 'package:fdottedline/fdottedline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class JobAdapter{
  Widget item(BuildContext context){
    return Card(
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: Column(
        children: [
          SizedBox(height: 10),
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
              margin: EdgeInsets.only(
                  left: 10, right: 10),
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
            padding: EdgeInsets.only(
                left: 15, right: 15, top: 8, bottom: 8),
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
    );
  }
}