import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/colors.dart';
import '../../utils/images.dart';
import '../../utils/strings.dart';

@immutable
class AppImageView extends StatelessWidget {
  const AppImageView(
      {this.avatarUrl,
      double width = 100,
      double height = 100,
      double borderWidth = 0.0,
      Color borderColor = Colors.transparent,
      this.cornerRadius = 50,
      this.placeholderHeight = 100,
      this.placeholderWidth = 100,
      this.initialsText = '',
      this.isVideoThumbnail = false,
      this.placeholderImage = Images.imagePlaceholder,
      this.selectedImage,
      Color backgroundColor = AppColors.transparent,
      BoxFit fit = BoxFit.cover,
      Function()? onTapped,
      this.placeholderFit = BoxFit.cover,
      this.videoPreviewButtonHeight,
      super.key})
      : _backgroundColor = backgroundColor,
        _width = width,
        _height = height,
        _borderWidth = borderWidth,
        _borderColor = borderColor,
        _onTapped = onTapped,
        _fit = fit;
  final String? avatarUrl;
  final double? _width;
  final double _height;
  final double _borderWidth;
  final Color _borderColor;
  final Color _backgroundColor;
  final String placeholderImage;
  final double placeholderHeight;
  final double placeholderWidth;
  final String initialsText;
  final double cornerRadius;
  final BoxFit _fit;
  final BoxFit placeholderFit;
  final bool isVideoThumbnail;
  final double? videoPreviewButtonHeight;
  final XFile? selectedImage;
  final Function()? _onTapped;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onTapped,
      child: SizedBox(
        height: _height,
        width: _width,
        child: DecoratedBox(
          decoration: BoxDecoration(
              border: Border.all(color: _borderColor, width: _borderWidth),
              borderRadius: BorderRadius.circular(cornerRadius),
              color: _backgroundColor),
          child: ClipRRect(
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.circular(cornerRadius),
              child: Stack(children: [
                _imageFromRemote(context),
                if (isVideoThumbnail)
                  ColoredBox(
                    color: AppColors.black.withValues(alpha: 0.3),
                    child: Center(
                        child: SizedBox(
                      width: videoPreviewButtonHeight ?? (_height * 0.5),
                      height: videoPreviewButtonHeight ?? (_height * 0.5),
                      child: Icon(
                        Icons.play_circle_outline,
                        size: videoPreviewButtonHeight ?? (_height * 0.5),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )),
                  )
              ])),
        ),
      ),
    );
  }

  Widget _imageFromRemote(BuildContext context) {
    return (avatarUrl == null && selectedImage == null)
        ? _placeholderImageView(context)
        : Stack(children: [
            selectedImage == null
                ? FadeInImage(
                    width: _width,
                    height: _height,
                    image: CachedNetworkImageProvider(avatarUrl!,
                        cacheKey: avatarUrl!),
                    imageErrorBuilder: (context, error, stackTrace) {
                      return _placeholderImageView(context);
                    },
                    placeholder: AssetImage(placeholderImage),
                    placeholderFit: placeholderFit,
                    fit: _fit)
                : Image.file(
                    File(selectedImage!.path),
                    width: _width,
                    height: _height,
                    fit: BoxFit.cover,
                  ),
          ]);
  }

  Widget _placeholderImageView(BuildContext context) {
    return initialsText.isEmpty
        ? Center(
            child: Image(
              alignment: Alignment.topCenter,
              width: placeholderWidth,
              height: placeholderHeight,
              image: AssetImage(placeholderImage),
              fit: placeholderFit,
            ),
          )
        : _getInitalView(context);
  }

  Widget _getInitalView(BuildContext context) {
    return Container(
        height: _height,
        width: _height,
        color: AppColors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: FittedBox(
            fit: BoxFit.fitHeight,
            child: Text(
              initialsText.initials,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w300),
            ),
          ),
        ));
  }
}
