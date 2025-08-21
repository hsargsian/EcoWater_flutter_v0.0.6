import 'dart:io';

import 'package:echowater/base/common_widgets/loader/loader.dart';
import 'package:echowater/core/domain/domain_models/flask_domain.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import '../../core/domain/domain_models/flask_firmware_version_domain.dart';
import '../utils/colors.dart';
import '../utils/images.dart';
import 'buttons/app_button.dart';
import 'image_widgets/app_image_view.dart';

class UpgradeFirmwareDialog extends StatefulWidget {
  const UpgradeFirmwareDialog(
      {required this.firmware,
      required this.flask,
      required this.openUpgradeScreen,
      super.key});
  final FlaskFirmwareVersionDomain firmware;
  final FlaskDomain flask;
  final void Function(
          String? blePath, String? mcuPath, List<String>? imageLibraryPaths)
      openUpgradeScreen;

  @override
  State<UpgradeFirmwareDialog> createState() => _UpgradeFirmwareDialogState();
}

class _UpgradeFirmwareDialogState extends State<UpgradeFirmwareDialog> {
  bool _isDownloadingFirmware = false;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Material(
        color: AppColors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Center(
              child: Container(
                width: double.maxFinite,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).dialogBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .primaryElementColor
                              .withValues(alpha: 0.2),
                          spreadRadius: 2,
                          blurRadius: 2)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Center(
                      child: AppImageView(
                        placeholderImage: Images.sampleWaterBottlePngImage,
                        placeholderWidth: 120,
                        cornerRadius: 0,
                        placeholderFit: BoxFit.contain,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        'Upgrade Firmware',
                        textAlign: TextAlign.start,
                        style: GoogleFonts.quicksand(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context)
                                .colorScheme
                                .primaryElementColor),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(widget.flask.name,
                            style: GoogleFonts.quicksand(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryElementColor))),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                            'There is a new upgradable firmware version available. Please update to get the best experience.',
                            style: GoogleFonts.quicksand(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryElementColor))),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(child: Container()),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: _isDownloadingFirmware
                                ? const Center(child: Loader())
                                : AppButton(
                                    title: 'Upgrade',
                                    height: 35,
                                    onClick: () {
                                      _onUpgradeButtonClick();
                                    },
                                    elevation: 0,
                                  ))
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _initiateUpgradeProcess() async {
    setState(() {
      _isDownloadingFirmware = true;
    });
    if (widget.firmware.blePath == null) {
      await _initiateMCUDownloadProcess(null);
    } else {
      final blePath = await DefaultCacheManager()
          .getFileFromCache(widget.firmware.blePath!);
      if (blePath == null) {
        final file =
            await DefaultCacheManager().getSingleFile(widget.firmware.blePath!);

        final uri = Uri.parse(widget.firmware.blePath!);
        final originalFileName = uri.pathSegments.last;

        // Get app's temp directory
        final directory = await getTemporaryDirectory();
        final newFilePath = path.join(directory.path, originalFileName);

        // Rename/move the file
        final newFile = File(newFilePath);
        await file.copy(newFilePath);
        await _initiateMCUDownloadProcess(newFile.path);
      } else {
        await _initiateMCUDownloadProcess(blePath.file.path);
      }
    }
  }

  Future<void> _initiateMCUDownloadProcess(String? blePath) async {
    String? mcuPath;
    if (widget.firmware.mcuPath == null) {
      await _initiateImageBinDownloadProcess(blePath, null);
    } else {
      final downloadedMCUBin = await DefaultCacheManager()
          .getFileFromCache(widget.firmware.mcuPath!);

      if (downloadedMCUBin == null) {
        final file =
            await DefaultCacheManager().getSingleFile(widget.firmware.mcuPath!);

        final uri = Uri.parse(widget.firmware.mcuPath!);
        final originalFileName = uri.pathSegments.last;

        // Get app's temp directory
        final directory = await getTemporaryDirectory();
        final newFilePath = path.join(directory.path, originalFileName);

        // Rename/move the file
        final newFile = File(newFilePath);
        await file.copy(newFilePath);
        mcuPath = newFile.path;
      } else {
        mcuPath = downloadedMCUBin.file.path;
      }
      await _initiateImageBinDownloadProcess(blePath, mcuPath);
    }
  }

  Future<void> _onUpgradeButtonClick() async {
    if (!_isDownloadingFirmware) {
      setState(() {
        _isDownloadingFirmware = true;
      });
      await DefaultCacheManager().emptyCache();
      await _initiateUpgradeProcess();
    }
  }

  Future<void> _initiateImageBinDownloadProcess(
      String? blePath, String? mcuPath) async {
    final imagePaths = <String>[];
    if (widget.firmware.imagePath != null) {
      for (final singleImagePath in (widget.firmware.imagePath ?? [])) {
        final downloadedImageBin =
            await DefaultCacheManager().getFileFromCache(singleImagePath);
        if (downloadedImageBin == null) {
          final file =
              await DefaultCacheManager().getSingleFile(singleImagePath);

          final uri = Uri.parse(singleImagePath);
          final originalFileName = uri.pathSegments.last;

          // Get app's temp directory
          final directory = await getTemporaryDirectory();
          final newFilePath = path.join(directory.path, originalFileName);

          // Rename/move the file
          final newFile = File(newFilePath);
          await file.copy(newFilePath);
          imagePaths.add(newFile.path);
        } else {
          imagePaths.add(downloadedImageBin.file.path);
        }
      }
      setState(() {
        _isDownloadingFirmware = false;
      });
      widget.openUpgradeScreen(
          blePath, mcuPath, imagePaths.isEmpty ? null : imagePaths);
    }
  }
}
