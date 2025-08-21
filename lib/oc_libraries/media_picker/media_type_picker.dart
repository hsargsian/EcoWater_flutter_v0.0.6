import 'package:flutter/material.dart';

import '../../base/common_widgets/buttons/app_button.dart';
import 'media_picker_config.dart';
import 'media_type.dart';

@immutable
class MediaTypePicker extends StatelessWidget {
  const MediaTypePicker(
      {required this.types,
      required this.onTypeSelected,
      required this.config,
      super.key});
  final Function(MediaType type) onTypeSelected;
  final List<MediaType> types;
  final MediaPickerConfig config;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black.withValues(alpha: 0.3),
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(),
                ClipRRect(
                  clipBehavior: Clip.hardEdge,
                  borderRadius: BorderRadius.circular(20),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Choose type',
                                    textAlign: TextAlign.center,
                                    style: config.textStyle?.copyWith(
                                            fontWeight: FontWeight.bold) ??
                                        (Theme.of(context)
                                                .textTheme
                                                .labelSmall ??
                                            TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                              children: types.map((e) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: AppButton(
                                  title: e.typeTitle,
                                  textColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  elevation: 0,
                                  radius: 0,
                                  onClick: () {
                                    onTypeSelected.call(e);
                                  }),
                            );
                          }).toList())
                        ]),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  AppButton(
                      title: 'Cancel',
                      height: 60,
                      textColor: Theme.of(context).colorScheme.primary,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      onClick: () {
                        Navigator.pop(context);
                      })
                ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
