import 'package:echowater/base/common_widgets/buttons/app_button.dart';
import 'package:echowater/base/common_widgets/image_widgets/app_image_view.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import '../utils/colors.dart';

class GoalCompletionShareView extends StatefulWidget {
  const GoalCompletionShareView(
      {required this.title, required this.image, super.key});
  final String title;
  final String image;

  @override
  State<GoalCompletionShareView> createState() =>
      _GoalCompletionShareViewState();
}

class _GoalCompletionShareViewState extends State<GoalCompletionShareView> {
  final WidgetsToImageController _controller = WidgetsToImageController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _onShareButtonClick() async {
    final box = context.findRenderObject() as RenderBox?;
    final image = await _controller.capture();
    if (image == null) {
      return;
    }

    final _ = await Share.shareXFiles(
      [
        XFile.fromData(image, mimeType: 'jpeg'),
      ],
      text: 'I ${widget.title}!',
      subject: 'SAA',
      // sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
    if (!context.mounted) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: DecoratedBox(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(offset: const Offset(0, -1), color: AppColors.color717171)
        ]),
        child: ColoredBox(
          color: Theme.of(context).colorScheme.secondary,
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
                maxWidth: MediaQuery.of(context).size.width,
                maxHeight: MediaQuery.of(context).size.height * 0.9,
                minHeight: MediaQuery.of(context).size.height * 0.9),
            child: ColoredBox(
              color: Theme.of(context).colorScheme.secondary,
              child: _mainWidgetWrapper(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _mainWidgetWrapper() {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios)),
                ),
                Expanded(
                    child: Text(
                  textAlign: TextAlign.center,
                  'Achievement'.localized,
                  style: Theme.of(context).textTheme.titleLarge,
                )),
                const SizedBox(
                  width: 50,
                ),
              ],
            )),
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WidgetsToImage(
              controller: _controller,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.70,
                height: MediaQuery.of(context).size.width * 0.70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return AppImageView(
                            height: constraints.maxWidth * 0.8,
                            width: constraints.maxWidth * 0.8,
                            cornerRadius: 8,
                            placeholderImage: widget.image,
                            placeholderHeight: constraints.maxWidth * 0.8,
                            placeholderWidth: constraints.maxWidth * 0.8,
                          );
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'You ${widget.title}!',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .displaySmall
                    ?.copyWith(fontWeight: FontWeight.w500, fontSize: 25),
              ),
            ),
          ],
        )),
        Padding(
          padding: const EdgeInsets.only(bottom: 50, left: 15, right: 15),
          child: AppButton(
            title: 'Share',
            onClick: () {
              _onShareButtonClick();
            },
            hasGradientBackground: true,
          ),
        )
      ],
    );
  }
}
