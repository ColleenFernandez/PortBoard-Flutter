import 'package:driver/assets/AppColors.dart';
import 'package:driver/common/Common.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/utils/log_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TempPage extends StatefulWidget {
  @override
  State<TempPage> createState() => _TempPageState();
}

class _TempPageState extends State<TempPage> {

  GoogleMapController? mapController;
  double pikcupLat = 33.7220017, pickupLng = -118.2530701;
  double desLat = 33.73825600001, desLng = -118.2618601;
  // double _originLatitude = 26.48424, _originLongitude = 50.04551;
  // double _destLatitude = 26.46423, _destLongitude = 50.06358;

  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  String googleAPiKey = 'AIzaSyBOOl2m6uh4H6INt4wWUI5PJXXBE8-QfmM';

  @override
  void initState() {
    super.initState();

    /// origin marker
    _addMarker(LatLng(pikcupLat, pickupLng), "origin",
        BitmapDescriptor.defaultMarker);

    /// destination marker
    _addMarker(LatLng(desLat, desLng), "destination",
        BitmapDescriptor.defaultMarkerWithHue(90));

    // Common.api.getRouteAPI(pikcupLat, pickupLng, desLat, desLng).then((value) {
    //   PolylinePoints polylinePoints = PolylinePoints();
    //   List<PointLatLng> result = polylinePoints.decodePolyline(value.encodedPoints);
    //   result.forEach((element) {
    //     polylineCoordinates.add(LatLng(element.latitude, element.longitude));
    //   });
    //   addPolyLine();
    // });
  }

  void addPolyLine(){
    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(polylineId: id, color: AppColors.darkBlue, points: polylineCoordinates, width: 4);
    polylines[id] = polyline;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: GoogleMap(
            initialCameraPosition: CameraPosition(
                target: LatLng(pikcupLat, pickupLng), zoom: 15),
            myLocationEnabled: true,
            tiltGesturesEnabled: true,
            compassEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            onMapCreated: _onMapCreated,
            markers: Set<Marker>.of(markers.values),
            polylines: Set<Polyline>.of(polylines.values),
          )),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
    Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }
}