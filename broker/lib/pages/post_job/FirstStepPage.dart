import 'dart:async';

import 'package:driver/assets/AppColors.dart';
import 'package:driver/assets/Assets.dart';
import 'package:driver/common/APIConst.dart';
import 'package:driver/common/Common.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/model/GoodsTypeModel.dart';
import 'package:driver/model/JobModel.dart';
import 'package:driver/model/LoadDescriptionModel.dart';
import 'package:driver/model/PortLoadingModel.dart';
import 'package:driver/model/PortModel.dart';
import 'package:driver/model/SteamshipLineModel.dart';
import 'package:driver/model/TollGuruModel.dart';
import 'package:driver/model/VesselModel.dart';
import 'package:driver/utils/log_utils.dart';
import 'package:driver/utils/utils.dart';
import 'package:fdottedline/fdottedline.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

class FirstStepPage extends StatefulWidget {
  @override
  State<FirstStepPage> createState() => _FirstStepPageState();
}

class _FirstStepPageState extends State<FirstStepPage> {

  late final ProgressDialog progressDialog;

  TextEditingController edtRefName = new TextEditingController();
  TextEditingController edtBillOfLoading = new TextEditingController();
  TextEditingController edtPurchaseOrder = new TextEditingController();
  TextEditingController edtContainerNumber = new TextEditingController();
  TextEditingController edtQuantity = new TextEditingController();
  TextEditingController edtSealNumber = new TextEditingController();
  TextEditingController edtBooking = new TextEditingController();

  String portName = 'Select port terminal';
  String selectedDestination = 'Select Destination';
  List<PortModel> portList = [];
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};
  final controller = Completer<GoogleMapController>();
  GoogleMapController? mapController;
  PortModel selectedPort = new PortModel();
  final List<String> grossWeightList = Utils.grossWeightList();
  final int pickup = 101, dropOff = 102;
  bool isTollGuruAPICalling = false;

  String distance = '', estimateTime = '', fuelGallons = '', fuelCost = '', tollRates = '', finalPrice = '';
  Map<MarkerId, Marker> markers = {};
  Set<Circle> circles = Set();
  final String port = 'port', destination = 'destination';
  late BitmapDescriptor truckMarkerIcon, warehouseMarkerIcon;
  String mpg = '', fuelPrice = '', desLat = '', desLng = '', toState = '';


  String pickupDate = 'Select', dropOffDate = 'Select', pickupTime = 'Select', dropOffTime = 'Select',
      steamShipLine = 'Select', portOfLoading = 'Select',
      vesselName = 'Select', containerType = 'Select', grossWeight = 'Select',
      goodsType = 'Select',
      loadDescription = 'Select';

  @override
  void initState() {
    super.initState();

    progressDialog = ProgressDialog(context);
    progressDialog.style(progressWidget: Container(padding: EdgeInsets.all(13), child: CircularProgressIndicator(color: AppColors.lightBlue)));

    Utils.customMarker(Assets.IC_TRUCK_START_PATH).then((value) {
      truckMarkerIcon = value;
    });
    Utils.customMarker(Assets.IC_WAREHOUSE_MARKER).then((value) {
      warehouseMarkerIcon = value;
    });
  }

  void postJob(){

    JobModel model = new JobModel();
    model.pickupLat = selectedPort.lat;
    model.pickupLng = selectedPort.lng;
    model.desLat = desLat;
    model.desLng = desLng;
    model.pickupLocation = selectedPort.address;
    model.fromState = selectedPort.state;
    model.desLocation = selectedDestination;
    model.toState = toState;
    model.distance = distance;
    model.duration = estimateTime;
    model.fuelGallons = fuelGallons;
    model.tollsRates = tollRates;
    model.fuelSurcharge = '0.00';
    model.fuelCost = fuelCost;
    model.finalPrice = finalPrice;
    model.pickupDate = pickupDate;
    model.dropOffDate = dropOffDate;
    model.pickupTime = pickupTime;
    model.dropOffTime = dropOffTime;
    model.steamshipLine = steamShipLine;
    model.portLoading = portOfLoading;
    model.vesselName = vesselName;
    model.refNumber = edtRefName.text;
    model.billOfLoading = edtBillOfLoading.text;
    model.purchaseOrder = edtPurchaseOrder.text;

    model.containerNumber = edtContainerNumber.text;
    model.containerType = containerType;
    model.grossWeight = grossWeight;
    model.goodsType = goodsType;
    model.quantity = edtQuantity.text;
    model.loadDescription = loadDescription;
    model.sealNumber = edtSealNumber.text;
    model.booking = edtBooking.text;
    model.portName = portName;

    showProgress();
    Common.api.postJob(model).then((value) {
      closeProgress();
      if (value != APIConst.SUCCESS){
        showToast(value);
      }else {
        Navigator.pop(context);
      }
    }).onError((error, stackTrace) {
      closeProgress();
      showToast(APIConst.NETWORK_ERROR);
    });
  }

  bool isValid(){

    if (distance.isEmpty) {
      showAlertDialog(context, 'Please select port terminal and destination');
      return false;
    }

    if (pickupDate == Constants.SELECT){
      showAlertDialog(context, 'Please select pickup date');
      return false;
    }

    if (dropOffDate == Constants.SELECT){
      showAlertDialog(context, 'Please select drop off Date');
      return false;
    }

    if (pickupTime == Constants.SELECT){
      showAlertDialog(context, 'Please select pickup time');
      return false;
    }

    if (dropOffTime == Constants.SELECT){
      showAlertDialog(context, 'Please select drop off time');
      return false;
    }

    if (steamShipLine == Constants.SELECT){
      showAlertDialog(context, 'Please select steamship line');
      return false;
    }

    if (portOfLoading == Constants.SELECT){
      showAlertDialog(context, 'Please select port of loading');
      return false;
    }

    if (vesselName == Constants.SELECT){
      showAlertDialog(context, 'Please select vessel name');
      return false;
    }

    if (edtRefName.text.isEmpty){
      showAlertDialog(context, 'Please input reference number');
      return false;
    }

    if (edtBillOfLoading.text.isEmpty){
      showAlertDialog(context, 'Please input bill of loading');
      return false;
    }

    if (edtPurchaseOrder.text.isEmpty){
      showAlertDialog(context, 'Please input purchase order');
      return false;
    }

    if (edtContainerNumber.text.isEmpty){
      showAlertDialog(context, 'Please input container number');
      return false;
    }

    if (containerType == Constants.SELECT){
      showAlertDialog(context, 'Please select container type');
      return false;
    }

    if (grossWeight == Constants.SELECT){
      showAlertDialog(context, 'Please select gross weight');
      return false;
    }

    if (goodsType == Constants.SELECT){
      showAlertDialog(context, 'Please select goods type');
      return false;
    }

    if (edtQuantity.text.isEmpty){
      showAlertDialog(context, 'Please input quantity');
      return false;
    }

    if (loadDescription == Constants.SELECT){
      showAlertDialog(context, 'Please select load description');
      return false;
    }

    if (edtSealNumber.text.isEmpty){
      showAlertDialog(context, 'Please input seal number');
      return false;
    }

    if (edtBooking.text.isEmpty){
      showAlertDialog(context, 'Please input booking');
      return false;
    }

    return true;
  }

  Future<void> getAddress() async {
    Prediction? p = await PlacesAutocomplete.show(
      offset: 0, radius: 1000,  types: [], strictbounds: false,
      context: context,
      apiKey: Constants.googleAPIKey,
      mode: Mode.overlay,
      language: "us",
      decoration: InputDecoration(
        hintText: 'Search',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      components: [Component(Component.country, "us")],
    ).onError((error, stackTrace) {
      LogUtils.log(error.toString());
    });

    displayPrediction(p!);
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: Constants.googleAPIKey,
        apiHeaders: await GoogleApiHeaders().getHeaders(),
      );

      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId!);

      final desLat = detail.result.geometry!.location.lat;
      final desLng = detail.result.geometry!.location.lng;

      this.desLat = desLat.toString();
      this.desLng = desLng.toString();

      selectedDestination = detail.result.formattedAddress!;

      detail.result.addressComponents.forEach((element) {
        element.types.forEach((e) {
          if (e == 'administrative_area_level_1'){
            this.toState = element.shortName;
          }
        });
      });

      addMarker(LatLng(desLat, desLng), destination, warehouseMarkerIcon);
      getRoute(double.parse(selectedPort.lat), double.parse(selectedPort.lng), desLat, desLng, selectedDestination);
    }
  }

  void getRoute(double pickupLat, double pickupLng, double desLat, double desLng, String selectDestination){
    setState(() {isTollGuruAPICalling = true;});
    Common.api.getRouteAPI(pickupLat, pickupLng, desLat, desLng).then((value) {
      PolylinePoints polylinePoints = PolylinePoints();
      List<PointLatLng> result = polylinePoints.decodePolyline(value);
      result.forEach((element) {
        polylineCoordinates.add(LatLng(element.latitude, element.longitude));
      });
      addPolyLine();
      callTollGuruAPI(selectDestination);
    });
  }

  void callTollGuruAPI(String destination) async {

    Common.api.callTollGuruAPI(selectedPort.address, selectedPort.state, destination, selectedPort.zipCode).then((value) {

      isTollGuruAPICalling = false;

      if (value is String){
        showToast(value);
      }else {
        final tollGuru = value as TollGuruModel;
        distance = tollGuru.distance;
        estimateTime = tollGuru.duration;
        fuelGallons = tollGuru.gallons;
        tollRates = '0.00';
        fuelCost = tollGuru.fuelCosts;
        finalPrice = tollGuru.finalPrice;
      }

      setState(() {});

    }).onError((error, stackTrace) {
      setState(() {isTollGuruAPICalling = false;});
      LogUtils.log(error.toString());
    });
  }

  void addPolyLine(){
    polylines.clear();
    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(polylineId: id, color: AppColors.darkBlue, points: polylineCoordinates, width: 4);
    polylines[id] = polyline;
    setState(() {});
  }

  void addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    markers.removeWhere((key, marker) => marker.markerId.value == id);
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;

    if (id != port){
      circles.removeWhere((element) => element.circleId.value == id);
      circles.add(new Circle(
          circleId: CircleId(id),
          radius: 400,
          center: position,
          fillColor: AppColors.red_t_50,
          strokeColor: Colors.transparent,
          onTap: () {}
      ));
    }

    mapController!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: position,
        zoom: 13)));
  }

  showPickupDropOffDatePicker(int key) async{
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 2));

    if (pickup == null) return;

    if (key == pickup){
      pickupDate = DateFormat('yyyy-MM-dd').format(picked!);
    }
    if (key == dropOff){
      dropOffDate = DateFormat('yyyy-MM-dd').format(picked!);
    }

    setState(() {});
  }

  showPickupDropOffTimePicker(int key) async {
    TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now());
    if (picked == null) return;
    if (key == pickup) {
      pickupTime = picked.format(context);
    }
    if (key == dropOff){
      dropOffTime = picked.format(context);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(left: 10, right: 10, top: 100),
                padding: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 5, blurRadius: 15, offset: Offset(0, 2))]
                ),
                child: Material(
                  child: Column (
                    children: [
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 15),
                          InkWell(
                            onTap: () {

                            }, child: Image(image: Assets.IC_PORT_CRANE, width: 50, height: 50,)),

                          InkWell(
                              onTap: () {

                              }, child: Image(image: Assets.IC_YELLOW_CONTAINER, width: 50, height: 50,)),

                          InkWell(
                              onTap: () {

                              }, child: Image(image: Assets.IC_RED_CURVE, width: 50, height: 50,)),

                          InkWell(
                              onTap: () {

                              }, child: Image(image: Assets.IC_BLUE_SNOW, width: 50, height: 50,)),

                          InkWell(
                              onTap: () {

                              }, child: Image(image: Assets.IC_NAVY_BLUE_CLEAN, width: 50, height: 50,)),

                          InkWell(
                              onTap: () {

                              }, child: Image(image: Assets.IC_GREEN_CLEAN, width: 50, height: 50,)),
                          SizedBox(width: 15),
                        ],
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 10, right: 10, top: 15),
                          child: Stack(
                              children: [
                                Container(margin: EdgeInsets.only(top: 0.5), color: Colors.black12, width: double.infinity, height: 2),
                                Container(color: AppColors.lightBlue, width: 30, height: 3)])),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(width: 10),
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
                                        color: AppColors.lightBlue))
                              ]),
                          SizedBox(width: 20),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(context, '/SelectPortTerminalPage').then((value) {

                                          if (value == null) return;
                                          final temp = value as Map<String, dynamic>;
                                          selectedPort = temp[Constants.PORT_MODEL];
                                          mpg = temp[APIConst.mpg];
                                          fuelPrice = temp[APIConst.fuelPrice];
                                          selectedPort.address = temp[APIConst.address];
                                          selectedPort.zipCode = temp[APIConst.zipcode];

                                          portName = selectedPort.name;
                                          addMarker(LatLng(double.parse(selectedPort.lat), double.parse(selectedPort.lng)), port, truckMarkerIcon);
                                          setState(() {});
                                        });
                                      },
                                      child: Container(
                                        height: 30,
                                        child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(Utils.adjustedString30(portName))),
                                        width: MediaQuery.of(context).size.width - 130,
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: BoxConstraints(),
                                        onPressed: () {
                                          setState(() {

                                          });
                                        },
                                        icon: Icon(Icons.close)
                                    )
                                  ],
                                ),
                                SizedBox(height: 15),
                                Container(width: MediaQuery.of(context).size.width - 90, height: 1, color: Colors.black12),
                                SizedBox(height: 15),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (selectedPort.name.isEmpty){
                                          showToast('Please select port terminal, first');
                                          return;
                                        }
                                        getAddress();
                                      },
                                      child: Container(
                                        height: 30,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                            child: Text(Utils.adjustedString30(selectedDestination))),
                                        width: MediaQuery.of(context).size.width - 130,
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: BoxConstraints(),
                                        onPressed: () {

                                        },
                                        icon: Icon(Icons.close)
                                    )
                                  ],
                                ),
                              ]),
                          SizedBox(width: 10)],
                      ),
                      Container(width: double.infinity, height: 1, margin: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 5), color: Colors.black12),
                      Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(bottom: 10),
                            height: 230,
                            child: GoogleMap(
                              circles: circles,
                              markers: Set<Marker>.of(markers.values),
                              zoomControlsEnabled: true,
                              zoomGesturesEnabled: true, mapType: MapType.normal,
                              initialCameraPosition: CameraPosition(
                                  target: LatLng(Common.myLat, Common.myLng),
                                  zoom: 16
                              ),
                              onMapCreated: (gcontroller) {
                                controller.complete(gcontroller);
                                mapController = gcontroller;
                              },
                              polylines: Set<Polyline>.of(polylines.values),
                              gestureRecognizers: < Factory < OneSequenceGestureRecognizer >> [
                                new Factory < OneSequenceGestureRecognizer > (
                                      () => new EagerGestureRecognizer(),
                                ),
                              ].toSet(),
                            ),
                          ),
                          Visibility(
                            visible: isTollGuruAPICalling,
                            child: Container(
                              width: double.infinity,
                              height: 230,
                              color: Colors.black26,
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.transparent,
                                    color: AppColors.darkBlue,
                                    strokeWidth: 3,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('DISTANCE: '),
                          Text('${distance} / ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                          Text('TIME: '),
                          Text(estimateTime, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('FUEL GALLONS: '),
                          Text('${fuelGallons} / ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                          Text('TOLLS RATES: '),
                          Text('\$${tollRates}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('FUEL SURCHARGE: '),
                          Text('0.00% / ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                          Text('FUEL COSTS: '),
                          Text('\$${fuelCost}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)
                        ],
                      ),
                      Container (
                        width: double.infinity,
                        height: 70,
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: AppColors.lightBlue,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column (
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('MON, JUL 1', style: TextStyle(color: Colors.white, fontSize: 18),),
                                Text('00:00 AM', style: TextStyle(color: Colors.white)),
                                Text('0 days chassis', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            Text('\$${finalPrice}', style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),)
                          ],),),
                      SizedBox(height: 15,),
                      Divider(),
                      SizedBox(height: 10,),
                      Text('Terminal Information', style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5,),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2 - 25,
                            margin: EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Pickup Date'),
                                SizedBox(height: 5),
                                Container(
                                  height: 47,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black26),
                                      borderRadius: BorderRadius.all(Radius.circular(5))),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 5),
                                      Icon(Icons.calendar_today, size: 20,),
                                      SizedBox(width: 5),
                                      InkWell(
                                        onTap: (){
                                          showPickupDropOffDatePicker(pickup);
                                        },
                                        child: Container(
                                            padding: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 20),
                                            child: Text(pickupDate)),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2 - 25,
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('DropOff Date'),
                                SizedBox(height: 5),
                                Container(
                                  height: 47,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black26),
                                      borderRadius: BorderRadius.all(Radius.circular(5))),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 5),
                                      Icon(Icons.calendar_today, size: 20,),
                                      SizedBox(width: 5),
                                      InkWell(
                                        onTap: (){
                                          showPickupDropOffDatePicker(dropOff);
                                        },
                                        child: Container(
                                            padding: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 20),
                                            child: Text(dropOffDate)),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2 - 25,
                            margin: EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Pickup Time'),
                                SizedBox(height: 5),
                                Container(
                                  height: 47,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black26),
                                      borderRadius: BorderRadius.all(Radius.circular(5))),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 5),
                                      Icon(Icons.calendar_today, size: 20,),
                                      SizedBox(width: 5),
                                      InkWell(
                                        onTap: (){
                                          showPickupDropOffTimePicker(pickup);
                                        },
                                        child: Container(
                                            padding: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 20),
                                            child: Text(pickupTime)),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2 - 25,
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('DropOff Time'),
                                SizedBox(height: 5),
                                Container(
                                  height: 47,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black26),
                                      borderRadius: BorderRadius.all(Radius.circular(5))),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 5),
                                      Icon(Icons.calendar_today, size: 20,),
                                      SizedBox(width: 5),
                                      InkWell(
                                        onTap: (){
                                          showPickupDropOffTimePicker(dropOff);
                                        },
                                        child: Container(
                                            padding: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 20),
                                            child: Text(dropOffTime)),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2 - 25,
                            margin: EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Steamship Line'),
                                SizedBox(height: 5),
                                Container(
                                  height: 47,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black26),
                                      borderRadius: BorderRadius.all(Radius.circular(5))),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 5),
                                      Icon(Icons.train, size: 20),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(context, '/SelectSteamShipLinePage').then((value) {
                                            if (value == null) return;
                                            final temp = value as SteamShipLineModel;
                                            steamShipLine = temp.name;
                                            setState(() {});
                                          });
                                        }, child: Text(Utils.adjustedString17(steamShipLine), style: TextStyle(color: Colors.black87)),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2 - 25,
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Port of loading'),
                                SizedBox(height: 5),
                                Container(
                                  height: 47,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black26),
                                      borderRadius: BorderRadius.all(Radius.circular(5))),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 5),
                                      Icon(Icons.train, size: 20),
                                      TextButton(onPressed: () {
                                        Navigator.pushNamed(context, '/SelectPortLoadingPage').then((value) {
                                          if (value == null) return;
                                          final temp = value as PortLoadingModel;
                                          portOfLoading = temp.name;
                                          setState(() {});
                                        });
                                      }, child: Text(Utils.adjustedString17(portOfLoading), style: TextStyle(color: Colors.black87)))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),

                        ],),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2 - 25,
                            margin: EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Vessel Name'),
                                SizedBox(height: 5),
                                Container(
                                  height: 47,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black26),
                                      borderRadius: BorderRadius.all(Radius.circular(5))),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 5),
                                      Icon(Icons.train, size: 20),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(context, '/SelectVesselPage').then((value) {
                                            if (value == null) return;
                                            final VesselModel model = value as VesselModel;
                                            vesselName = model.name;
                                            setState(() {});
                                          });
                                        }, child: Text(Utils.adjustedString17(vesselName), style: TextStyle(color: Colors.black87, fontSize: 13)),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2 - 25,
                            margin: EdgeInsets.only(right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Reference Number'),
                                SizedBox(height: 5),
                                TextField(
                                  controller: edtRefName,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                                    prefixIconConstraints: BoxConstraints(minWidth: 30),
                                    prefixIcon: Icon(Icons.description_outlined, color: Colors.black87, size: 20,),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5)
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2 - 25,
                            margin: EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Bill of Loading'),
                                SizedBox(height: 5),
                                TextField(
                                  controller: edtBillOfLoading,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                                    prefixIconConstraints: BoxConstraints(minWidth: 30),
                                    prefixIcon: Icon(Icons.description_outlined, color: Colors.black87, size: 20,),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2 - 25,
                            margin: EdgeInsets.only(right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Purchase Order'),
                                SizedBox(height: 5),
                                TextField(
                                  controller: edtPurchaseOrder,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                                    prefixIconConstraints: BoxConstraints(minWidth: 30),
                                    prefixIcon: Icon(Icons.description_outlined, color: Colors.black87, size: 20,),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],),
                      SizedBox(height: 20,),
                      Divider(),
                      SizedBox(height: 10,),
                      Text('Container Information', style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2 - 25,
                            margin: EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Container Number'),
                                SizedBox(height: 5),
                                TextField(
                                  controller: edtContainerNumber,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.only(left: 10, right: 30),
                                      child: Image.asset(Assets.IC_BARCODE_PATH, width: 15, height: 10, fit: BoxFit.fitWidth,),),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5)
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2 - 25,
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Container Type'),
                                SizedBox(height: 5),
                                Container(
                                  height: 47,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black26),
                                      borderRadius: BorderRadius.all(Radius.circular(5))),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 10),
                                      Image(image: Assets.IC_BAR_CODE, width: 15, height: 20),
                                      TextButton(onPressed: () {
                                        Navigator.pushNamed(context, '/SelectContainerTypePage').then((value) {
                                          if (value ==  null) return;
                                          setState(() {
                                            containerType = value as String;
                                          });
                                        });
                                      }, child: Text(Utils.adjustedString17(containerType), style: TextStyle(color: Colors.black87),))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2 - 25,
                            margin: EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Gross Weight'),
                                SizedBox(height: 5),
                                Container(
                                  height: 47,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black26),
                                      borderRadius: BorderRadius.all(Radius.circular(5))),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 5),
                                      Icon(Icons.schedule, size: 20),
                                      SizedBox(width: 10),
                                      PopupMenuButton(
                                        itemBuilder: (context) {
                                          return grossWeightList.map((item) {
                                            return PopupMenuItem(child: Text(item), value: item);
                                          }).toList();
                                        },
                                        child: Row(
                                          children: [
                                            Text(Utils.adjustedString17(grossWeight), style: TextStyle(fontSize: 13),),
                                            Icon(Icons.arrow_drop_down)
                                          ],
                                        ),
                                        onSelected: (String value) {
                                          setState(() {
                                            grossWeight = value;
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2 - 25,
                            margin: EdgeInsets.only(right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Goods Type'),
                                SizedBox(height: 5),
                                Container(
                                  height: 47,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black26),
                                      borderRadius: BorderRadius.all(Radius.circular(5))),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 5),
                                      Icon(Icons.train, size: 20),
                                      TextButton(onPressed: () {
                                        Navigator.pushNamed(context, '/SelectGoodsPage').then((value) {
                                          if (value == null) return;
                                          final GoodsTypeModel temp = value as GoodsTypeModel;
                                          goodsType = temp.name;
                                          setState(() {});
                                        });
                                      }, child: Text(Utils.adjustedString17(goodsType), style: TextStyle(color: Colors.black87),))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2 - 25,
                            margin: EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Quantity'),
                                SizedBox(height: 5),
                                TextField(
                                  controller: edtQuantity,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                                    prefixIconConstraints: BoxConstraints(minWidth: 30),
                                    prefixIcon: Icon(Icons.description_outlined, color: Colors.black87, size: 20,),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2 - 25,
                            margin: EdgeInsets.only(right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Load Description'),
                                SizedBox(height: 5),
                                Container(
                                  height: 47,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black26),
                                      borderRadius: BorderRadius.all(Radius.circular(5))),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 5),
                                      Icon(Icons.train, size: 20),
                                      TextButton(onPressed: () {
                                        Navigator.pushNamed(context, '/SelectLoadDescriptionPage').then((value){
                                          if (value == null) return;
                                          final LoadDescriptionModel model = value as LoadDescriptionModel;
                                          loadDescription = model.name;
                                          setState(() {});
                                        });
                                      }, child: Text(Utils.adjustedString17(loadDescription), style: TextStyle(color: Colors.black87),))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2 - 25,
                            margin: EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Seal number'),
                                SizedBox(height: 5),
                                TextField(
                                  controller: edtSealNumber,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                                    prefixIconConstraints: BoxConstraints(minWidth: 30),
                                    prefixIcon: Icon(Icons.description_outlined, color: Colors.black87, size: 20,),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2 - 25,
                            margin: EdgeInsets.only(right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Booking'),
                                SizedBox(height: 5),
                                TextField(
                                  controller: edtBooking,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                                    prefixIconConstraints: BoxConstraints(minWidth: 30),
                                    prefixIcon: Icon(Icons.description_outlined, color: Colors.black87, size: 20,),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],),
                      SizedBox(height: 15,),
                      Divider(),
                      SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                color: AppColors.darkBlue,
                                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.7), spreadRadius: 2, blurRadius: 8, offset: Offset(0, 2))]
                            ),
                            width: MediaQuery.of(context).size.width/2 - 30,
                            height: 48,
                            margin: EdgeInsets.only(left: 10),
                            child: TextButton(
                              onPressed: () {
                              },child: Text('Clear form', style: TextStyle(color: Colors.white, fontSize: 18)),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                color: AppColors.lightBlue,
                                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.7), spreadRadius: 2, blurRadius: 8, offset: Offset(0, 2))]
                            ),
                            height: 48,
                            width: MediaQuery.of(context).size.width/2 - 30,
                            margin: EdgeInsets.only(right: 10),
                            child: TextButton(
                              onPressed: () {
                                if (isValid()){
                                  postJob();
                                }
                              },child: Text('Find a Driver', style: TextStyle(color: Colors.white, fontSize: 18)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                    ],
                  ),
                ),
              )
          ),
        ),
      ),
    );
  }

  showProgress(){
    if (!progressDialog.isShowing()){
      progressDialog.show();
    }
  }

  closeProgress(){
    if (progressDialog.isShowing()){
      progressDialog.hide();
    }
  }
}