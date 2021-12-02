import 'package:driver/widget/StsProgressHUD.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:driver/assets/AppColors.dart';
import 'package:driver/common/APIConst.dart';
import 'package:driver/common/Common.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/pages/account/SelectStatePage.dart';
import 'package:driver/utils/log_utils.dart';
import 'package:driver/utils/Utils.dart';
class PaymentDetailPage extends StatefulWidget {
  @override
  State<PaymentDetailPage> createState() => _PaymentDetailPageState();
}

class _PaymentDetailPageState extends State<PaymentDetailPage> {
  TextEditingController edtBankName = new TextEditingController();
  TextEditingController edtAccountNumber =  new TextEditingController();
  TextEditingController edtRouting = new TextEditingController();
  TextEditingController edtPhone = new TextEditingController();
  TextEditingController edtAddress = new TextEditingController();
  TextEditingController edtCity = new TextEditingController();
  TextEditingController edtZipCode = new TextEditingController();

  String state = '';
  bool isEditable = false;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    FBroadcast.instance().register(Constants.PAYMENT_DETAIL_APPROVED, (value, callback) {
      Common.userModel.paymentDetailModel.status = Constants.ACCEPT;
      setState(() {});
    });
    loadData();
  }

  void loadData(){
    if (Common.userModel.paymentDetailModel.status == Constants.PENDING || Common.userModel.paymentDetailModel.status == Constants.ACCEPT){
      isEditable = false;
    }else {
      isEditable = true;
    }
    edtBankName.text = Common.userModel.paymentDetailModel.bankName;
    edtAccountNumber.text = Common.userModel.paymentDetailModel.accountNumber;
    edtRouting.text = Common.userModel.paymentDetailModel.routing;
    edtPhone.text = Common.userModel.paymentDetailModel.phone;
    edtAddress.text = Common.userModel.paymentDetailModel.address;
    edtCity.text = Common.userModel.paymentDetailModel.city;
    state = Common.userModel.paymentDetailModel.state;
    edtZipCode.text = Common.userModel.paymentDetailModel.zipCode;
  }

  void submitPaymentDetails() {
    showProgress();
    Common.api.submitPaymentDetails(
        Common.userModel.id,
        edtBankName.text,
        edtAccountNumber.text,
        edtRouting.text,
        edtPhone.text,
        edtAddress.text,
        edtCity.text,
        state,
        edtZipCode.text).then((value) {

      closeProgress();
      if (value == APIConst.SUCCESS) {
        showSingleButtonDialog(
            context,
            'Payment Detail Submitted!',
            'Your payment detail submitted successfully!\nAdministrator will check it and reply you as soon as possible.',
            Constants.Okay, () {
          Navigator.pop(context);
          Navigator.pop(context);
        });
      }else {
        showToast(value);
      }
    }).onError((error, stackTrace) {
      closeProgress();
      LogUtils.log('Submit Driver License API Error ====>  ${error.toString()}');
      showToast(APIConst.SERVER_ERROR);
    });
  }

  bool isValid() {
    if (edtBankName.text.isEmpty){
      showToast('Input bank name');
      return false;
    }

    if (edtAccountNumber.text.isEmpty){
      showToast('Input Account number');
      return false;
    }

    if (edtRouting.text.isEmpty){
      showToast('Input Routing');
      return false;
    }

    if (edtPhone.text.isEmpty){
      showToast('Input Phone number');
      return false;
    }

    if (edtAddress.text.isEmpty){
      showToast('Input Address');
      return false;
    }

    if (edtCity.text.isEmpty){
      showToast('Input City');
      return false;
    }

    if (state.isEmpty){
      showToast('Input State');
      return false;
    }

    if (edtZipCode.text.isEmpty){
      showToast('Input Zip code');
      return false;
    }

    return true;
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
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.darkBlue,
          title: Row(
            children: [
              Text('Payment Details'),
              Spacer(),
              Container(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.white
                  ), child: Text(Utils.getStatus(Common.userModel.paymentDetailModel.status), style: TextStyle(color: AppColors.darkBlue),))
            ],
          ),
          elevation: 1,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 20, left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: Common.userModel.paymentDetailModel.status == Constants.REJECT,
                  child: Container(
                      margin: EdgeInsets.only(top: 5, bottom: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.black12
                      ),
                      child: Text(Common.userModel.paymentDetailModel.reason, style: TextStyle(color: Colors.red),)),
                ),
                Text('Bank Name', style: TextStyle(color: AppColors.darkBlue)),
                TextField(
                  enabled: isEditable,
                  controller: edtBankName,
                  decoration: InputDecoration(
                      suffixIcon: Icon(Icons.account_balance, color: AppColors.darkBlue,)
                  ),
                ),
                SizedBox(height: 20,),
                Text('Account Number', style: TextStyle(color: AppColors.darkBlue)),
                TextField(
                  enabled: isEditable,
                  controller: edtAccountNumber,
                  decoration: InputDecoration(
                      suffixIcon: Icon(Icons.price_change, color: AppColors.darkBlue,)
                  ),
                ),
                SizedBox(height: 20,),
                Text('Routing', style: TextStyle(color: AppColors.darkBlue)),
                TextField(
                  enabled: isEditable,
                  controller: edtRouting,
                  decoration: InputDecoration(
                      suffixIcon: Icon(Icons.price_change, color: AppColors.darkBlue,)
                  ),
                ),
                SizedBox(height: 20,),
                Text('Phone number', style: TextStyle(color: AppColors.darkBlue)),
                TextField(
                  enabled: isEditable,
                  keyboardType: TextInputType.phone,
                  controller: edtPhone,
                  decoration: InputDecoration(
                      suffixIcon: Icon(Icons.phone_enabled, color: AppColors.darkBlue,)
                  ),
                ),
                SizedBox(height: 20,),
                Text('Address', style: TextStyle(color: AppColors.darkBlue)),
                TextField(
                  enabled: isEditable,
                  controller: edtAddress,
                  decoration: InputDecoration(
                      suffixIcon: Icon(Icons.location_on, color: AppColors.darkBlue,)
                  ),
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 40,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('City', style: TextStyle(color: AppColors.darkBlue)),
                          TextField(
                            enabled: isEditable,
                            controller: edtCity,
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 4 - 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('State', style: TextStyle(color: AppColors.darkBlue)),
                          Column(
                            children: [
                              SizedBox(height: 9,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(state),
                                  InkWell(
                                      onTap: () {
                                        if (isEditable){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => SelectStatePage())).then((value) {
                                            if (value == null) return;
                                            setState(() {
                                              state = value as String;
                                            });
                                          });
                                        }
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
                      width: MediaQuery.of(context).size.width / 4 - 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Zip Code', style: TextStyle(color: AppColors.darkBlue)),
                          TextField(
                            enabled: isEditable,
                            controller: edtZipCode,
                            keyboardType: TextInputType.number,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30,),
                Visibility(
                  visible: Common.userModel.paymentDetailModel.status != Constants.ACCEPT,
                  child: Container(
                    margin: EdgeInsets.only(top: 20, bottom: 30),
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: isEditable ? AppColors.green : Colors.black26),
                      onPressed: () {
                        if (isValid()){
                          submitPaymentDetails();
                        }
                      }, child: Text('SAVE'),
                    ),
                  ),
                )
              ],
            ),
          ),
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