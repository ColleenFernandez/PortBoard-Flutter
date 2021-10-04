import 'package:driver/adapter/JobAdapter.dart';
import 'package:driver/assets/AppColors.dart';
import 'package:driver/model/JobModel.dart';
import 'package:driver/pages/Job/AcceptRequestBottomSheet.dart';
import 'package:driver/pages/Job/CompleteService.dart';
import 'package:driver/pages/Job/ConfirmBottomSheet.dart';
import 'package:driver/pages/Job/SaveChassisInfoBottomSheet.dart';
import 'package:driver/pages/Job/SignatureConfirm.dart';
import 'package:fdottedline/fdottedline.dart';
import 'package:flutter/material.dart';

import 'ShowJobDetailBottomSheet.dart';

class JobSearchPage extends StatefulWidget{
  @override
  State<JobSearchPage> createState() => _JobSearchPageState();
}

class _JobSearchPageState extends State<JobSearchPage> {
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