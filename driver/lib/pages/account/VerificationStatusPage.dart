import 'package:driver/adapter/VerificationAdapter.dart';
import 'package:driver/assets/AppColors.dart';
import 'package:driver/common/APIConst.dart';
import 'package:driver/common/Common.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/model/VerificationModel.dart';
import 'package:driver/pages/account/AlcoholDrugTestDetailPage.dart';
import 'package:driver/pages/account/BusinessCertificateDetailPage.dart';
import 'package:driver/pages/account/BusinessEINDetailPage.dart';
import 'package:driver/pages/account/DriverLicenseDetailPage.dart';
import 'package:driver/pages/account/DriverPhotoPage.dart';
import 'package:driver/pages/account/MedicalCardDetailPage.dart';
import 'package:driver/pages/account/PaymentDetailPage.dart';
import 'package:driver/pages/account/SealinkCaradDetailPage.dart';
import 'package:driver/pages/account/SubmitAlcoholDrugTestPage.dart';
import 'package:driver/pages/account/SubmitBusinessCertificatePage.dart';
import 'package:driver/pages/account/SubmitBusinessEINPage.dart';
import 'package:driver/pages/account/SubmitDriverLicensePage.dart';
import 'package:driver/pages/account/SubmitDriverPhotoPage.dart';
import 'package:driver/pages/account/SubmitMedicalCardPage.dart';
import 'package:driver/pages/account/SubmitPaymentDetailPage.dart';
import 'package:driver/pages/account/SubmitSealinkCardPage.dart';
import 'package:driver/pages/account/SubmitTwicCardPage.dart';
import 'package:driver/pages/account/TwicCardDetailPage.dart';
import 'package:driver/utils/Utils.dart';
import 'package:driver/utils/log_utils.dart';
import 'package:driver/widget/StsProgressHUD.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class VerificationStatusPage extends StatefulWidget {
  @override
  _VerificationStatusPageState createState() => _VerificationStatusPageState();
}

class _VerificationStatusPageState extends State<VerificationStatusPage> {

  bool loading = false;
  List<VerificationModel> allData = [];

  @override
  void initState() {
    super.initState();

    FBroadcast.instance().register(Constants.DRIVER_LICENSE_REJECTED, (value, callback) {
      Common.userModel.driverLicenseModel.status = Constants.REJECT;
      refreshUserDetail();
    });

    FBroadcast.instance().register(Constants.TWIC_CARD_REJECTED, (value, callback) {
      Common.userModel.twicCardModel.status = Constants.REJECT;
      refreshUserDetail();
    });

    FBroadcast.instance().register(Constants.SEALINK_CARD_REJECTED, (value, callback) {
      Common.userModel.seaLinkCardModel.status = Constants.REJECT;
      refreshUserDetail();
    });

    FBroadcast.instance().register(Constants.MEDICAL_CARD_REJECTED, (value, callback) {
      Common.userModel.medicalCardModel.status = Constants.REJECT;
      refreshUserDetail();
    });

    FBroadcast.instance().register(Constants.BUSINESS_CERTIFICATE_REJECTED, (value, callback) {
      Common.userModel.businessCertificateModel.status = Constants.REJECT;
      refreshUserDetail();
    });

    FBroadcast.instance().register(Constants.BUSINESS_EIN_REJECTED, (value, callback) {
      Common.userModel.businessEINModel.status = Constants.REJECT;
      refreshUserDetail();
    });

    FBroadcast.instance().register(Constants.PAYMENT_DETAIL_REJECTED, (value, callback) {
      Common.userModel.paymentDetailModel.status = Constants.REJECT;
      refreshUserDetail();
    });

    FBroadcast.instance().register(Constants.ALCOHOL_DRUG_TEST_REJECTED, (value, callback) {
      Common.userModel.alcoholDrugTestModel.status = Constants.REJECT;
      refreshUserDetail();
    });

    FBroadcast.instance().register(Constants.DRIVER_PHOTO_REJECTED, (value, callback) {
      Common.userModel.driverPhotoModel.status = Constants.REJECT;
      refreshUserDetail();
    });

    FBroadcast.instance().register(Constants.DRIVER_LICENSE_APPROVED, (value, callback) {
      Common.userModel.driverLicenseModel.status = Constants.ACCEPT;
      getVerificationData();
      setState(() {});
    });

    FBroadcast.instance().register(Constants.TWIC_CARD_APPROVED, (value, callback) {
      Common.userModel.twicCardModel.status = Constants.ACCEPT;
      getVerificationData();
      setState(() {});
    });

    FBroadcast.instance().register(Constants.SEALINK_CARD_APPROVED, (value, callback) {
      Common.userModel.seaLinkCardModel.status = Constants.ACCEPT;
      getVerificationData();
      setState(() {});
    });

    FBroadcast.instance().register(Constants.MEDICAL_CARD_APPROVED, (value, callback) {
      Common.userModel.medicalCardModel.status = Constants.ACCEPT;
      getVerificationData();
      setState(() {});
    });

    FBroadcast.instance().register(Constants.BUSINESS_CERTIFICATE_APPROVED, (value, callback) {
      Common.userModel.businessCertificateModel.status = Constants.ACCEPT;
      getVerificationData();
      setState(() {});
    });

    FBroadcast.instance().register(Constants.BUSINESS_EIN_APPROVED, (value, callback) {
      Common.userModel.businessEINModel.status = Constants.ACCEPT;
      getVerificationData();
      setState(() {});
    });

    FBroadcast.instance().register(Constants.PAYMENT_DETAIL_APPROVED, (value, callback) {
      Common.userModel.paymentDetailModel.status = Constants.ACCEPT;
      getVerificationData();
      setState(() {});
    });

    FBroadcast.instance().register(Constants.ALCOHOL_DRUG_TEST_APPROVED, (value, callback) {
      Common.userModel.alcoholDrugTestModel.status = Constants.ACCEPT;
      getVerificationData();
      setState(() {});
    });

    FBroadcast.instance().register(Constants.DRIVER_PHOTO_APPROVED, (value, callback) {
      Common.userModel.driverPhotoModel.status = Constants.ACCEPT;
      getVerificationData();
      setState(() {});
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

    VerificationModel driverLicense = new VerificationModel();
    driverLicense.documentName = Constants.DRIVER_LICENSE;
    if (Common.userModel.driverLicenseModel.driverLicense.isNotEmpty){
      driverLicense.status = Common.userModel.driverLicenseModel.status;
      driverLicense.expireDate = Utils.getDate(Common.userModel.driverLicenseModel.expirationDate);
      driverLicense.reason = Common.userModel.driverLicenseModel.reason;
    }else {
      driverLicense.status = Constants.NOT_SUBMITTED;
    }
    allData.add(driverLicense);

    VerificationModel twicCard = new VerificationModel();
    twicCard.documentName = Constants.TWIC_CARD;
    if (Common.userModel.twicCardModel.cardNumber.isNotEmpty){
      twicCard.status = Common.userModel.twicCardModel.status;
      twicCard.expireDate = Utils.getDate(Common.userModel.twicCardModel.expirationDate);
      twicCard.reason = Common.userModel.twicCardModel.reason;
    }else {
      twicCard.status = Constants.NOT_SUBMITTED;
    }
    allData.add(twicCard);

    VerificationModel seaLinkCard = new VerificationModel();
    seaLinkCard.documentName = Constants.SEALINK_CARD;
    if (Common.userModel.seaLinkCardModel.cardNumber.isNotEmpty) {
      seaLinkCard.status = Common.userModel.seaLinkCardModel.status;
      seaLinkCard.expireDate = Utils.getDate(Common.userModel.seaLinkCardModel.expirationDate);
      seaLinkCard.reason = Common.userModel.seaLinkCardModel.reason;
    }else {
      seaLinkCard.status = Constants.NOT_SUBMITTED;
    }
    allData.add(seaLinkCard);

    VerificationModel medicalCard = new VerificationModel();
    medicalCard.documentName = Constants.MEDICAL_CARD;
    if (Common.userModel.medicalCardModel.expirationDate > 0){
      medicalCard.status = Common.userModel.medicalCardModel.status;
      medicalCard.expireDate = Utils.getDate(Common.userModel.medicalCardModel.expirationDate);
      medicalCard.reason = Common.userModel.medicalCardModel.reason;
    }else {
      medicalCard.status = Constants.NOT_SUBMITTED;
    }
    allData.add(medicalCard);

    VerificationModel businessCertificate = new VerificationModel();
    businessCertificate.documentName = Constants.BUSINESS_CERTIFICATE;
    if (Common.userModel.businessCertificateModel.legalName.isNotEmpty){
      businessCertificate.status = Common.userModel.businessCertificateModel.status;
    }else {
      businessCertificate.status = Constants.NOT_SUBMITTED;
    }
    allData.add(businessCertificate);

    VerificationModel businessEIN = new VerificationModel();
    businessEIN.documentName = Constants.BUSINESS_EIN_NUMBER;
    if (Common.userModel.businessEINModel.einNumber.isNotEmpty){
      businessEIN.status = Common.userModel.businessEINModel.status;
    }else {
      businessEIN.status = Constants.NOT_SUBMITTED;
    }
    allData.add(businessEIN);

    VerificationModel paymentDetail = new VerificationModel();
    paymentDetail.documentName = Constants.PAYMENT_DETAILS;
    if (Common.userModel.paymentDetailModel.accountNumber.isNotEmpty){
      paymentDetail.status = Common.userModel.paymentDetailModel.status;
    }else {
      paymentDetail.status = Constants.NOT_SUBMITTED;
    }
    allData.add(paymentDetail);

    VerificationModel alcoholDrug = new VerificationModel();
    alcoholDrug.documentName = Constants.ALCOHOL_DRUG_TEST;
    if (Common.userModel.alcoholDrugTestModel.frontPic.isNotEmpty){
      alcoholDrug.status = Common.userModel.alcoholDrugTestModel.status;
    }else {
      alcoholDrug.status = Constants.NOT_SUBMITTED;
    }
    allData.add(alcoholDrug);

    VerificationModel driverPhoto = new VerificationModel();
    driverPhoto.documentName = Constants.DRIVER_PHOTO;
    if (Common.userModel.driverPhotoModel.photo.isNotEmpty){
      driverPhoto.status = Common.userModel.driverPhotoModel.status;
    }else {
      driverPhoto.status = Constants.NOT_SUBMITTED;
    }
    allData.add(driverPhoto);
  }

  @override
  void dispose() {
    super.dispose();
    FBroadcast.instance().unregister(context);
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
          backgroundColor: AppColors.darkBlue,
          title: Text('Verification Status', style: TextStyle(color: Colors.white, fontSize: 16)),
          elevation: 2,
          iconTheme: IconThemeData(color: Colors.white)),
      body: Container(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            Icon(Icons.person, size: 120, color: AppColors.green,),
            Text('Driver Registration', style: TextStyle(fontSize: 25, color: AppColors.darkBlue),),
            SizedBox(height: 15),
            Stack(
                children: [
                  Container(margin: EdgeInsets.only(top: 0.5), color: Colors.black12, width: double.infinity, height: 2),
                  Container(color: AppColors.green, width: 30, height: 3)]),
            SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final model = allData[index];
                    return InkWell(
                      onTap: () {
                        if (model.documentName == Constants.DRIVER_LICENSE) {
                          if (model.status == Constants.NOT_SUBMITTED){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SubmitDriverLicensePage()));
                          }else {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => DriverLicenseDetailPage()));
                          }
                        }

                        if (model.documentName == Constants.TWIC_CARD){
                          if (model.status == Constants.NOT_SUBMITTED){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SubmitTwicCardPage()));
                          }else {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => TwicCardDetailPage()));
                          }
                        }

                        if (model.documentName == Constants.SEALINK_CARD){
                          if (model.status == Constants.NOT_SUBMITTED){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SubmitSealinkCardPage()));
                          }else {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SealinkCaradDetailPage()));
                          }
                        }

                        if (model.documentName == Constants.MEDICAL_CARD){
                          if (model.status == Constants.NOT_SUBMITTED){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SubmitMedicalCardPage()));
                          }else {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MedicalCardDetailPage()));
                          }
                        }

                        if (model.documentName == Constants.BUSINESS_CERTIFICATE){
                          if (model.status == Constants.NOT_SUBMITTED){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SubmitBusinessCertificatePage()));
                          }else {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => BusinessCertificateDetailPage()));
                          }
                        }

                        if (model.documentName == Constants.BUSINESS_EIN_NUMBER){
                          if (model.status == Constants.NOT_SUBMITTED){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SubmitBusinessEINPage()));
                          }else {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => BusinessEINDetailPage()));
                          }
                        }

                        if (model.documentName == Constants.PAYMENT_DETAILS) {
                          if (model.status == Constants.NOT_SUBMITTED){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SubmitPaymentDetailPage()));
                          }else {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentDetailPage()));
                          }
                        }

                        if (model.documentName == Constants.ALCOHOL_DRUG_TEST){
                          if (model.status == Constants.NOT_SUBMITTED){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SubmitAlcoholDrugTestPage()));
                          }else {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AlcoholDrugTestDetailPage()));
                          }
                        }

                        if (model.documentName == Constants.DRIVER_PHOTO){
                          if (model.status == Constants.NOT_SUBMITTED){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SubmitDriverPhotoPage()));
                          }else {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => DriverPhotoPage()));
                          }
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
                  itemCount: allData.length),
            ),
            SizedBox(height: 15),
            Stack(
                children: [
                  Container(margin: EdgeInsets.only(top: 0.5), color: Colors.black12, width: double.infinity, height: 2),
                  Container(color: AppColors.green, width: 30, height: 3)]),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Note', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 15)),
                  SizedBox(width: 10),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('To prevent inconvenients, make sure your documents:', style: TextStyle(color: Colors.black54, fontSize: 13)),
                      Text('- Are not blurry / are current (no expired)', style: TextStyle(color: Colors.black54, fontSize: 13)),
                      Text('- Includes all four corners of the card.', style: TextStyle(color: Colors.black54, fontSize: 13))
                    ],
                  ))
                ],
              ),
            ),
          ],
        ),
      )
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