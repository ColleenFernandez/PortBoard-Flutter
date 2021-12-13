import 'package:driver/assets/AppColors.dart';
import 'package:driver/assets/Assets.dart';
import 'package:driver/common/Common.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/pages/account/SelectColorPage.dart';
import 'package:driver/pages/account/SelectMakePage.dart';
import 'package:driver/pages/account/SelectTruckModelPage.dart';
import 'package:driver/pages/account/SelectYearPage.dart';
import 'package:driver/utils/Utils.dart';
import 'package:driver/widget/StsImgView.dart';
import 'package:driver/widget/StsProgressHUD.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class SubmitTruckInfoPage extends StatefulWidget {
  @override
  State<SubmitTruckInfoPage> createState() => _SubmitTruckInfoPageState();
}

class _SubmitTruckInfoPageState extends State<SubmitTruckInfoPage> {

  TextEditingController edtIdentificationNumber = new TextEditingController();
  TextEditingController edtPlateNumber = new TextEditingController();
  String year = '', make = '', truckModel = '', color = '';
  late dynamic frontPic = Assets.DEFAULT_IMG;
  bool isEditable = true, loading = false;

  @override
  void initState() {
    super.initState();

    if (Common.userModel.truckInformationModel.vehiculeIDNumber.isNotEmpty){
      loadData();
    }
  }

  void loadData(){
    if (Common.userModel.truckRegistrationModel.status == Constants.PENDING || Common.userModel.truckRegistrationModel.status == Constants.ACCEPT){
      isEditable = false;
    }else {
      isEditable = true;
    }
  }

  bool isValid(){
    return true;
  }

  Future<void> loadPicture() async {
    List<Asset> resultList = [];
    try {
      resultList = await MultiImagePicker.pickImages(
          maxImages: 1,
          enableCamera: true,
          selectedAssets: [],
          materialOptions: MaterialOptions(
              useDetailsView: false,
              autoCloseOnSelectionLimit: true
          ));
    } on Exception catch(e) {
      showToast(e.toString());
    }

    if (!mounted) return;
    if (resultList == null) return;
    if (resultList.isEmpty) return;

    final croppedFile = await cropImage(resultList[0]);
    if (croppedFile == null) return;

    setState(() {
      frontPic = croppedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(body: StsProgressHUD(context, _buildWidget(context), loading));
  }

  @override
  Widget _buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        elevation: 1,
        title: Row(
          children: [
            Text('Truck Information'),
            Spacer(),
            Container(
                padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.white
                ), child: Text(Utils.getStatus(Common.userModel.truckInformationModel.status), style: TextStyle(color: AppColors.darkBlue),))
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Vehicule Indentification Number'),
            TextField(controller: edtIdentificationNumber,),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2 - 40,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Plate Number', style: TextStyle(color: AppColors.darkBlue)),
                      TextField(
                        controller: edtPlateNumber,
                      )
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2 - 40,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Year', style: TextStyle(color: AppColors.darkBlue)),
                      Column(
                        children: [
                          SizedBox(height: 9,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(year),
                              InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => SelectYearPage())).then((value) {
                                      if (value == null) return;
                                      setState(() {
                                        year = value as String;
                                      });
                                    });
                                  }, child: Icon(Icons.keyboard_arrow_down)),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 15),
                            width: double.infinity, height: 1,
                            color: Colors.grey,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 3 - 30,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Make', style: TextStyle(color: AppColors.darkBlue)),
                      Column(
                        children: [
                          SizedBox(height: 9,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(make),
                              InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => SelectMakePage())).then((value) {
                                      if (value == null) return;
                                      setState(() {
                                        make = value as String;
                                      });
                                    });
                                  }, child: Icon(Icons.keyboard_arrow_down)),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 15),
                            width: double.infinity, height: 1,
                            color: Colors.grey,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 3 - 30,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Model', style: TextStyle(color: AppColors.darkBlue)),
                      Column(
                        children: [
                          SizedBox(height: 9,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(truckModel),
                              InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => SelectTruckModelPage())).then((value) {
                                      if (value == null) return;
                                      setState(() {
                                        truckModel = value as String;
                                      });
                                    });
                                  }, child: Icon(Icons.keyboard_arrow_down)),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 15),
                            width: double.infinity, height: 1,
                            color: Colors.grey,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 3 - 30,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Color', style: TextStyle(color: AppColors.darkBlue)),
                      Column(
                        children: [
                          SizedBox(height: 9,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(color),
                              InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => SelectColorPage())).then((value) {
                                      if (value == null) return;
                                      setState(() {
                                        color = value as String;
                                      });
                                    });
                                  }, child: Icon(Icons.keyboard_arrow_down)),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 15),
                            width: double.infinity, height: 1,
                            color: Colors.grey,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 30,),
            Text('Front Photo'),
            SizedBox(height: 10,),
            Stack(
              children: [
                StsImgView(image: frontPic, width: MediaQuery.of(context).size.width, height: 250,),
                Positioned(right: 0, bottom: 0,
                    child: FloatingActionButton(
                        mini: true,
                        heroTag: 'SubmitTruckRegPage-FAB-1',
                        backgroundColor: Colors.white,
                        onPressed: () {
                          loadPicture();
                        }, child: Icon(Icons.camera_alt, color: AppColors.green)))
              ],
            ),
            Visibility(
              visible: Common.userModel.truckRegistrationModel.state != Constants.ACCEPT,
              child: Container(
                width: double.infinity, height: 45,
                margin: EdgeInsets.only(top: 30),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: isEditable ? AppColors.green : Colors.black26),
                  onPressed: () {
                    if (isEditable){
                      if (isValid()){

                      }
                    }
                  }, child: Text('SAVE'), ),
              ),
            )
          ],
        ),
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