import 'package:driver/assets/AppColors.dart';
import 'package:driver/common/API.dart';
import 'package:driver/common/APIConst.dart';
import 'package:driver/common/Common.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/model/JobModel.dart';
import 'package:driver/utils/log_utils.dart';
import 'package:driver/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    progressDialog = ProgressDialog(context);
    progressDialog.style(progressWidget: Container(padding: EdgeInsets.all(13), child: CircularProgressIndicator(color: AppColors.green)));

    getAllJobs();
  }

  void getAllJobs() {
    progressDialog.show();
    api.getAllProjects().then((value) {
      progressDialog.hide();
      if (value is String){
        showToast(value);
      }else {
        allData.addAll(value);
        setState(() {
          if (mapController != null){
            mapController.moveCamera(CameraUpdate.newCameraPosition(
                CameraPosition(target: LatLng(allData[0].latitude, allData[0].longitude), zoom: 12)));
          }
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
        child: Column(
          children: [
            Container(
              height: 200,
              color: AppColors.darkBlue,
            ),
            ListTile(
              leading: Icon(Icons.fact_check_outlined, color: Colors.black),
              title: Text('Verification Status', style: TextStyle(color: Colors.black)),
              trailing: Icon(Icons.error_outline_outlined, color: Colors.red),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, '/VerificationStatusPage');

              },
            )
          ],
        )
      ),
      body: GoogleMap(
        zoomGesturesEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: getCameraPosition(),
        markers: getMarkers(),
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
          position: LatLng(element.latitude, element.longitude)
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