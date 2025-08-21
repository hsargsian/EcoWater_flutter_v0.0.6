import 'package:flutter/material.dart';

enum OverlappingStackedImageFlow { leftToRight, rightToLeft }

class OverlappingStackedImageConfiguration {
  // style of the label to show

  const OverlappingStackedImageConfiguration(
      {required this.maxImagesToShow,
      required this.itemSize,
      required this.itemBorderWidth,
      required this.borderColor,
      this.showsMoreCountLabel = true,
      this.offsetPercentage = 0.5,
      this.flow = OverlappingStackedImageFlow.rightToLeft,
      this.labelStyle = const TextStyle(color: Colors.grey, fontSize: 25)});
  final int
      maxImagesToShow; //even if 100 images provided, how many to show in  view
  final double itemSize; // size of each image view
  final double itemBorderWidth; // size of border to show around the image
  final Color borderColor; // color of border
  final bool showsMoreCountLabel; // whether to show the more count label or not
  final double
      offsetPercentage; // to what percentage of overlapping we want to do
  final OverlappingStackedImageFlow flow; // flow of the stackview
  final TextStyle labelStyle;
}
