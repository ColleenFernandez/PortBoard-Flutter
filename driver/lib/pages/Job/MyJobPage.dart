import 'package:driver/adapter/JobAdapter.dart';
import 'package:driver/assets/AppColors.dart';
import 'package:driver/common/Common.dart';
import 'package:driver/model/JobModel.dart';
import 'package:driver/pages/temp/AcceptRequestBottomSheet.dart';
import 'package:driver/pages/temp/CompleteService.dart';
import 'package:driver/pages/temp/ConfirmBottomSheet.dart';
import 'package:driver/pages/temp/SaveChassisInfoBottomSheet.dart';
import 'package:driver/utils/log_utils.dart';
import 'package:fdottedline/fdottedline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/scheduler.dart';

import '../temp/ShowJobDetailBottomSheet.dart';
import '../temp/SignatureConfirm.dart';

class MyJobPage extends StatefulWidget{
  @override
  State<MyJobPage> createState() => _MyJobPageState();
}

class _MyJobPageState extends State<MyJobPage> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (Common.myJob.id > 0) {
        showCurrentJobDialog();
      }
    });
  }


  void showCurrentJobDialog() {
    showDialog(context: context, builder: (BuildContext context) => Dialog(
      insetPadding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20),
          Text('Current JOB', style: TextStyle(color: AppColors.darkBlue, fontSize: 20, fontWeight: FontWeight.bold),),
          SizedBox(height: 5),
          Divider(),
          SizedBox(height: 10),
          Row(
              children: [
                SizedBox(width: 10),
                Icon(Icons.schedule, size: 15),
                SizedBox(width: 5),
                Text('Dropoff : '),
                Text('${Common.myJob.dropOffDate} ${Common.myJob.dropOffTime}'),
                Spacer(),
                Text('\$ ${Common.myJob.finalPrice}', style: TextStyle(fontSize: 25, color: AppColors.darkBlue, fontWeight: FontWeight.bold)),
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
                    Text(Common.myJob.pickupLocation, style: TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    Container(width: MediaQuery.of(context).size.width - 90, height: 1, color: Colors.black12),
                    SizedBox(height: 20),
                    Text(Common.myJob.desLocation, style: TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.bold), maxLines: 1)
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
                SizedBox(width: 5),
                Text('${Common.myJob.pickupDate} ${Common.myJob.pickupTime}', style: TextStyle(color: Colors.black54)),
                Spacer(),
                Icon(Icons.location_on_sharp, size: 15, color: Colors.black54),
                SizedBox(width: 5),
                Text('${Common.myJob.distance} mi', style: TextStyle(color: Colors.black54)),
                Spacer(),
                Icon(Icons.backpack, size: 15, color: Colors.black54),
                SizedBox(width: 5),
                Text('${Common.myJob.fuelGallons} gallons', style: TextStyle(color: Colors.black54))
              ],
            ),
          ),
          SizedBox(height: 15,),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15),
                    width: (MediaQuery.of(context).size.width - 50) / 2 - 15, height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: AppColors.darkBlue),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Close'),
                    )
                ),
                Container(
                  margin: EdgeInsets.only(right: 15),
                    width: (MediaQuery.of(context).size.width - 50) / 2 - 15, height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: AppColors.green),
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: Text('Go Detail'),
                    ))]
          ),
          SizedBox(height: 15,),
        ],
      )
    ));
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Color(0xFFE2E2E2),
        appBar: AppBar(
          elevation: 1,
          title: Text('Port Board'),
          backgroundColor: AppColors.darkBlue,
        ),
        body: Column(
          children: [
            DefaultTabController(
              length: 7,
              initialIndex: 0,
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 15, top: 15, right: 15),
                    child: TabBar(
                      onTap: (index){

                      },
                      indicatorColor: Colors.transparent,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                        color: AppColors.green,
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black54,
                      isScrollable: true,
                      tabs: [
                        Container(
                          width: 60,
                          child: Column(
                            children: [
                              SizedBox(height: 5,),
                              Text('MON', style: TextStyle(fontSize: 23),),
                              SizedBox(height: 5,),
                              Text('Jul 01')
                            ],
                          ),
                        ),
                        Container(
                          width: 60,
                          child: Column(
                            children: [
                              SizedBox(height: 5,),
                              Text('TUE', style: TextStyle(fontSize: 23),),
                              SizedBox(height: 5,),
                              Text('Jul 02')
                            ],
                          ),
                        ),
                        Container(
                          width: 60,
                          child: Column(
                            children: [
                              SizedBox(height: 5,),
                              Text('WED', style: TextStyle(fontSize: 23),),
                              SizedBox(height: 5,),
                              Text('Jul 03')
                            ],
                          ),
                        ),
                        Container(
                          width: 60,
                          child: Column(
                            children: [
                              SizedBox(height: 5,),
                              Text('THU', style: TextStyle(fontSize: 23),),
                              SizedBox(height: 5,),
                              Text('Jul 04')
                            ],
                          ),
                        ),
                        Container(
                          width: 60,
                          child: Column(
                            children: [
                              SizedBox(height: 5,),
                              Text('FRI', style: TextStyle(fontSize: 23),),
                              SizedBox(height: 5,),
                              Text('Jul 05')
                            ],
                          ),
                        ),
                        Container(
                          width: 60,
                          child: Column(
                            children: [
                              SizedBox(height: 5,),
                              Text('SAT', style: TextStyle(fontSize: 23),),
                              SizedBox(height: 5,),
                              Text('Jul 06')
                            ],
                          ),
                        ),
                        Container(
                          width: 60,
                          child: Column(
                            children: [
                              SizedBox(height: 5,),
                              Text('SUN', style: TextStyle(fontSize: 23),),
                              SizedBox(height: 5,),
                              Text('Jul 07')
                            ],
                          ),
                        )
                      ]))])),
            Card(
              margin: EdgeInsets.all(15),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Find a job...'
                ),
              ),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: 10,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                constraints: BoxConstraints.loose(Size(
                                    MediaQuery.of(context).size.width,
                                    MediaQuery.of(context).size.height * 0.9)),
                                useRootNavigator: true,
                                isScrollControlled : true,
                                barrierColor: Colors.transparent,
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (context) {
                                  return ShowJobDetailBottomSheet().show(context, new JobModel());
                                }).then((value) {
                              if (value){
                                Future.delayed(Duration(milliseconds: 700), () {

                                  showModalBottomSheet(
                                      constraints: BoxConstraints.loose(Size(
                                          MediaQuery.of(context).size.width,
                                          MediaQuery.of(context).size.height * 0.9)), // <= this is set to 3/4 of screen size.
                                      useRootNavigator: true,
                                      barrierColor: Colors.transparent,
                                      backgroundColor: Colors.transparent,
                                      context: context,
                                      isScrollControlled : true,
                                      builder: (context) {
                                        return AcceptRequestBottomSheet().show(context,  new JobModel());
                                      }).then((value) {
                                    if (value){
                                      Future.delayed(Duration(milliseconds: 700), () {
                                        showModalBottomSheet(
                                            constraints: BoxConstraints.loose(Size(
                                                MediaQuery.of(context).size.width,
                                                MediaQuery.of(context).size.height * 0.9)), // <= this is set to 3/4 of screen size.
                                            useRootNavigator: true,
                                            barrierColor: Colors.transparent,
                                            backgroundColor: Colors.transparent,
                                            context: context,
                                            isScrollControlled : true,
                                            builder: (context) {
                                              return ConfirmBottomSheet().show(context,  new JobModel());
                                            }).then((value) {
                                          if (value ){
                                            Future.delayed(Duration(milliseconds: 700), () {
                                              showModalBottomSheet(
                                                  constraints: BoxConstraints.loose(Size(
                                                      MediaQuery.of(context).size.width,
                                                      MediaQuery.of(context).size.height * 0.9)), // <= this is set to 3/4 of screen size.
                                                  useRootNavigator: true,
                                                  barrierColor: Colors.transparent,
                                                  backgroundColor: Colors.transparent,
                                                  context: context,
                                                  isScrollControlled : true,
                                                  builder: (context) {
                                                    return SaveChassisInfoBottomSheet().show(context);
                                                  }).then((value) {
                                                if (value){
                                                  Future.delayed(Duration(milliseconds: 700), () {
                                                    showModalBottomSheet(
                                                        constraints: BoxConstraints.loose(Size(
                                                            MediaQuery.of(context).size.width,
                                                            MediaQuery.of(context).size.height * 0.9)), // <= this is set to 3/4 of screen size.
                                                        useRootNavigator: true,
                                                        barrierColor: Colors.transparent,
                                                        backgroundColor: Colors.transparent,
                                                        context: context,
                                                        isScrollControlled : true,
                                                        builder: (context) {
                                                          return CompleteService().show(context);
                                                        }).then((value) {

                                                      if (value){
                                                        Future.delayed(Duration(milliseconds: 700), () {
                                                          showModalBottomSheet(
                                                              constraints: BoxConstraints.loose(Size(
                                                                  MediaQuery.of(context).size.width,
                                                                  MediaQuery.of(context).size.height * 0.9)), // <= this is set to 3/4 of screen size.
                                                              useRootNavigator: true,
                                                              barrierColor: Colors.transparent,
                                                              backgroundColor: Colors.transparent,
                                                              context: context,
                                                              isScrollControlled : true,
                                                              builder: (context) {
                                                                return SignatureConfirm().show(context);                                                                  });
                                                        });
                                                      }
                                                    });
                                                  });}
                                              });
                                            });}
                                        });
                                      });}
                                  });
                                });}
                            });
                          },
                          child: JobAdapter().item(context));
                    })
            ),
          ],
        ),
      ),
    );
  }
}