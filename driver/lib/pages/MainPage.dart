import 'dart:async';

import 'package:driver/assets/AppColors.dart';
import 'package:driver/assets/Assets.dart';
import 'package:driver/common/APIConst.dart';
import 'package:driver/common/Common.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/common/FirebaseAPI.dart';
import 'package:driver/model/JobModel.dart';
import 'package:driver/pages/Job/JobRequestPage.dart';
import 'package:driver/pages/Job/TrackingPage.dart';
import 'package:driver/pages/account/TVerificationStatusPage.dart';
import 'package:driver/pages/account/VerificationStatusPage.dart';
import 'package:driver/utils/PermissionHelper.dart';
import 'package:driver/utils/Prefs.dart';
import 'package:driver/utils/log_utils.dart';
import 'package:driver/utils/Utils.dart';
import 'package:driver/widget/StsImgView.dart';
import 'package:driver/widget/StsProgressHUD.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:visibility_aware_state/visibility_aware_state.dart';


class MainPage extends StatefulWidget{

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends VisibilityAwareState<MainPage>{

  final switchController = AdvancedSwitchController();

  int selectedDestination = 0;
  bool loading = false;

  List<JobModel> allData = [];
  GlobalKey iconKey = GlobalKey();

  LatLng _center = LatLng(13.1896, 80.3039);

  dynamic userPhoto = Assets.DEFAULT_IMG;
  bool isMarkerClicked = false;

  var loadMap = false;

  @override
  void initState() {
    super.initState();

    loadData();

    checkLocationPermission();

    FBroadcast.instance().register(Constants.JOB_REQUEST, (value, callback) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => JobRequestPage(Common.jobRequest)));
    });

    FBroadcast.instance().register(Constants.LOCATION_UPDATE, (value, callback) {

      if (!loadMap){
        loadMap = true;
        _center = LatLng(Common.myLat, Common.myLng);
        changeOnOffline(Constants.ONLINE);
        FirebaseAPI.changeUserStatus(Common.userModel.id, true);
        setState(() {});
      }

      if (switchController.value){
        FirebaseAPI.updateLocation(
            Common.userModel.id,
            Common.myLat.toString(),
            Common.myLng.toString(),
            Common.heading.toString()).then((value) {
          if (!value){
            showToast('Firebase Error');
          }
        });
      }
    });

    updateToken();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      checkJobRequest();
      checkMyJob();
    });
  }

  void loadData(){
    if (Common.userModel.driverPhotoModel.status == Constants.ACCEPT){
      userPhoto = Common.userModel.driverPhotoModel.photo;
    }
  }

  void changeOnOffline(String status) {
    showProgress();
    Common.api.changeOnOffline(Common.userModel.id, status).then((value) {
      LogUtils.log('changeOnOffline  ===> ');
      closeProgress();
      if (value != APIConst.SUCCESS){
        showToast(value);
      }
    }).onError((error, stackTrace) {
      closeProgress();
    });
  }

  void checkLocationPermission() async{
    final isGranted = await askLocationPermission(context);
    if (isGranted) {
      switchController.value = true;
      Common.locationService.init();
      Common.locationService.start();
      switchController.addListener(() {
        if (switchController.value){
          Common.locationService.start();
          Common.api.changeUserStatus(Common.userModel.id, true);
          FirebaseAPI.changeUserStatus(Common.userModel.id, true);
          changeOnOffline(Constants.ONLINE);
        }else {
          Common.locationService.stop();
          Common.api.changeUserStatus(Common.userModel.id, false);
          FirebaseAPI.changeUserStatus(Common.userModel.id, false);
          changeOnOffline(Constants.OFFLINE);
        }
      });
    }
  }

  void checkMyJob(){
    if (Common.myJob.id > 0){
      Navigator.push(context, MaterialPageRoute(builder: (context) => TrackingPage(Common.myJob)));
    }
  }

  void checkJobRequest(){
    if (Common.jobRequest.id > 0){
      Navigator.push(context, MaterialPageRoute(builder: (context) => JobRequestPage(Common.jobRequest)));
    }
  }

  void updateToken(){
    Common.api.updateToken(Common.userModel.id, Common.fcmToken).then((value) {
      if (value != APIConst.SUCCESS){
        showToast(value);
      }
    }).onError((error, stackTrace) {
      LogUtils.log(error.toString());
      showToast('Token update failed');
    });
  }

  void getJobRequest(){
    Common.api.getJobRequest(Common.userModel.id).then((value) {
      if (value is JobModel){
        Common.jobRequest = value;
        Navigator.push(context, MaterialPageRoute(builder: (context) => JobRequestPage(Common.jobRequest)));
      }
    });
  }

  @override
  void onVisibilityChanged(WidgetVisibility visibility) async{
    switch (visibility){
      case WidgetVisibility.VISIBLE:
        Common.isMainPageLoaded = true;
        getJobRequest();
        break;
      case WidgetVisibility.INVISIBLE:
        break;
      case WidgetVisibility.GONE:
        break;
    }
    super.onVisibilityChanged(visibility);
  }

  @override
  void dispose() {
    super.dispose();
    FBroadcast.instance().unregister(context);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(body: StsProgressHUD(context, _buildWidget(context), loading));
  }

  @override
  Widget _buildWidget(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          actions: [
            Container(
                margin: EdgeInsets.only(top: 13, bottom: 13, right: 15),
                child: AdvancedSwitch(
                  controller: switchController,
                  activeColor: Colors.green, inactiveColor: Colors.grey)),
          ],
          title: Text('Home', style: TextStyle(color: Colors.white)), backgroundColor: AppColors.darkBlue),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(padding: EdgeInsets.only(top: 40, left: 20, right: 10), height: 220, color: AppColors.darkBlue,
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipOval(child: StsImgView(image: userPhoto, width: 90, height: 90)),
                        SizedBox(width: 10),
                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(Common.userModel.phone, style: TextStyle(color: Colors.white, fontSize: 18)),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text('\$4500', style: TextStyle(fontSize: 20, color: Colors.yellow)),
                                SizedBox(width: 5),
                                Text('Balance', style: TextStyle(fontSize: 15, color: Colors.white60))])])]),
                    SizedBox(height: 20),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Icon(Icons.query_builder, color: Colors.white),
                            Text('10 hrs', style: TextStyle(color: Colors.white, fontSize: 18)),
                            Text('Total Time', style: TextStyle(color: Colors.white60, fontSize: 10))]),
                        Column(
                          children: [
                            Icon(Icons.speed_outlined, color: Colors.white),
                            Text('100Km', style: TextStyle(color: Colors.white, fontSize: 18)),
                            Text('Total Distance', style: TextStyle(color: Colors.white60, fontSize: 10))]),
                        Column(
                          children: [
                            Icon(Icons.receipt_long_outlined, color: Colors.white),
                            Text('100Km', style: TextStyle(color: Colors.white, fontSize: 18)),
                            Text('Total Distance', style: TextStyle(color: Colors.white60, fontSize: 10))])])])),
              ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                dense: true,
                leading: Icon(Icons.analytics_outlined, color:Colors.black87), title: Text('Dashboard', style: TextStyle(color:Colors.black87)),
                onTap: (){

                },
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                dense: true,
                leading: Icon(Icons.map, color:Colors.black87), title: Text('Port Board', style: TextStyle(color:Colors.black87)),
                onTap: (){

                }),
              ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                dense: true,
                leading: Icon(Icons.history_outlined, color:Colors.black87), title: Text('Container History', style: TextStyle(color:Colors.black87)),
                onTap: (){

                }),
              ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                dense: true,
                leading: Icon(Icons.request_quote, color:Colors.black87), title: Text('My Earnings', style: TextStyle(color:Colors.black87)),
                onTap: (){

                }),
              ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                dense: true,
                leading: Icon(Icons.person_pin, color:Colors.black87), title: Text('My Profile', style: TextStyle(color:Colors.black87)),
                onTap: (){

                },
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                dense: true,
                leading: Icon(Icons.folder_sharp, color:Colors.black87), title: Text('My Documents', style: TextStyle(color:Colors.black87)),
                trailing: Icon(Icons.error_outline_outlined, color: Colors.red),
                onTap: (){
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => VerificationStatusPage()));
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                dense: true,
                leading: Icon(Icons.insert_drive_file_sharp, color:Colors.black87), title: Text('My Trucks', style: TextStyle(color:Colors.black87)),
                onTap: (){
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TVerificationStatusPage()));
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                dense: true,
                leading: Icon(Icons.headset_mic_sharp, color:Colors.black87),
                title: Text('Contact Us', style: TextStyle(color:Colors.black87)),
                onTap: (){

                },
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                dense: true,
                leading: Icon(Icons.help_sharp, color:Colors.black87),
                title: Text('Help', style: TextStyle(color:Colors.black87)),
                onTap: (){

                },
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                dense: true,
                leading: Icon(Icons.logout, color:Colors.black87),
                title: Text('Logout', style: TextStyle(color:Colors.black87)),
                onTap: (){
                  Prefs.clearAll();
                },
              ),
            ],
          ),
        )
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                /*child: loadMap ? GoogleMap(
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: false,
                    zoomGesturesEnabled: true,
                    mapType: MapType.normal,
                    initialCameraPosition:  CameraPosition(target: _center, zoom: 17), //getCameraPosition(),
                    markers: markerList.toSet(),
                    onMapCreated: (gcontroller) {
                      controller.complete(gcontroller);
                      setState(() {
                        mapController = gcontroller;
                      });}) : Center(child: Text('Locating...'),)*/
                child: loadMap ? FlutterMap(
                  options: MapOptions(
                      center: LatLng(Common.myLat, Common.myLng),
                      zoom: 13.0),
                  layers: [
                    TileLayerOptions(
                      urlTemplate: Constants.MAP_STYLE,
                      additionalOptions: {
                        'accessToken' : Constants.MAP_PUBLIC_KEY,
                        'id' : Constants.TILESET_ID
                      }
                    ),
                    MarkerLayerOptions(
                      markers: [
                        Marker(width: 45, height: 45,
                          point: LatLng(Common.myLat, Common.myLng),
                          builder: (context) {
                          return Container(
                            child: IconButton(
                              icon: Icon(Icons.location_on),
                              color: Colors.red,
                              iconSize: 45,
                              onPressed: (){

                              },
                            ),
                          );
                        })
                      ]
                    )
                  ],
                ) : Center(child: Text('Locating...')),
              ),
              Container(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black87, blurRadius: 4, offset: Offset(0, 1))
                  ],
                ),
                child: DefaultTabController(
                  length: 4,
                  initialIndex: 0,
                  child: TabBar(
                    onTap: (index) {
                      if (index == 0){
                        Navigator.pushNamed(context, '/JobSearchPage');
                      }
                    },
                    indicatorColor: Colors.transparent,
                    labelColor: AppColors.green,
                    unselectedLabelColor: Colors.black54,
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
                    tabs: <Widget>[
                        Column(
                          children: [
                            SizedBox(height: 5),
                            Icon(Icons.event_note),
                            SizedBox(height: 5),
                            Text('Calendar', style: TextStyle(fontSize: 10)),
                          ],
                        ),
                      Column(
                        children: [
                          SizedBox(height: 5),
                          Icon(Icons.local_shipping),
                          SizedBox(height: 5),
                          Text('Calendar', style: TextStyle(fontSize: 10)),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(height: 5),
                          Icon(Icons.work),
                          SizedBox(height: 5),
                          Text('Calendar', style: TextStyle(fontSize: 10)),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(height: 5),
                          Icon(Icons.yard_rounded),
                          SizedBox(height: 5),
                          Text('Calendar', style: TextStyle(fontSize: 10)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          /*Visibility(
              visible: switchController.value,
              child: Stack(
                children: [
                  Center(child: Container(width: 250, height: 250,child: WaterRipple())),
                  Center(child: ClipOval(child: StsImgView(image: Assets.NELSON_IMG, width: 70, height: 70,),))
                ],
              )),*/
          Positioned(
              child: FloatingActionButton.small(
                heroTag: 'FAB-9',
                onPressed: () {
                  showSingleButtonDialog(context, 'title', 'msg', 'Okay', () {
                    Navigator.pop(context);
                  });
              }, child: Icon(Icons.play_circle_fill),)
          )
        ],
      ));
  }

/*  CameraPosition getCameraPosition(){
    if (allData.length == 0){
      return CameraPosition(target: Constants.initMapPosition, zoom: 15);
    }
    return CameraPosition(target: LatLng(allData[0].pickupLat, allData[0].pickupLng), zoom: 15);
  }*/

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

