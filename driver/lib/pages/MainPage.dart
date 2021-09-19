import 'dart:typed_data';

import 'package:driver/assets/AppColors.dart';
import 'package:driver/assets/Assets.dart';
import 'package:driver/common/API.dart';
import 'package:driver/common/APIConst.dart';
import 'package:driver/common/Common.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/model/JobModel.dart';
import 'package:driver/utils/log_utils.dart';
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
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

class MainPage extends StatefulWidget{
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  final switchController = AdvancedSwitchController();

  int selectedDestination = 0;
  late final ProgressDialog progressDialog;
  API api = new API();
  late GoogleMapController mapController;

  List<JobModel> allData = [];
  GlobalKey iconKey = GlobalKey();

  final LatLng _center = const LatLng(13.1896, 80.3039);
  List<Marker> customMarkers = [];
  dynamic userPhoto = Assets.DEFAULT_IMG;
  bool isMarkerClicked = false, isBottomSheetShown = false;

  @override
  void initState() {
    super.initState();
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

            isBottomSheetShown = true;
            showModalBottomSheet(
                barrierColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                context: context,
                builder: (context) {
                  return showJobDetailBottomSheet(context, allData[i]);
                }).then((value) {
                  Future.delayed(Duration(seconds: 5), () {
                    setState(() {isBottomSheetShown = false;});
                  });
            });
          }
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
            element.estimated_price_driver,
            element.isSelected ? AppColors.green : AppColors.darkBlue)
    )).toList();
  }

  void getAllJobs() {
    progressDialog.show();
    api.getAllProjects().then((value) {
      progressDialog.hide();
      if (value is String){
        showToast(value);
      }else {
        allData.addAll(value);
        if (mapController != null){
          mapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(allData[0].latitude, allData[0].longitude), zoom: 12)));
        }
        setState(() {
          loadMarker();
        });
      }
    }).onError((error, stackTrace) {
      progressDialog.hide();
      showToast(APIConst.SERVER_ERROR);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isMarkerClicked){
      isMarkerClicked = false;
      loadMarker();
    }

    return Scaffold(
      appBar: AppBar(
          title: Text('Home', style: TextStyle(color: Colors.white)), backgroundColor: AppColors.darkBlue),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(padding: EdgeInsets.only(top: 40, left: 20, right: 10), height: 250, color: AppColors.darkBlue,
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
                leading: Icon(Icons.analytics_outlined, color:Colors.black87),
                title: Text('Dashboard', style: TextStyle(color:Colors.black87)),
                onTap: (){

                },
              ),
              ListTile(leading: Icon(Icons.map, color:Colors.black87), title: Text('Port Board', style: TextStyle(color:Colors.black87)),
                onTap: (){

                }),
              ListTile(leading: Icon(Icons.history_outlined, color:Colors.black87), title: Text('Container History', style: TextStyle(color:Colors.black87)),
                onTap: (){

                }),
              ListTile(leading: Icon(Icons.request_quote, color:Colors.black87), title: Text('My Earnings', style: TextStyle(color:Colors.black87)),
                onTap: (){

                }),
              ListTile(
                leading: Icon(Icons.person_pin, color:Colors.black87),
                title: Text('My Profile', style: TextStyle(color:Colors.black87)),
                onTap: (){

                },
              ),
              ListTile(
                leading: Icon(Icons.folder_sharp, color:Colors.black87),
                title: Text('My Documents', style: TextStyle(color:Colors.black87)),
                trailing: Icon(Icons.error_outline_outlined, color: Colors.red),
                onTap: (){
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/VerificationStatusPage');
                },
              ),
              ListTile(
                leading: Icon(Icons.insert_drive_file_sharp, color:Colors.black87),
                title: Text('My Trucks', style: TextStyle(color:Colors.black87)),
                onTap: (){

                },
              ),
              ListTile(
                leading: Icon(Icons.headset_mic_sharp, color:Colors.black87),
                title: Text('Contact Us', style: TextStyle(color:Colors.black87)),
                onTap: (){

                },
              ),
              ListTile(
                leading: Icon(Icons.help_sharp, color:Colors.black87),
                title: Text('Help', style: TextStyle(color:Colors.black87)),
                onTap: (){

                },
              ),
              ListTile(
                leading: Icon(Icons.logout, color:Colors.black87),
                title: Text('Logout', style: TextStyle(color:Colors.black87)),
                onTap: (){

                },
              ),
            ],
          ),
        )
      ),
      body: Stack(
        children: [
          GoogleMap(
            zoomGesturesEnabled: true,
            mapType: MapType.normal,
            initialCameraPosition:  CameraPosition(
                target: _center,
                zoom: 20
            ), //getCameraPosition(),
            markers: customMarkers.toSet(),
            onMapCreated: (controller) {
              setState(() {
                mapController = controller;
                getAllJobs();
              });
            }),
          Container(
            margin: EdgeInsets.only(left: 10, top: 10),
            child: AdvancedSwitch(
              controller: switchController,
              activeColor: Colors.green,
              inactiveColor: Colors.grey),
          ),
          Center(child: Visibility(visible: isBottomSheetShown, child: Container(width: 150, height: 150,child: WaterRipple())))
        ],
      ));
  }

/*  Set<Marker> getMarkers(){
    setState(() {
      allData.forEach((element) {
        markers.add(Marker(
          markerId: MarkerId(element.p_id),
          position: LatLng(element.latitude, element.longitude),
        ));
      });
    });

    return markers;
  }*/

  CameraPosition getCameraPosition(){
    if (allData.length == 0){
      return CameraPosition(target: Constants.initMapPosition, zoom: 15);
    }
    return CameraPosition(target: LatLng(allData[0].latitude, allData[0].longitude), zoom: 15);
  }

  Widget showJobDetailBottomSheet(BuildContext context, JobModel model){
    return Container(
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(7),
            width: double.infinity,
            child: Card(shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
              elevation: 5,
              margin: EdgeInsets.only(top: 30),
              child: SingleChildScrollView(
                child: Column(
                    children: [
                      Container(padding: EdgeInsets.only(top: 50),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            color: AppColors.green,),
                          child: Column(
                            children: [
                              Text('Nelson Buldier',
                                  style: TextStyle(color: Colors.white)),
                              RatingBar.builder(ignoreGestures: true,
                                  initialRating: 4,
                                  minRating: 1,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 20,
                                  itemPadding: EdgeInsets.symmetric(
                                      horizontal: 3),
                                  itemBuilder: (context, _) =>
                                      Icon(Icons.star, color: Colors.white),
                                  onRatingUpdate: (rating) {}),
                              SizedBox(height: 5),
                            ],
                          )),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(width: 10),
                          Icon(Icons.schedule),
                          SizedBox(width: 10),
                          Text('11:00 AM'),
                          Spacer(),
                          Text('\$1048.21', style: TextStyle(fontSize: 25,
                              color: AppColors.darkBlue,
                              fontWeight: FontWeight.bold)),
                          SizedBox(width: 10),
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(margin: EdgeInsets.only(
                          left: 10, right: 10),
                          child: Stack(
                              children: [
                                Container(margin: EdgeInsets.only(top: 0.5),
                                    color: Colors.black38,
                                    width: double.infinity,
                                    height: 2),
                                Container(color: AppColors.green,
                                    width: 150,
                                    height: 3)
                              ])),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(width: 10),
                          Column(
                              children: [
                                SizedBox(height: 12),
                                Container(width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(6)),
                                        color: AppColors.darkBlue)),
                                Container(margin: EdgeInsets.only(
                                    left: 1, top: 1.5),
                                    child: FDottedLine(
                                        color: Colors.black38,
                                        height: 42,
                                        strokeWidth: 2,
                                        dottedLength: 5,
                                        space: 2)),
                                Container(width: 12,
                                    height: 12,
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
                                Text('[NJ] Red Hook New Jersey',
                                    style: TextStyle(
                                        color: AppColors.darkBlue,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 20),
                                Container(width: MediaQuery
                                    .of(context)
                                    .size
                                    .width - 67,
                                    height: 1,
                                    color: Colors.black45),
                                SizedBox(height: 20),
                                Text(
                                    '6701 Tonnelle Avenue, North Bergen NJm USA',
                                    style: TextStyle(
                                        color: AppColors.darkBlue,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1)
                              ]),
                          SizedBox(width: 10)],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        padding: EdgeInsets.only(
                            left: 15, right: 15, top: 8, bottom: 8),
                        color: Colors.black.withAlpha(15),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today_outlined, size: 15,
                                color: Colors.black54),
                            SizedBox(width: 10),
                            Text('11:00 AM',
                                style: TextStyle(color: Colors.black54)),
                            Spacer(),
                            Icon(Icons.location_on_sharp, size: 15,
                                color: Colors.black54),
                            SizedBox(width: 10),
                            Text('236.7 mi',
                                style: TextStyle(color: Colors.black54)),
                            Spacer(),
                            Icon(Icons.backpack, size: 15,
                                color: Colors.black54),
                            SizedBox(width: 10),
                            Text('236.7 mi',
                                style: TextStyle(color: Colors.black54))
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: 10, right: 10, top: 10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Container(
                                  width: (MediaQuery
                                      .of(context)
                                      .size
                                      .width - 30) / 2 - 10,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: AppColors.green),
                                    onPressed: () {

                                    },
                                    child: Text('DETAILS'),
                                  )
                              ),
                              Container(
                                  width: (MediaQuery
                                      .of(context)
                                      .size
                                      .width - 30) / 2 - 10,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: AppColors.darkBlue),
                                    onPressed: () {

                                    },
                                    child: Text('DETAILS'),
                                  )
                              )
                            ]
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        height: 250,
                        child: GoogleMap(
                          zoomGesturesEnabled: true,
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                              target: LatLng(
                                  40.71839071308001, -74.22127424602945),
                              zoom: 15
                          ),
                          onMapCreated: (controller) {

                          },
                        ),
                      )
                    ]),
              ),
            ),
          ),
          Align(alignment: Alignment.topCenter,
              child: ClipOval(child: StsImgView(image: Assets.NELSON_IMG, width: 80, height: 80)))
        ],
      ),
    );
  }
}

