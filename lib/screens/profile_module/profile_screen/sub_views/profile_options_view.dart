import 'package:echowater/base/app_specific_widgets/app_boxed_container.dart';
import 'package:echowater/base/constants/string_constants.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/domain_models/profile_option.dart';
import 'package:flutter/material.dart';

class ProfileOptionsView extends StatelessWidget {
  const ProfileOptionsView({required this.onItemClick, super.key});

  final Function(ProfileOption) onItemClick;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 60,
          width: MediaQuery.of(context).size.width,
          child: AppBoxedContainer(
              borderSides: const [],
              child: Container(
                margin: const EdgeInsets.only(left: 20),
                child: AppBoxedContainer(
                  borderSides: const [AppBorderSide.bottom],
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'ProfileScreen_Settings'.localized,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontFamily: StringConstants.fieldGothicTestFont),
                    ),
                  ),
                ),
              )),
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final items = ProfileOption.options();
            final item = items[index];
            return InkWell(
              onTap: () {
                onItemClick.call(item);
              },
              child: SizedBox(
                height: 50,
                child: AppBoxedContainer(
                    borderSides: const [],
                    child: Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: AppBoxedContainer(
                        borderSides: const [AppBorderSide.bottom],
                        child: Row(
                          children: [
                            SizedBox(width: 30, child: Center(child: item.getIcon(context))),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                                child: Text(
                              item.title,
                              style: Theme.of(context).textTheme.labelLarge,
                            ))
                          ],
                        ),
                      ),
                    )),
              ),
            );
          },
          itemCount: ProfileOption.options().length,
        ),
      ],
    );
  }
}
