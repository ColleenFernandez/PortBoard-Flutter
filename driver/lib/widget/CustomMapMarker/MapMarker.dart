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
  Widget build(BuildContext context) {
    return Container(

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: ShapeDecoration(
              color: Colors.black87,
              shape: TooltipShapeBorder(arrowArc: 0.5),
              shadows: [
                BoxShadow(
                    color: Colors.black26, blurRadius: 4.0, offset: Offset(2, 2))
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('\$${widget.location.name}', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
