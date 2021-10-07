import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:driver/assets/AppColors.dart';
import 'package:driver/assets/Assets.dart';
import 'package:driver/common/API.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/service/LocationService.dart';
import 'package:driver/utils/Prefs.dart';
import 'package:driver/widget/StsImgView.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_animarker/flutter_map_marker_animation.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
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
  GoogleMapController? mapController;

  GlobalKey iconKey = GlobalKey();

  final LatLng _center = const LatLng(13.1896, 80.3039);
  List<Marker> customMarkers = [];
  dynamic userPhoto = Assets.NELSON_IMG;
  bool isMarkerClicked = false;
  final controller = Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();

    LocationService.start();
    switchController.addListener(() {
      if (switchController.value){
        LocationService.resume();
      }else {
        LocationService.pause();
      }
      setState(() {});
    });

    FBroadcast.instance().register(Constants.UPDATE_MAP_CAMERA_POSITION, (value, callback) {

      if (!switchController.value) {
        LocationService.pause();
      }
      if (mapController != null){
        final position = value as Position;
        mapController?.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 12)));
      }
    });

    progressDialog = ProgressDialog(context);
    progressDialog.style(progressWidget: Container(padding: EdgeInsets.all(13), child: CircularProgressIndicator(color: AppColors.lightBlue)));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          title: Text('Home', style: TextStyle(color: Colors.white)), backgroundColor: AppColors.darkBlue),
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
                        Row(
                          children: [
                            Text('4.9', style: TextStyle(color: Colors.white))
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
                child: Animarker(
                  curve: Curves.bounceInOut,
                  rippleRadius: 1.0,
                  rippleColor: Colors.black,
                  rippleDuration: Duration(milliseconds: 2500),
                  markers: <Marker>{
                    RippleMarker(
                      markerId: MarkerId('LiMingMarker'),
                      position: LatLng(0,0),
                      ripple: true
                    )
                  },
                  mapId: controller.future.then((value) => value.mapId),
                  child: GoogleMap(
                    zoomControlsEnabled: false,
                    zoomGesturesEnabled: true, mapType: MapType.normal,
                    initialCameraPosition:  CameraPosition(
                        target: _center,
                        zoom: 20), //getCameraPosition(),
                    markers: customMarkers.toSet(),
                    onMapCreated: (gcontroller) {
                      controller.complete(gcontroller);
                      setState(() {
                        mapController = gcontroller;
                      });}),
                ),
              ),
            ],
          ),
        ],
      ));
  }
}