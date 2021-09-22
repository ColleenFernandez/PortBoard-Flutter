import 'dart:async';
import 'dart:typed_data';

import 'package:driver/assets/AppColors.dart';
import 'package:driver/assets/Assets.dart';
import 'package:driver/common/API.dart';
import 'package:driver/common/APIConst.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/model/JobModel.dart';
import 'package:driver/utils/utils.dart';
import 'package:driver/widget/CustomMapMarker/MapMarker.dart';
import 'package:driver/widget/CustomMapMarker/MarkerGenerator.dart';
import 'package:driver/widget/CustomMapMarker/locations.dart';
import 'package:driver/widget/StsImgView.dart';
import 'package:driver/widget/WaterRipple/WaterRipple.dart';
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

  final controller = Completer<GoogleMapController>();

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

            Future.delayed(Duration(seconds: 2), () {
              mapController.moveCamera(CameraUpdate.scrollBy(0, 150));
              setState(() {
                isBottomSheetShown = true;
              });
            });

            showModalBottomSheet(
                barrierColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                context: context,
                builder: (context) {
                  return showJobDetailBottomSheet(context, allData[i]);
                }).then((value) {
                  Future.delayed(Duration(seconds: 2), () {
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
            element.isSelected ? AppColors.green_marker : AppColors.darkBlue)
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
                  zoomGesturesEnabled: true, mapType: MapType.normal,
                  initialCameraPosition:  CameraPosition(
                      target: _center,
                      zoom: 20), //getCameraPosition(),
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
              )
            ],
          ),
          Positioned(
            right: 10,
            child: Container(margin: EdgeInsets.only(left: 10, top: 10),
              child: AdvancedSwitch(controller: switchController, activeColor: Colors.green, inactiveColor: Colors.grey)),
          ),
          Center(
              child: Visibility(
                  visible: isBottomSheetShown,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 300),
                      width: 150, height: 150,child: WaterRipple()))),
        ],
      ));
  }

  CameraPosition getCameraPosition(){
    if (allData.length == 0){
      return CameraPosition(target: Constants.initMapPosition, zoom: 15);
    }
    return CameraPosition(target: LatLng(allData[0].latitude, allData[0].longitude), zoom: 15);
  }

  Widget showJobDetailBottomSheet(BuildContext context, JobModel model){
    return Container(
      height: 410,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: 40),
                        padding: EdgeInsets.only(top: 50), width: double.infinity,
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
                    Container(
                      color: Color(0xFFe5e5e3),
                      padding: EdgeInsets.only(top: 10),
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
                                  style: ElevatedButton.styleFrom(primary: AppColors.green),
                                  onPressed: () {

                                  },
                                  child: Text('DETAILS'),
                                )
                            ),
                            Container(
                                width: (MediaQuery
                                    .of(context)
                                    .size
                                    .width - 50) / 2 - 10,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: AppColors.darkBlue),
                                  onPressed: () {

                                  },
                                  child: Text('DETAILS'),
                                ))]))]))),
          Align(alignment: Alignment.topCenter,
              child: ClipOval(child: StsImgView(image: Assets.NELSON_IMG, width: 80, height: 80)))
        ],
      ),
    );
  }
}

