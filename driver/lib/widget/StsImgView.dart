import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class StsImgView extends StatefulWidget{

  static final int LOCAL_IMG = 102;

  late dynamic image;
  late double width;
  late double height;


  StsImgView({required this.image, required this.width, required this.height});

  @override
  _StsImgViewState createState() => _StsImgViewState();
}

class _StsImgViewState extends State<StsImgView> {
  @override
  Widget build(BuildContext context) {

    double width = widget.width;
    double height = widget.height;

    if (widget.image is AssetImage){

      AssetImage image = widget.image as AssetImage;

      return ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          child: Image(
              image: image,
              width: width,
              height: height, fit: BoxFit.cover));
    }

    Asset image = widget.image as Asset;
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      child: AssetThumb(
          asset: image,
          width: width.toInt(),
          height: height.toInt()),
    );
  }
}