import 'dart:async';
import 'dart:io';

import 'package:driver/assets/AppColors.dart';
import 'package:driver/assets/Assets.dart';
import 'package:driver/common/APIConst.dart';
import 'package:driver/common/Common.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/model/ChassisTypeModel.dart';
import 'package:driver/model/CompanyChassisModel.dart';
import 'package:driver/model/JobModel.dart';
import 'package:driver/pages/Job/UploadJobPicPage.dart';
import 'package:driver/utils/log_utils.dart';
import 'package:driver/utils/Utils.dart';
import 'package:driver/widget/CustomMapMarker/MarkerGenerator.dart';
import 'package:driver/widget/StsImgView.dart';
import 'package:driver/widget/StsProgressHUD.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:fdottedline/fdottedline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectChassisTypePage extends StatefulWidget{

  JobModel model;

  SelectChassisTypePage(@required this.model);

  @override
  State<SelectChassisTypePage> createState() => _SelectChassisTypePageState();
}

class _SelectChassisTypePageState extends State<SelectChassisTypePage> {

  TextEditingController edtChassisNumber = TextEditingController();

  bool loading = false;
  List<ChassisTypeModel> chassisList = [];
  List<CompanyChassisModel> companyChassisList = [];
  String selectedChassis = 'Select', selectedCompanyChassis = 'Select';

  @override
  void initState() {
    super.initState();

    getChassisType();
  }

  void saveChassisInfo(){
    showProgress();
    Common.api.saveChassisInfo(widget.model.id.toString(), selectedChassis, selectedCompanyChassis, edtChassisNumber.text, widget.model.chassisPic).then((value) {
      closeProgress();

      if (value == APIConst.SUCCESS){
        showToast('Chassis information saved');
      }else {
        showToast(value);
      }
    }).onError((error, stackTrace) {
      closeProgress();
      showToast('saveChassisInfo API error');
    });
  }

  void getChassisType() async{
    showProgress();
    Common.api.getChassisType().then((value) {

      closeProgress();

      if (value is String){
        showToast(value);
      }else {
        chassisList.addAll(value['chassisList']);
        companyChassisList.addAll(value['companyChassisList']);
        setState(() {});
      }

    }).onError((error, stackTrace) {
      closeProgress();
      LogUtils.log('getChassisType ====> ${error.toString()}');
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(body: StsProgressHUD(context, _buildWidget(context), loading));
  }

  @override
  Widget _buildWidget(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.darkBlue,
          elevation: 1,
          title: Text('Goto Port Terminal', style: TextStyle(color: Colors.white, fontSize: 25),),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 20),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Column(
                children: [
                  Container(
                    width: double.infinity,
                      padding: EdgeInsets.only(top: 50, bottom: 10), margin: EdgeInsets.only(top: 35),
                      decoration: BoxDecoration(
                          color: AppColors.green,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5))
                      ),
                    child: Column(
                      children: [
                        Text(widget.model.brokerDetail.firstName + ' ' + widget.model.brokerDetail.lastName, style: TextStyle(color: Colors.white, fontSize: 18),),
                        RatingBar.builder(ignoreGestures: true, initialRating: 4, minRating: 1, allowHalfRating: true, itemCount: 5, itemSize: 20,
                            itemPadding: EdgeInsets.symmetric(horizontal: 3),
                            itemBuilder: (context, _) => Icon(Icons.star, color: Colors.white),
                            onRatingUpdate: (rating) {}),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5))
                    ),
                    child: Column(
                      children: [
                        Stack(
                            children: [
                              Container(margin: EdgeInsets.only(top: 0.5), color: Colors.black12, width: double.infinity, height: 2),
                              Container(color: AppColors.green, width: 50, height: 3)]),
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
                                  Text(Utils.limitStrLength(widget.model.pickupLocation, 45), style: TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.bold)),
                                  SizedBox(height: 20),
                                  Container(width: MediaQuery.of(context).size.width - 90, height: 1, color: Colors.black12),
                                  SizedBox(height: 20),
                                  Text(Utils.limitStrLength(widget.model.desLocation, 45), style: TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.bold), maxLines: 1)
                                ]),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined, size: 20, color: AppColors.darkBlue,),
                            SizedBox(width: 10,),
                            Text('Distace: '),
                            Spacer(),
                            Text(widget.model.distance + ' mi'),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Icon(Icons.schedule_outlined, size: 20, color: AppColors.darkBlue,),
                            SizedBox(width: 10,),
                            Text('Estimate Time: '),
                            Spacer(),
                            Text(widget.model.duration),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Icon(Icons.local_fire_department_outlined, size: 20, color: AppColors.darkBlue,),
                            SizedBox(width: 10,),
                            Text('Fuel Gallons: '),
                            Spacer(),
                            Text(widget.model.fuelGallons),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Icon(Icons.handyman_outlined, size: 20, color: AppColors.darkBlue,),
                            SizedBox(width: 10,),
                            Text('Tolls Roads: '),
                            Spacer(),
                            Text(widget.model.fuelGallons),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Icon(Icons.monetization_on, size: 25, color: AppColors.darkBlue,),
                            SizedBox(width: 10,),
                            Text('Estimate Price: ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                            Spacer(),
                            Text('\$' + widget.model.finalPrice, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Stack(
                            children: [
                              Container(margin: EdgeInsets.only(top: 0.5), color: Colors.black12, width: double.infinity, height: 2),
                              Container(color: AppColors.green, width: 80, height: 3)]),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(primary: AppColors.darkBlue),
                                onPressed: () {

                                },child: Container(
                                  margin: EdgeInsets.only(left: 40, right: 40),
                                  child: Text('Port Terminal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),),
                              ),
                            ),
                            Container(
                              width: 50, height: 50,
                              decoration: BoxDecoration(
                                color: AppColors.darkBlue,
                                borderRadius: BorderRadius.all(Radius.circular(7))
                              ),
                              child: IconButton(
                                onPressed: () {

                                }, icon: Icon(Icons.forum, color: Colors.white, size: 35,),
                              )
                            ),
                            Container(
                                width: 50, height: 50,
                                decoration: BoxDecoration(
                                    color: AppColors.green,
                                    borderRadius: BorderRadius.all(Radius.circular(7))
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    if (edtChassisNumber.text.isEmpty) {
                                      showToast('Please input Chassis number');
                                      return;
                                    }
                                    Common.chassisNumber = edtChassisNumber.text;
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => UploadJobPicPage('Upload Chassis Picture', widget.model, 2))).then((value) {
                                      if (value == null) return;
                                      String picUrl = value as String;
                                      widget.model.chassisPic = picUrl;
                                      LogUtils.log('picUrl ==> ${picUrl}');
                                    });
                                  }, icon: Column(
                                    children: [
                                      Icon(Icons.file_upload_outlined, color: Colors.white, size: 22,),
                                      Text('UPLOAD', style: TextStyle(fontSize: 10, color: Colors.white),)
                                    ],
                                  ),
                                )
                            )
                          ],
                        ),
                        SizedBox(height: 10,),
                        Stack(
                            children: [
                              Container(margin: EdgeInsets.only(top: 0.5), color: Colors.black12, width: double.infinity, height: 2),
                              Container(color: AppColors.green, width: 30, height: 3)]),
                        SizedBox(height: 20),
                        Image(image: AssetImage('assets/images/container.png'), width: 200,),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 2 - 35,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Chassis Type'),
                                  SizedBox(height: 5),
                                  Container(
                                    height: 45,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black26),
                                        borderRadius: BorderRadius.all(Radius.circular(5))),
                                    child: Row(
                                      children: [
                                        Container(
                                            padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 20),
                                            child: Text(selectedChassis)),
                                        Spacer(),
                                        PopupMenuButton(
                                          onSelected: (value) {
                                            setState(() {
                                              selectedChassis = value as String;
                                            });
                                          },
                                          itemBuilder: (context) {
                                            return List.generate(chassisList.length, (index) {
                                              return PopupMenuItem(
                                                  value: chassisList[index].type,
                                                  child: Text(chassisList[index].type)
                                              );
                                            });},
                                          child: Icon(Icons.keyboard_arrow_down_outlined),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 - 35,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Company Chassis'),
                                  SizedBox(height: 5),
                                  Container(
                                    height: 45,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black26),
                                        borderRadius: BorderRadius.all(Radius.circular(5))),
                                    child: Row(
                                      children: [
                                        Container(
                                            padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 20),
                                            child: Text(Utils.limitStrLength(selectedCompanyChassis, 12))),
                                        Spacer(),
                                        PopupMenuButton(
                                          onSelected: (value) {
                                            setState(() {
                                              selectedCompanyChassis = value as String;
                                            });
                                          },
                                          itemBuilder: (context) {
                                            return List.generate(companyChassisList.length, (index) {
                                              return PopupMenuItem(
                                                  value: companyChassisList[index].companyChassis,
                                                  child: Text(companyChassisList[index].companyChassis)
                                              );
                                            });},
                                          child: Icon(Icons.keyboard_arrow_down_outlined),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                        ],),
                        SizedBox(height: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Chassis Number'),
                            SizedBox(height: 5,),
                            TextField(
                              controller: edtChassisNumber,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 10, right: 10)
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Stack(
                            children: [
                              Container(margin: EdgeInsets.only(top: 0.5), color: Colors.black12, width: double.infinity, height: 2),
                              Container(color: AppColors.green, width: 70, height: 3)]),
                        SizedBox(height: 20),
                        Container(
                          width: double.infinity, height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(primary: AppColors.green),
                            onPressed: () {
                              if (selectedChassis == 'Select'){
                                showToast('Please select chassis type');
                                return;
                              }

                              if (selectedCompanyChassis == 'Select'){
                                showToast('Please select company chassis');
                                return;
                              }

                              if (edtChassisNumber.text.isEmpty){
                                showToast('Please input chassis number');
                                return;
                              }

                              saveChassisInfo();

                            }, child: Text('SAVE CHASSIS INFORMATION'),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              ClipOval(child: StsImgView(image: widget.model.brokerDetail.avatar, width: 75, height: 75,),),
            ],
          ),
        )
      ),
    );
  }

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