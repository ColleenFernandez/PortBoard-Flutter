import 'dart:async';

import 'package:driver/assets/AppColors.dart';
import 'package:driver/common/Common.dart';
import 'package:driver/model/JobModel.dart';
import 'package:driver/utils/log_utils.dart';
import 'package:driver/utils/Utils.dart';
import 'package:fdottedline/fdottedline.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GotoPortPage extends StatefulWidget{

  JobModel? model;

  GotoPortPage(@required this.model);

  @override
  State<GotoPortPage> createState() => _GotoPortPageState();
}

class _GotoPortPageState extends State<GotoPortPage> {

  LatLng _center = LatLng(Common.myLat, Common.myLng);

  final controller = Completer<GoogleMapController>();
  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
    LogUtils.log('pickup Location ====>${widget.model!.pickupLocation}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        elevation: 1,
        title: Text('Goto Port Terminal', style: TextStyle(color: Colors.white, fontSize: 25),),
      ),
      body: Stack(
        children: [
          GoogleMap(
              zoomControlsEnabled: false,
              zoomGesturesEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition:  CameraPosition(target: _center, zoom: 17), //getCameraPosition(),
              onMapCreated: (gcontroller) {
                controller.complete(gcontroller);
                setState(() {
                  mapController = gcontroller;
                });}),
          Positioned(
            bottom: 0,
              child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
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
                  ],
                ),
              ))
        ],
      ),
    );
  }
}