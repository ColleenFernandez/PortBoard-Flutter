import 'dart:async';
import 'dart:typed_data';

import 'package:driver/assets/AppColors.dart';
import 'package:driver/assets/Assets.dart';
import 'package:driver/common/API.dart';
import 'package:driver/common/APIConst.dart';
import 'package:driver/common/Common.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/common/FirebaseAPI.dart';
import 'package:driver/model/JobModel.dart';
import 'package:driver/pages/Job/AcceptRequestBottomSheet.dart';
import 'package:driver/pages/Job/CompleteService.dart';
import 'package:driver/pages/Job/ConfirmBottomSheet.dart';
import 'package:driver/pages/Job/SaveChassisInfoBottomSheet.dart';
import 'package:driver/pages/Job/SignatureConfirm.dart';
import 'package:driver/service/LocationService.dart';
import 'package:driver/utils/Prefs.dart';
import 'package:driver/utils/utils.dart';
import 'package:driver/widget/CustomMapMarker/MapMarker.dart';
import 'package:driver/widget/CustomMapMarker/MarkerGenerator.dart';
import 'package:driver/widget/CustomMapMarker/locations.dart';
import 'package:driver/widget/StsImgView.dart';
import 'package:driver/widget/WaterRipple/WaterRipple.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:fdottedline/fdottedline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'Job/ShowJobDetailBottomSheet.dart';

class MainPage extends StatefulWidget{
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  final switchController = AdvancedSwitchController();

  int selectedDestination = 0;
  late final ProgressDialog progressDialog;
  API api = new API();
  GoogleMapController? mapController;

  List<JobModel> allData = [];
  GlobalKey iconKey = GlobalKey();

  final LatLng _center = const LatLng(13.1896, 80.3039);
  List<Marker> customMarkers = [];
  dynamic userPhoto = Assets.DEFAULT_IMG;
  bool isMarkerClicked = false;
  final controller = Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();

    LocationService.start();
    switchController.addListener(() {
      if (switchController.value){
        LocationService.resume();
        api.changeUserStatus(Common.userModel.id, true);
        FirebaseAPI.changeUserStatus(Common.userModel.id, '1');
      }else {
        LocationService.pause();
        api.changeUserStatus(Common.userModel.id, false);
        FirebaseAPI.changeUserStatus(Common.userModel.id, '0');
      }
    });

    FBroadcast.instance().register(Constants.LOCATION_UPDATE, (value, callback) {
      if (switchController.value){
        FirebaseAPI.updateLocation(Common.userModel.id, Common.myLat.toString(), Common.myLng.toString(), Common.heading.toString()).then((value) {
          if (!value){
            showToast('Firebase Error');
          }
        });
      }
    });

    progressDialog = ProgressDialog(context);
    progressDialog.style(progressWidget: Container(padding: EdgeInsets.all(13), child: CircularProgressIndicator(color: AppColors.green)));
  }

  loadMarker(){
    List<Marker>? mapBitmapsToMarkers (List<Uint8List> bitmaps) {
      bitmaps.asMap().forEach((i, bmp) {
        customMarkers.add(Marker(
          markerId: MarkerId('$i'),
          position: LatLng(allData[i].latitude, allData[i].longitude),
          icon: BitmapDescriptor.fromBytes(bmp),
          onTap: () {
            allData[i].isSelected = !allData[i].isSelected;
            isMarkerClicked = true;
            customMarkers.clear();
            setState(() {});

            /*Future.delayed(Duration(seconds: 1), () {
              mapController?.moveCamera(CameraUpdate.scrollBy(0, 150));
              setState(() {
                isBottomSheetShown = true;
              });
            });*/

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
                  return ShowJobDetailBottomSheet().show(context, allData[i]);
                }).then((value) {
                  //setState(() {isBottomSheetShown = false;});
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
                            return AcceptRequestBottomSheet().show(context,  allData[i]);
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
                                      return ConfirmBottomSheet().show(context,  allData[i]);
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
                });}
          ));
      });
    }

    MarkerGenerator(markerWidgets(), (bitmaps) {
      setState(() {
        mapBitmapsToMarkers(bitmaps);
      });
    }).generate(context);
  }

  List<Widget> markerWidgets() {
    return allData.map((element) => MapMarker(
        Location(
            LatLng(element.latitude, element.longitude),
            element.estimatedPrice,
            element.isSelected ? AppColors.green_marker : AppColors.darkBlue)
    )).toList();
  }

  void getAllJobs() {

  }

  @override
  Widget build(BuildContext context) {
    if (isMarkerClicked){
      isMarkerClicked = false;
      loadMarker();
    }

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
                            Text('Nelson Buldier', style: TextStyle(color: Colors.white, fontSize: 18)),
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
                  Navigator.pushNamed(context, '/VerificationStatusPage');
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                dense: true,
                leading: Icon(Icons.insert_drive_file_sharp, color:Colors.black87), title: Text('My Trucks', style: TextStyle(color:Colors.black87)),
                onTap: (){

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
                  Prefs.clear();
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
                child: GoogleMap(
                    zoomControlsEnabled: false,
                    zoomGesturesEnabled: true,
                    mapType: MapType.normal,
                    initialCameraPosition:  CameraPosition(target: _center, zoom: 17), //getCameraPosition(),
                    markers: customMarkers.toSet(),
                    onMapCreated: (gcontroller) {
                      controller.complete(gcontroller);
                      setState(() {
                        mapController = gcontroller;
                        getAllJobs();
                      });}),
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
            bottom: 70,
            right: 10,
            child: FloatingActionButton.small(
              backgroundColor: Colors.white,
              onPressed: () {
                if (Common.myLng != 0.0 || Common.myLat != 0.0){
                  mapController?.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(Common.myLat, Common.myLng), zoom: 12)));
                }
              },
              child: Icon(Icons.gps_fixed_outlined, color: AppColors.darkBlue,),
            ),
          )
        ],
      ));
  }

  CameraPosition getCameraPosition(){
    if (allData.length == 0){
      return CameraPosition(target: Constants.initMapPosition, zoom: 15);
    }
    return CameraPosition(target: LatLng(allData[0].latitude, allData[0].longitude), zoom: 15);
  }
}

