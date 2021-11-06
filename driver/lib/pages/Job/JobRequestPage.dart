import 'package:driver/assets/AppColors.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/model/JobModel.dart';
import 'package:driver/utils/Prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_timer/simple_timer.dart';

class JobRequestPage extends StatefulWidget {

  JobModel? model;

  JobRequestPage(@required this.model);

  @override
  State<JobRequestPage> createState() => _JobRequestPageState();
}

class _JobRequestPageState extends State<JobRequestPage> with SingleTickerProviderStateMixin {

  late TimerController timerController;

  @override
  void initState() {
    super.initState();

    Prefs.clear(Constants.JOB_DETAIL);
    timerController = TimerController(this);
    Future.delayed(Duration(seconds: 1), () {
      startTimer();
    });
  }

  void startTimer(){
    timerController.start();
  }

  @override
  void dispose() {
    super.dispose();
    timerController.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        elevation: 1,
        title: Text('New Job Request'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              SizedBox(height: 20),
              Center(
                child: Container(
                  width: 200, height: 200,
                  child: SimpleTimer(
                    strokeWidth: 10,
                    controller: timerController,
                    duration: Duration(seconds: 60),
                    timerStyle: TimerStyle.ring,
                    progressIndicatorColor: AppColors.darkBlue,
                    progressTextStyle: TextStyle(color: AppColors.darkBlue, fontSize: 70),
                    backgroundColor: Colors.black12,
                    onEnd: () {

                    },
                  ),
                ),
              ),
              Row(
                children: [
                  Text('Port location : '),
                  Text(widget.model!.pickupLocation)
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('DropOff location : '),
                  Text(widget.model!.desLocation)
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('Container type : '),
                  Text(widget.model!.containerType)
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('Gross Weight : '),
                  Text(widget.model!.grossWeight)
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('Estimate Price : '),
                  Text(widget.model!.finalPrice, style: TextStyle(color: AppColors.darkBlue, fontSize: 20))
                ],
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 48, width: MediaQuery.of(context).size.width/2 - 30,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: AppColors.darkBlue),
                      onPressed: () {

                      },
                      child: Text('DECLINE'),
                    ),
                  ),
                  Container(
                    height: 48, width: MediaQuery.of(context).size.width/2 - 30,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: AppColors.green),
                      onPressed: () {

                      },
                      child: Text('ACCEPT'),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}