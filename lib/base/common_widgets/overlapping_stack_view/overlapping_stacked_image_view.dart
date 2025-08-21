import 'package:flutter/material.dart';

import 'overlapping_stacked_image_configuration.dart';

class OverlappingStackedImageView extends StatelessWidget {
  OverlappingStackedImageView(
      {required this.items, required this.configuration, super.key});
  final List<String> items;
  final OverlappingStackedImageConfiguration configuration;
  List<String> _items = [];

  @override
  Widget build(BuildContext context) {
    _setUpImages();
    return Row(
      children: [
        SizedBox(
          height: configuration.itemSize,
          width: widthOfView,
          child: Stack(
            children: _getChildren(),
          ),
        ),
        Visibility(
          visible: configuration.showsMoreCountLabel,
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 15),
            child: Text(
              _remainingCountText(),
              style: configuration.labelStyle,
            ),
          ),
        )
      ],
    );
  }

  void _setUpImages() {
    if (isItemsLessThanMaxToShow) {
      _items = items.sublist(0, items.length);
      return;
    }
    _items = items.sublist(0, configuration.maxImagesToShow);
    switch (configuration.flow) {
      case OverlappingStackedImageFlow.leftToRight:
        _items = _items.reversed.toList();
        break;
      case OverlappingStackedImageFlow.rightToLeft:
        break;
    }
  }

  String _remainingCountText() {
    if (isItemsLessThanMaxToShow) {
      return '';
    }
    return '+ ${items.length - configuration.maxImagesToShow}';
  }

  bool get isItemsLessThanMaxToShow {
    return items.length < configuration.maxImagesToShow;
  }

  double get widthOfView {
    return _items.length == 1
        ? configuration.itemSize
        : (((_items.length - 1) * singleOffset) + configuration.itemSize);
  }

  // provides thge list of image views i.e. Image widgets wrapped by positioned
  //// widgets for stack view
  List<Widget> _getChildren() {
    switch (configuration.flow) {
      case OverlappingStackedImageFlow.leftToRight:
        var offset = -singleOffset;
        var index = -1;
        return _items.map((e) {
          offset += singleOffset;
          index += 1;
          return _imagePositioned(
              leftOffset: 0, rightOffset: offset, index: index);
        }).toList();

      case OverlappingStackedImageFlow.rightToLeft:
        var index = 0;
        return _items.map((e) {
          final offset = singleOffset * index;
          final item = _imagePositioned(
              leftOffset: offset,
              rightOffset: singleOffset * (_items.length - index - 1),
              index: index);
          index += 1;
          return item;
        }).toList();
    }
  }

  // returns a offset based on image size and offset percentage
  double get singleOffset {
    return configuration.itemSize * configuration.offsetPercentage;
  }

  // creates a positioned view inside stack view
  Widget _imagePositioned(
      {required double leftOffset,
      required double rightOffset,
      required int index}) {
    return Positioned(
      top: 0,
      bottom: 0,
      right: rightOffset,
      left: leftOffset,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                    color: configuration.borderColor,
                    width: configuration.itemBorderWidth)),
            child: _image(_items[index]),
          ),
        ],
      ),
    );
  }

// actual imageWidget in the stacked view
  Widget _image(String imageUrl) {
    return ClipRRect(
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.circular(50),
      child: SizedBox(
        height: configuration.itemSize -
            (configuration.itemBorderWidth *
                2.0), // multiplied by 2 as border on 2 sides
        width: configuration.itemSize -
            (configuration.itemBorderWidth *
                2.0), // multiplied by 2 as border on 2 sides
        child: ColoredBox(
          color: Colors.white,
          child: Image(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
