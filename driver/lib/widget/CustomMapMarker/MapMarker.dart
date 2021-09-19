import 'package:driver/assets/AppColors.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/utils/log_utils.dart';
import 'package:driver/widget/WaterRipple/WaterRipple.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'TooltipShapeBorder.dart';
import 'locations.dart';

class MapMarker extends StatefulWidget {

  final Location location;
  MapMarker(this.location);

  @override
  State<MapMarker> createState() => _MapMarkerState();
}

class _MapMarkerState extends State<MapMarker> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                decoration: ShapeDecoration(
                  color: widget.location.bgColor,
                  shape: TooltipShapeBorder(arrowArc: 0.1),
                  shadows: [BoxShadow(color: Colors.black26, blurRadius: 1.0, offset: Offset(1, 1))],
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                  child: Text('\$${widget.location.name}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                )),
            ]
          )],
      ),
    );
  }
}
