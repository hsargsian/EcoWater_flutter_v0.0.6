import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/colors.dart';
import '../buttons/image_button.dart';
import '../image_widgets/app_image_view.dart';

class ProfilePictureChangeView extends StatefulWidget {
  const ProfilePictureChangeView(
      {required this.avatarUrl,
      required this.canEditProfile,
      this.onClick,
      super.key});
  final String? avatarUrl;
  final Function()? onClick;
  final bool canEditProfile;

  @override
  State<ProfilePictureChangeView> createState() =>
      _ProfilePictureChangeViewState();
}

class _ProfilePictureChangeViewState extends State<ProfilePictureChangeView> {
  XFile? _selectedImage;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(150),
            ),
            padding: const EdgeInsets.all(5),
            child: AppImageView(
              avatarUrl: _selectedImage == null ? widget.avatarUrl : null,
              placeholderHeight: 120,
              placeholderWidth: 120,
              width: 120,
              height: 120,
              cornerRadius: 75,
              backgroundColor: AppColors.colorC4C4C4,
              selectedImage: _selectedImage,
            ),
          ),
          if (widget.canEditProfile)
            Positioned(
                top: 5,
                right: 5,
                child: ImageButton(
                    height: 30,
                    cornerRadius: 15,
                    icon: Icons.edit,
                    iconScale: 0.6,
                    iconColor:
                        Theme.of(context).colorScheme.primaryElementColor,
                    onClick: () {
                      widget.onClick?.call();
                    }))
        ],
      ),
    );
  }
}
