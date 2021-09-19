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
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
  }

  loadMarker(){
    List<Marker>? mapBitmapsToMarkers (List<Uint8List> bitmaps) {
      bitmaps.asMap().forEach((i, bmp) {
        customMarkers.add(Marker(
          markerId: MarkerId('$i'),
          position: LatLng(allData[i].latitude, allData[i].longitude),
          icon: BitmapDescriptor.fromBytes(bmp),
          onTap: () {
            //Navigator.pushNamed(context, '/JobDetailPage', arguments: allData[i]);
            showModalBottomSheet(
              barrierColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                context: context, builder: (context) {
                  return JobDetailBottomSheet(allData[i]).show(context);
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
            getAllJobs();
          });
        }));
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

class JobDetailBottomSheet {
  JobModel model = new JobModel();
  JobDetailBottomSheet(this.model);

  Widget show(BuildContext context){
    return Container(
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(7),
            width: double.infinity,
            child: Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              elevation: 5,
              margin: EdgeInsets.only(top: 30),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 50),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                        color: AppColors.green,),
                      child: Column(
                        children: [
                          Text('Nelson Buldier', style: TextStyle(color: Colors.white)),
                          RatingBar.builder(
                              ignoreGestures: true,
                              initialRating: 4,
                              minRating: 1,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 20,
                              itemPadding: EdgeInsets.symmetric(horizontal: 3),
                              itemBuilder: (context, _) => Icon(Icons.star, color: Colors.white),
                              onRatingUpdate: (rating) {}),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              SizedBox(width: 10),
                              Icon(Icons.access_time, color: Colors.white),
                              SizedBox(width: 10),
                              Text(Utils.getAgoFromNow(model.created_at),  style: TextStyle(color: Colors.white)),
                              Spacer(),
                              Text('PB${model.p_id}${model.state_from}',  style: TextStyle(color: Colors.white)),
                              SizedBox(width: 10),
                            ]),
                          SizedBox(height: 5),
                        ],
                      )),
                    SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 0.5),
                            color: Colors.black38,
                            width: double.infinity,
                            height: 2,
                          ),
                          Container(
                            color: AppColors.green,
                            width: 150,
                            height: 3,
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(width: 10),
                        Column(
                          children: [
                            Image(image: Assets.ICON_ARROW_DOWN, width: 15, height: 20, fit: BoxFit.fill),
                            Container(width: 2, height: 30, color: Colors.black45),
                            Container(width: 10, height: 10, decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: AppColors.green))]),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('[NJ] Red Hook New Jersey', style: TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            Container(
                              width: MediaQuery.of(context).size.width - 65,
                              height: 1,
                              color: Colors.black45),
                            SizedBox(height: 10),
                            Text('6701 Tonnelle Avenue, North Bergen NJm USA', style: TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.bold), maxLines: 1)]),
                        SizedBox(width: 10)],
                    ),
                    SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 0.5),
                            color: Colors.black38,
                            width: double.infinity,
                            height: 2,
                          ),
                          Container(
                            color: AppColors.green,
                            width: 150,
                            height: 3,
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              Text('Distance', style: TextStyle(fontSize: 10)),
                              Container(
                                width: (MediaQuery.of(context).size.width - 30) / 2 - 10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    border: Border.all(color: Colors.black54, width: 1)
                                ),
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Icon(Icons.location_on_outlined, size: 20),
                                    Text('13.5 mi'),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              Text('Estimate Time', style: TextStyle(fontSize: 10)),
                              Container(
                                width: (MediaQuery.of(context).size.width - 30) / 2 - 10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    border: Border.all(color: Colors.black54, width: 1)
                                ),
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Icon(Icons.location_on_outlined, size: 20),
                                    Text('13.5 mi'),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              Text('Distance', style: TextStyle(fontSize: 10)),
                              Container(
                                width: (MediaQuery.of(context).size.width - 30) / 2 - 10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    border: Border.all(color: Colors.black54, width: 1)
                                ),
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Icon(Icons.location_on_outlined, size: 20),
                                    Text('13.5 mi'),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              Text('Estimate Time', style: TextStyle(fontSize: 10)),
                              Container(
                                width: (MediaQuery.of(context).size.width - 30) / 2 - 10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    border: Border.all(color: Colors.black54, width: 1)
                                ),
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Icon(Icons.location_on_outlined, size: 20),
                                    Text('13.5 mi'),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              Text('Distance', style: TextStyle(fontSize: 10)),
                              Container(
                                width: (MediaQuery.of(context).size.width - 30) / 2 - 10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    border: Border.all(color: Colors.black54, width: 1)
                                ),
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Icon(Icons.location_on_outlined, size: 20),
                                    Text('13.5 mi'),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              Text('Estimate Time', style: TextStyle(fontSize: 10)),
                              Container(
                                width: (MediaQuery.of(context).size.width - 30) / 2 - 10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    border: Border.all(color: Colors.black54, width: 1)
                                ),
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Icon(Icons.location_on_outlined, size: 20),
                                    Text('13.5 mi'),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(width: 10),
                        Icon(Icons.monetization_on, size: 30),
                        SizedBox(width: 10),
                        Text('Estimated Price:'),
                        Spacer(),
                        Text('\$525.00', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: AppColors.darkBlue)),
                        SizedBox(width: 10)]),
                    SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 0.5),
                            color: Colors.black38,
                            width: double.infinity,
                            height: 2,
                          ),
                          Container(
                            color: AppColors.green,
                            width: 150,
                            height: 3,
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: (MediaQuery.of(context).size.width - 30) / 2 - 10,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(primary: AppColors.green),
                                  onPressed: () {

                                  },
                                  child: Text('DETAILS'),
                                )
                            ),
                            Container(
                                width: (MediaQuery.of(context).size.width - 30) / 2 - 10,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(primary: AppColors.darkBlue),
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
                            target: LatLng(40.71839071308001, -74.22127424602945),
                            zoom: 15
                        ),
                        onMapCreated: (controller){

                        },
                      ),
                    )
                  ]),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
              child: ClipOval(child: StsImgView(image: Assets.NELSON_IMG, width: 80, height: 80)))
        ],
      ),
    );
  }
}