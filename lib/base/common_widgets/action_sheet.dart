import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/colors.dart';
import 'buttons/app_button.dart';

class ActionSheet extends StatelessWidget {
  const ActionSheet(
      {required this.title, required this.actionItems, super.key});
  final String title;
  final List<Widget> actionItems;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                                  title.localized,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.quicksand(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryElementColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: List.generate(actionItems.length, (index) {
                            return Column(
                              children: [
                                SizedBox(
                                  height: 0.5,
                                  child:
                                      Container(color: AppColors.primaryLight),
                                ),
                                actionItems[index]
                              ],
                            );
                          }),
                        )
                      ]),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                AppButton(
                    radius: 10,
                    height: 45,
                    title: 'Cancel'.localized,
                    textColor: Theme.of(context).primaryColor,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    onClick: () {
                      Navigator.pop(context);
                    })
              ])
            ],
          ),
        ),
      ),
    );
  }
}
