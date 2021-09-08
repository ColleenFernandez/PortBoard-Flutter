import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class StsImgView extends StatefulWidget{

  static final int LOCAL_IMG = 102;

  late dynamic image;

  StsImgView({required this.image});

  @override
  _StsImgViewState createState() => _StsImgViewState();
}

class _StsImgViewState extends State<StsImgView> {
  @override
  Widget build(BuildContext context) {

    if (widget.image is AssetImage){

      AssetImage image = widget.image as AssetImage;

      return ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          child: Image(
              image: image,
              width: MediaQuery.of(context).size.width,
              height: 220, fit: BoxFit.cover));
    }

    Asset image = widget.image as Asset;
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      child: AssetThumb(
          asset: image,
          width: MediaQuery.of(context).size.width.round(),
          height: 250),
    );
  }
}