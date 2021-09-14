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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

class MainPage extends StatefulWidget{
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int selectedDestination = 0;
  late final ProgressDialog progressDialog;
  API api = new API();
  late GoogleMapController mapController;

  List<JobModel> allData = [];
  final Set<Marker> markers = new Set();
  GlobalKey iconKey = GlobalKey();

  final LatLng _center = const LatLng(13.1896, 80.3039);
  List<MapMarker> mapMarkers = [];
  List<Marker> customMarkers = [];
  dynamic userPhoto = Assets.DEFAULT_IMG;


  @override
  void initState() {
    super.initState();
    progressDialog = ProgressDialog(context);
    progressDialog.style(progressWidget: Container(padding: EdgeInsets.all(13), child: CircularProgressIndicator(color: AppColors.green)));

    getAllJobs();
  }

  loadMarker(){
    List<Marker>? mapBitmapsToMarkers (List<Uint8List> bitmaps) {
      bitmaps.asMap().forEach((i, bmp) {
        customMarkers.add(Marker(
          markerId: MarkerId("$i"),
          position: LatLng(allData[i].latitude, allData[i].longitude),
          icon: BitmapDescriptor.fromBytes(bmp),
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
    return allData.map((l) => MapMarker(
        Location(LatLng(l.latitude, l.longitude), l.estimated_price_driver)
    )).toList();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
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

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
          title: Text('Home', style: TextStyle(color: Colors.white)),
          backgroundColor: AppColors.darkBlue),

      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 40, left: 20, right: 10),
                height: 250,
                color: AppColors.darkBlue,
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipOval(
                            child: StsImgView(image: userPhoto, width: 90, height: 90)
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Nelson Buldier', style: TextStyle(color: Colors.white, fontSize: 18)),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text('\$4500', style: TextStyle(fontSize: 20, color: Colors.yellow)),
                                SizedBox(width: 5),
                                Text('Balance', style: TextStyle(fontSize: 15, color: Colors.white60))
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Icon(Icons.query_builder, color: Colors.white),
                            Text('10 hrs', style: TextStyle(color: Colors.white, fontSize: 18)),
                            Text('Total Time', style: TextStyle(color: Colors.white60, fontSize: 10)),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.speed_outlined, color: Colors.white),
                            Text('100Km', style: TextStyle(color: Colors.white, fontSize: 18)),
                            Text('Total Distance', style: TextStyle(color: Colors.white60, fontSize: 10)),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.receipt_long_outlined, color: Colors.white),
                            Text('100Km', style: TextStyle(color: Colors.white, fontSize: 18)),
                            Text('Total Distance', style: TextStyle(color: Colors.white60, fontSize: 10)),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.analytics_outlined, color:Colors.black87),
                title: Text('Dashboard', style: TextStyle(color:Colors.black87)),
                onTap: (){

                },
              ),
              ListTile(
                leading: Icon(Icons.map, color:Colors.black87),
                title: Text('Port Board', style: TextStyle(color:Colors.black87)),
                onTap: (){

                },
              ),
              ListTile(
                leading: Icon(Icons.history_outlined, color:Colors.black87),
                title: Text('Container History', style: TextStyle(color:Colors.black87)),
                onTap: (){

                },
              ),
              ListTile(
                leading: Icon(Icons.request_quote, color:Colors.black87),
                title: Text('My Earnings', style: TextStyle(color:Colors.black87)),
                onTap: (){

                },
              ),
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
      body: GoogleMap(
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
          });
        },
      )
    );
  }

  Set<Marker> getMarkers(){
    setState(() {
      allData.forEach((element) {
        markers.add(Marker(
          markerId: MarkerId(element.p_id),
          position: LatLng(element.latitude, element.longitude),
        ));
      });
    });

    return markers;
  }

  CameraPosition getCameraPosition(){
    if (allData.length == 0){
      return CameraPosition(target: Constants.initMapPosition, zoom: 15);
    }
    return CameraPosition(target: LatLng(allData[0].latitude, allData[0].longitude), zoom: 15);
  }
}