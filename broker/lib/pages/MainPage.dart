import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:driver/assets/AppColors.dart';
import 'package:driver/assets/Assets.dart';
import 'package:driver/common/API.dart';
import 'package:driver/common/APIConst.dart';
import 'package:driver/common/Common.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/common/FirebaseAPI.dart';
import 'package:driver/model/GoodsTypeModel.dart';
import 'package:driver/model/LoadDescriptionModel.dart';
import 'package:driver/model/PortModel.dart';
import 'package:driver/model/SteamshipLineModel.dart';
import 'package:driver/model/VesselModel.dart';
import 'package:driver/pages/account/FirstPage.dart';
import 'package:driver/pages/post_job/FirstStepPage.dart';
import 'package:driver/service/LocationService.dart';
import 'package:driver/utils/Prefs.dart';
import 'package:driver/utils/log_utils.dart';
import 'package:driver/utils/utils.dart';
import 'package:driver/widget/StsImgView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

class MainPage extends StatefulWidget{
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  late final ProgressDialog progressDialog;
  GoogleMapController? mapController;
  final controller = Completer<GoogleMapController>();

  dynamic userPhoto = Assets.NELSON_IMG;
  List<Marker> markerList = [];

  late BitmapDescriptor truckIcon, truckSmallIcon, myLocationMarkerIcon;
  late Marker myLocationMarker;
  late Timer timer;
  String selectTerminal = 'Select port terminal';
  String selectDestination = 'Select Destination';

  @override
  void initState() {
    super.initState();
    progressDialog = ProgressDialog(context);
    progressDialog.style(progressWidget: Container(padding: EdgeInsets.all(13), child: CircularProgressIndicator(color: AppColors.lightBlue)));

    callMainPageAPI();

    Utils.customMarker(Assets.IC_TRUCK_PATH).then((value) {
      truckIcon = value;
    });

    Utils.customMarker(Assets.IC_TRUCK_SMALL_PATH).then((value) {
      truckSmallIcon = value;
    });

    timer = new Timer.periodic(Duration(seconds: 5), (timer) {
      FirebaseAPI.getOnlineDriverList().then((driverList) {

        markerList.clear();
        markerList.add(myLocationMarker);

        if (driverList.isNotEmpty){
          driverList.forEach((element) {
            Marker marker = new Marker(
                markerId: MarkerId(element.id),
                rotation: double.parse(element.heading),
                position: LatLng(double.parse(element.lat), double.parse(element.lng)),
                draggable: false,
                zIndex: 2,
                flat: true,
                anchor: Offset(0.5, 0.5),
                icon:  getIcon()
            );
            markerList.add(marker);
          });

          setState(() {});
        }
      });
    });

    addMyLocationMarker();
  }

  callMainPageAPI (){
    showProgress();
    Common.api.mainPageAPI().then((value) {
      closeProgress();
      if (value is String){
        showToast(value);
      }else {
        final res = value as Map<String, dynamic>;

        if (res.containsKey(APIConst.loadDescriptionList)) {
          Common.loadDescriptionList.clear();
          Common.loadDescriptionList.addAll(res[APIConst.loadDescriptionList] as List<LoadDescriptionModel>);
        }

        if (res.containsKey(APIConst.goodsList)){
          Common.goodsList.clear();
          Common.goodsList.addAll(res[APIConst.goodsList] as List<GoodsTypeModel>);
        }

        if (res.containsKey(APIConst.vesselList)) {
          Common.vesselList.clear();
          Common.vesselList.addAll(res[APIConst.vesselList] as List<VesselModel>);
        }

        if (res.containsKey(APIConst.steamshipLineList)) {
          Common.steamshipLine.clear();
          Common.steamshipLine.addAll(res[APIConst.steamshipLineList] as List<SteamShipLineModel>);
        }

        if (res.containsKey(APIConst.portList)) {
          Common.portList.clear();
          Common.portList.addAll(res[APIConst.portList] as List<PortModel>);
        }

        if (res.containsKey(APIConst.portLoadings)) {
          Common.portLoadings.clear();
          Common.portLoadings.addAll(res[APIConst.portLoadings]);
        }
      }
    }).onError((error, stackTrace) {
      closeProgress();
      showToast(APIConst.NETWORK_ERROR);
    });
  }

  BitmapDescriptor getIcon(){
    if (Platform.isAndroid) {
      return truckIcon;
    }
    return truckSmallIcon;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (timer != null){
      timer.cancel();
    }
  }

  void addMyLocationMarker() async{

    Utils.myLocationMarkerIcon().then((value) {

      myLocationMarkerIcon = value;

      myLocationMarker = new Marker(
          markerId: MarkerId(Common.userModel.id),
          position: LatLng(Common.myLat, Common.myLng),
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon:  myLocationMarkerIcon
      );

      markerList.add(myLocationMarker);

      mapController!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(Common.myLat, Common.myLng),
          zoom: 15)));

      setState(() {});
    });
  }

  void moveCameraToMyPosition(){
    mapController!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(Common.myLat, Common.myLng),
        zoom: 15)));
  }

  void showStartToEndLocationDialog(){
    showGeneralDialog(
        barrierLabel: "Label",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0),
        transitionDuration: Duration(milliseconds: 500),
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return FirstStepPage();
        },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, -1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          title: Text('Port Board', style: TextStyle(color: Colors.white)), backgroundColor: AppColors.darkBlue),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 40, left: 20, right: 10), height: 220, color: AppColors.lightBlue,
                  child: Column(
                      children: [
                        ClipOval(child: StsImgView(image: userPhoto, width: 110, height: 110)),
                        SizedBox(height : 10),
                        Text('Nelson Buldier', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height : 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('4.9', style: TextStyle(color: Colors.white, fontSize: 16)),
                            SizedBox(width: 5),
                            RatingBar.builder(ignoreGestures: true, initialRating: 4, minRating: 1, allowHalfRating: true, itemCount: 5, itemSize: 20,
                                itemPadding: EdgeInsets.symmetric(horizontal: 3),
                                itemBuilder: (context, _) => Icon(Icons.star, color: Colors.white),
                                onRatingUpdate: (rating) {})
                          ],
                        )
                      ])),
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
                leading: Icon(Icons.history_outlined, color:Colors.black87), title: Text('Container Booking', style: TextStyle(color:Colors.black87)),
                onTap: (){

                }),
              ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                dense: true,
                leading: Icon(Icons.location_pin, color:Colors.black87), title: Text('Truck Containers', style: TextStyle(color:Colors.black87)),
                onTap: (){

                }),
              ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                dense: true,
                leading: Icon(Icons.person_pin, color:Colors.black87), title: Text('Containers History', style: TextStyle(color:Colors.black87)),
                onTap: (){

                },
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                dense: true,
                leading: Icon(Icons.folder_sharp, color:Colors.black87), title: Text('My Profile', style: TextStyle(color:Colors.black87)),
                onTap: (){
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/VerificationStatusPage');
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                dense: true,
                leading: Icon(Icons.insert_drive_file_sharp, color:Colors.black87), title: Text('Payment', style: TextStyle(color:Colors.black87)),
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
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: GoogleMap(
                markers: markerList.toSet(),
                zoomControlsEnabled: true,
                zoomGesturesEnabled: true, mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                    target: LatLng(Common.myLat, Common.myLng),
                    zoom: 16
                ),
                onMapCreated: (gcontroller) {
                  controller.complete(gcontroller);
                  setState(() {
                    mapController = gcontroller;
                  });
                }),
          ),
          Positioned(
            bottom: 20, right: 0, left: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: AppColors.darkBlue,
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.7), spreadRadius: 2, blurRadius: 8, offset: Offset(0, 2))]
                  ),
                  width: MediaQuery.of(context).size.width/2 - 40,
                  height: 48,
                  margin: EdgeInsets.only(left: 20),
                  child: TextButton(
                    onPressed: () {
                      showStartToEndLocationDialog();
                    },child: Text('Trucker Express', style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: AppColors.lightBlue,
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.7), spreadRadius: 2, blurRadius: 8, offset: Offset(0, 2))]
                  ),
                  height: 48,
                  width: MediaQuery.of(context).size.width/2 - 40,
                  margin: EdgeInsets.only(right: 20),
                  child: TextButton(
                    onPressed: () {
                      showStartToEndLocationDialog();
                    },child: Text('Port Board', style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 10, top: 10,
            child: FloatingActionButton.small(
              backgroundColor: Colors.white,
              onPressed: () {
                moveCameraToMyPosition();
              },
              child: Icon(Icons.location_searching, color: Colors.black,),
            ),
          )
        ],
      ));
  }

  showProgress(){
    if (!progressDialog.isShowing()){
      progressDialog.show();
    }
  }

  closeProgress(){
    if (progressDialog.isShowing()){
      progressDialog.hide();
    }
  }
}