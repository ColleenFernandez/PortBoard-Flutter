import 'package:driver/assets/AppColors.dart';
import 'package:driver/assets/Assets.dart';
import 'package:driver/common/APIConst.dart';
import 'package:driver/common/Common.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/model/JobModel.dart';
import 'package:driver/pages/Job/TrackingPage.dart';
import 'package:driver/pages/MainPage.dart';
import 'package:driver/utils/Prefs.dart';
import 'package:driver/utils/log_utils.dart';
import 'package:driver/utils/Utils.dart';
import 'package:driver/widget/StsProgressHUD.dart';
import 'package:fdottedline/fdottedline.dart';
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

  bool loading = false;

  late TimerController timerController;
  String countdownClock = '00:00';
  int cnt60 = 60, prevValue = 60;

  @override
  void initState() {
    super.initState();

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

  void timerValueChangeListener(Duration timeElapsed){
    cnt60 = 60 - timeElapsed.inSeconds;
    if (prevValue != cnt60) {
      prevValue = cnt60;
      setState(() {
        if (prevValue < 10){
          countdownClock = '00:0${prevValue}';
        }else {
          countdownClock = '00:${prevValue}';
        }
      });
    }
  }

  void acceptJob() {
    showProgress();
    Common.api.acceptJob(Common.userModel.id, widget.model!.id.toString()).then((value) {
      closeProgress();
      if (value == APIConst.SUCCESS){
        Common.jobRequest.driverId = int.parse(Common.userModel.id);
        Common.jobRequest.status = Constants.ACCEPT;
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => TrackingPage(Common.jobRequest)));
      }else {
        showToast(APIConst.SERVER_ERROR);
      }
    }).onError((error, stackTrace) {
      closeProgress();
      showToast(APIConst.SERVER_ERROR);
      LogUtils.log('error ====> ${error.toString()}');
    });
  }

  void rejectJob(){
    showProgress();
    Common.api.rejectJob(Common.userModel.id, widget.model!.id.toString()).then((value) {
      closeProgress();
      Common.jobRequest = new JobModel();
      if (value == APIConst.SUCCESS){
        Navigator.pop(context);
      }else {
        showToast(value);
        Navigator.pop(context);
      }
    }).onError((error, stackTrace) {
      LogUtils.log('error ===> ${error.toString()}');
      Common.jobRequest = new JobModel();
      closeProgress();
    });
  }

  void skipDriver(){
    showProgress();
    Common.api.skipDriver(Common.userModel.id, widget.model!.id.toString()).then((value) {
      closeProgress();
      if (value == APIConst.SUCCESS){
        Common.jobRequest = new JobModel();
        if (Common.isMainPageLoaded){
          Navigator.pop(context);
        }else {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => MainPage()), ModalRoute.withName('/MainPage'));
        }
      }else {
        showToast(value);
      }
    }).onError((error, stackTrace) {
      closeProgress();
      LogUtils.log('error ===> ${error.toString()}');
      showToast(APIConst.SERVER_ERROR);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(body: StsProgressHUD(context, _buildWidget(context), loading));
  }

  @override
  Widget _buildWidget(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                SizedBox(height: 50),
                Text('Accept Port Jobs', style: TextStyle(color: AppColors.darkBlue, fontSize: 25)),
                SizedBox(height: 10),
                Stack(
                  children : [
                    Center(
                      child: Container(
                        width: 250, height: 250,
                        child: SimpleTimer(
                          strokeWidth: 7,
                          displayProgressText: false,
                          controller: timerController,
                          duration: Duration(seconds: 60),
                          timerStyle: TimerStyle.ring,
                          progressIndicatorColor: AppColors.darkBlue,
                          backgroundColor: Colors.black12,
                          valueListener: timerValueChangeListener,
                          onEnd: () {
                            skipDriver();
                          },
                        ),
                      ),
                    ),
                    Center(child: Column(
                      children: [
                        SizedBox(height: 12,),
                        Image(image: Assets.IMG_CRANE_ARM, height: 150,),
                        SizedBox(height: 15,),
                        Text(widget.model!.containerType, style: TextStyle(fontSize: 25, color: AppColors.darkBlue))
                      ],
                    )),
                  ]
                ),
                SizedBox(height: 10),
                Text('Note: Offer con not be changed after', style: TextStyle(color: Colors.black54),),
                Text(countdownClock, style: TextStyle(fontSize: 55, color: AppColors.green),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        RichText(text: TextSpan(
                          style: TextStyle(color: AppColors.darkBlue, fontSize: 18),
                          children: [
                            WidgetSpan(alignment: PlaceholderAlignment.middle, child: Icon(Icons.event_note, size: 17,)),
                            TextSpan(text: Utils.dateFormat(widget.model!.pickupDate))
                          ]
                        )),
                        SizedBox(height: 5),
                        Text('Pickup Date', style: TextStyle(fontSize: 12, color: Colors.black54),)
                      ],
                    ),
                    Container(width: 1, height: 35, color: AppColors.grey_20,),
                    Column(
                      children: [
                        RichText(text: TextSpan(
                            style: TextStyle(color: AppColors.darkBlue, fontSize: 18),
                            children: [
                              WidgetSpan(alignment: PlaceholderAlignment.middle, child: Icon(Icons.schedule, size: 17,)),
                              TextSpan(text: ' ${widget.model!.pickupTime}')
                            ]
                        )),
                        SizedBox(height: 5),
                        Text('Pickup Time', style: TextStyle(fontSize: 12, color: Colors.black54),)
                      ],
                    ),
                    Container(width: 1, height: 35, color: AppColors.grey_20),
                    Column(
                      children: [
                        RichText(text: TextSpan(
                            style: TextStyle(color: AppColors.darkBlue, fontSize: 18),
                            children: [
                              WidgetSpan(alignment: PlaceholderAlignment.middle, child: Icon(Icons.place, size: 17,)),
                              TextSpan(text: ' ${widget.model!.distance} mi')
                            ]
                        )),
                        SizedBox(height: 5),
                        Text('Distance', style: TextStyle(fontSize: 12, color: Colors.black54),)
                      ],
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 8, bottom: 12),
                  width: double.infinity, height: 1, color: AppColors.grey_20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        RichText(text: TextSpan(
                            style: TextStyle(color: AppColors.darkBlue, fontSize: 18),
                            children: [
                              WidgetSpan(alignment: PlaceholderAlignment.middle, child: Icon(Icons.watch_later, size: 17,)),
                              TextSpan(text: ' ${widget.model!.duration}')
                            ]
                        )),
                        SizedBox(height: 5),
                        Text('Estimate Time', style: TextStyle(fontSize: 12, color: Colors.black54),)
                      ],
                    ),
                    Container(width: 1, height: 35, color: AppColors.grey_20,),
                    Column(
                      children: [
                        RichText(text: TextSpan(
                            style: TextStyle(color: AppColors.darkBlue, fontSize: 18),
                            children: [
                              WidgetSpan(alignment: PlaceholderAlignment.middle, child: Icon(Icons.local_gas_station, size: 17,)),
                              TextSpan(text: ' ${widget.model!.fuelGallons}')
                            ]
                        )),
                        SizedBox(height: 5),
                        Text('Fuel Gallons', style: TextStyle(fontSize: 12, color: Colors.black54),)
                      ],
                    ),
                    Container(width: 1, height: 35, color: AppColors.grey_20,),
                    Column(
                      children: [
                        RichText(text: TextSpan(
                            style: TextStyle(color: AppColors.darkBlue, fontSize: 18),
                            children: [
                              WidgetSpan(alignment: PlaceholderAlignment.middle, child: Icon(Icons.monetization_on, size: 17,)),
                              TextSpan(text: ' \$${widget.model!.tollsRates}')
                            ]
                        )),
                        SizedBox(height: 5),
                        Text('Tolls Roads', style: TextStyle(fontSize: 12, color: Colors.black54),)
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Stack(
                    children: [
                      Container(margin: EdgeInsets.only(top: 0.5), color: Colors.black12, width: double.infinity, height: 2),
                      Container(color: AppColors.green, width: 30, height: 3)]),
                SizedBox(height: 5,),
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
                          Text(Utils.limitStrLength(widget.model!.pickupLocation, 45), maxLines: 1 , style: TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.bold)),
                          SizedBox(height: 15),
                          Container(width: MediaQuery.of(context).size.width - 120, height: 1, color: Colors.black12),
                          SizedBox(height: 15),
                          Text(Utils.limitStrLength(widget.model!.desLocation, 45), maxLines: 1, style: TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.bold))
                        ]),
                    SizedBox(width: 10)],
                ),
                SizedBox(height: 15,),
                Stack(
                    children: [
                      Container(margin: EdgeInsets.only(top: 0.5), color: Colors.black12, width: double.infinity, height: 2),
                      Container(color: AppColors.green, width: 30, height: 3)]),
                SizedBox(height: 20,),
                Text('\$${widget.model!.finalPrice}', style: TextStyle(color: AppColors.green, fontSize: 50),),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 48, width: MediaQuery.of(context).size.width/2 - 30,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: AppColors.darkBlue),
                        onPressed: () {
                          if (widget.model!.id > 0){
                            rejectJob();
                          }
                        },
                        child: Text('DECLINE'),
                      ),
                    ),
                    Container(
                      height: 48, width: MediaQuery.of(context).size.width/2 - 30,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: AppColors.green),
                        onPressed: () {
                          if (widget.model!.id > 0){
                            acceptJob();
                          }
                        },
                        child: Text('ACCEPT'),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 30,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showProgress() {
    setState(() {
      loading = true;
    });
  }

  void closeProgress(){
    setState(() {
      loading = false;
    });
  }
}