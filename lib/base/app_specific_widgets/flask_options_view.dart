import 'package:echowater/base/app_specific_widgets/app_boxed_container.dart';
import 'package:echowater/base/common_widgets/buttons/normal_button_text.dart';
import 'package:echowater/base/constants/string_constants.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/domain_models/flask_option.dart';
import 'package:flutter/material.dart';

class FlaskOptionView extends StatelessWidget {
  const FlaskOptionView(
      {required this.flaskOptions,
      this.onItemClick,
      this.onUnpairButtonClick,
      this.flaskName,
      super.key});
  final Function(FlaskOption)? onItemClick;
  final String? flaskName;
  final Function()? onUnpairButtonClick;
  final List<FlaskOption> flaskOptions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
        child: SingleChildScrollView(
          child: ColoredBox(
            color: Theme.of(context).colorScheme.secondary,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  color: Theme.of(context).colorScheme.tertiary,
                  height: 6,
                  width: 50,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(flaskName ?? '',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontFamily: StringConstants.fieldGothicTestFont,
                        fontWeight: FontWeight.w600)),
                const SizedBox(
                  height: 30,
                ),
                ListView.builder(
                    itemCount: flaskOptions.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          onItemClick?.call(flaskOptions[index]);
                        },
                        child: AppBoxedContainer(
                            backgroundColor: Colors.transparent,
                            child: SizedBox(
                              height: 70,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  children: [
                                    if (flaskOptions[index]
                                            .icon(context: context) !=
                                        null)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: flaskOptions[index]
                                            .icon(context: context),
                                      ),
                                    Text(
                                      flaskOptions[index].title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                              fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ),
                              ),
                            )),
                      );
                    }),
                const SizedBox(
                  height: 30,
                ),
                NormalTextButton(
                  textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.error),
                  title: 'Unpair'.localized,
                  onClick: () {
                    onUnpairButtonClick?.call();
                  },
                  textColor: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
