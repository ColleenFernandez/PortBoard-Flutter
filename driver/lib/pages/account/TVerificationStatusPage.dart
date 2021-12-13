import 'package:driver/assets/AppColors.dart';
import 'package:driver/assets/Assets.dart';
import 'package:driver/common/APIConst.dart';
import 'package:driver/common/Common.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/model/VerificationModel.dart';
import 'package:driver/pages/account/SubmitEmitionInspectPage.dart';
import 'package:driver/pages/account/SubmitIFTAStickerPage.dart';
import 'package:driver/pages/account/SubmitTruckInfoPage.dart';
import 'package:driver/pages/account/SubmitTruckInsurancePage.dart';
import 'package:driver/pages/account/SubmitTruckRegPage.dart';
import 'package:driver/pages/account/TruckRegDetailPage.dart';
import 'package:driver/utils/Utils.dart';
import 'package:driver/utils/log_utils.dart';
import 'package:driver/widget/StsProgressHUD.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';

class TVerificationStatusPage extends StatefulWidget{
  @override
  State<TVerificationStatusPage> createState() => _TVerificationStatusPageState();
}

class _TVerificationStatusPageState extends State<TVerificationStatusPage> {
  bool loading = false;

  List<VerificationModel> allData = [];

  @override
  void initState() {
    super.initState();

    FBroadcast.instance().register(Constants.NOTI_DOCUMENT_VERIFY_STATUS, (value, callback) {
      refreshUserDetail();
    });

    refreshUserDetail();
  }

  void refreshUserDetail(){
    showProgress();
    Common.api.login(Common.userModel.phone).then((value) {
      closeProgress();
      if (value == APIConst.SUCCESS){
        getVerificationData();
        setState(() {});
      }
    }).onError((error, stackTrace) {
      closeProgress();
      showToast(APIConst.SERVER_ERROR);

      LogUtils.log('error ===> ${error.toString()}');
    });
  }

  void getVerificationData(){
    allData.clear();

    VerificationModel truckRegistration = new VerificationModel();
    truckRegistration.documentName = Constants.TRUCK_REGISTRATION;
    if (Common.userModel.truckRegistrationModel.companyName.isNotEmpty){
      truckRegistration.status = Common.userModel.truckRegistrationModel.status;
    }else {
      truckRegistration.status = Constants.NOT_SUBMITTED;
    }
    allData.add(truckRegistration);

    VerificationModel truckInsurance = new VerificationModel();
    truckInsurance.documentName = Constants.TRUCK_INSURANCE;
    if(Common.userModel.truckInsuranceModel.companyName.isNotEmpty){
      truckInsurance.status = Common.userModel.truckInsuranceModel.status;
    }else {
      truckInsurance.status = Constants.NOT_SUBMITTED;
    }
    allData.add(truckInsurance);

    VerificationModel iftaStickers = new VerificationModel();
    iftaStickers.documentName = Constants.IFTA_STICKERS;
    if (Common.userModel.iftaStickerModel.iftaStickerNumber.isNotEmpty){
      iftaStickers.status = Common.userModel.iftaStickerModel.status;
    }else {
      iftaStickers.status = Constants.NOT_SUBMITTED;
    }
    allData.add(iftaStickers);

    VerificationModel emitionInspection = new VerificationModel();
    emitionInspection.documentName = Constants.EMITION_INSPECTION;
    if (Common.userModel.emitionInspectionModel.ispectionNumber.isNotEmpty){
      emitionInspection.status = Common.userModel.emitionInspectionModel.status;
    }else {
      emitionInspection.status = Constants.NOT_SUBMITTED;
    }
    allData.add(emitionInspection);

    VerificationModel truckInformation = new VerificationModel();
    truckInformation.documentName = Constants.TRUCK_INFORMATION;
    if (Common.userModel.truckInformationModel.vehiculeIDNumber.isNotEmpty){
      truckInformation.status = Common.userModel.truckInformationModel.status;
    }else {
      truckInformation.status = Constants.NOT_SUBMITTED;
    }
    allData.add(truckInformation);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(body: StsProgressHUD(context, _buildWidget(context), loading));
  }

  @override
  Widget _buildWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Truck Registration'),
        elevation: 1,
        backgroundColor: AppColors.darkBlue,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 10),
        child: Column(
          children: [
            Image(image: Assets.IMG_TRUCK, height: 100,),
            SizedBox(height: 10,),
            Text('Truck Registration', style: TextStyle(color: AppColors.darkBlue, fontSize: 30),),
            SizedBox(height: 10,),
            Stack(
                children: [
                  Container(margin: EdgeInsets.only(top: 0.5), color: Colors.black12, width: double.infinity, height: 2),
                  Container(color: AppColors.green, width: 30, height: 3)]),
            SizedBox(height: 10,),
            Expanded(
                child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      VerificationModel model = allData[index];
                      return InkWell(
                        onTap: () {
                          if (model.documentName == Constants.TRUCK_REGISTRATION){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SubmitTruckRegPage())).then((value) {
                              if (value == null) return;
                              if (value ==  true){
                                refreshUserDetail();
                              }
                            });
                          }
                          if (model.documentName == Constants.TRUCK_INSURANCE){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SubmitTruckInsurancePage())).then((value) {
                              if (value == null) return;
                              if (value == true){
                                refreshUserDetail();
                              }
                            });
                          }
                          if (model.documentName == Constants.IFTA_STICKERS){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SubmitIFTAStickerPage())).then((value) {
                              if (value ==  null) return;
                              if (value == true){
                                refreshUserDetail();
                              }
                            });
                          }

                          if (model.documentName == Constants.EMITION_INSPECTION){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SubmitEmitionInspectPage())).then((value) {
                              if (value ==  null) return;
                              if (value == true){
                                refreshUserDetail();
                              }
                            });
                          }
                          if (model.documentName == Constants.TRUCK_INFORMATION){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SubmitTruckInfoPage())).then((value) {
                              if (value ==  null) return;
                              if (value == true){
                                refreshUserDetail();
                              }
                            });
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                              children: [
                                Icon(Icons.insert_drive_file_outlined, color: AppColors.darkBlue, size: 20,),
                                SizedBox(width: 10),
                                Text(model.documentName, style: TextStyle(fontSize: 20),),
                                Spacer(),
                                Icon(Icons.check_circle, color: model.status == Constants.ACCEPT ? AppColors.green : Colors.red),
                                SizedBox(width: 10),
                                Icon(Icons.keyboard_arrow_right)
                              ]),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemCount: allData.length)
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