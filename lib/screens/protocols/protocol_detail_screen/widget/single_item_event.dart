import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import '../../../../base/utils/colors.dart';

class SingleItemEvent extends StatelessWidget {
  SingleItemEvent({required this.events, super.key});

  final List<CalendarEventData<Object?>> events;
  final firstFilter = <String>['hydrate', 'hydration', 'recovery', 'drink'];
  final secondFilter = <String>['workout', 'sleep'];

  @override
  Widget build(BuildContext context) {
    var firstColor = AppColors.colorD8D8D8;
    var secondColor = AppColors.color717171Base;
    final title = events.first.title.toLowerCase();

    if (firstFilter.any(title.contains)) {
      firstColor = AppColors.primaryDark;
      secondColor = AppColors.color437986;
    } else if (secondFilter.any(title.contains)) {
      firstColor = HexColor.fromHex('#395382');
      secondColor = HexColor.fromHex('#28272C');
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: MediaQuery.sizeOf(context).width * 0.02,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
            color: firstColor,
          ),
        ),
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                color: secondColor),
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Align(alignment: Alignment.centerLeft, child: Text(events.first.title)),
            ),
          ),
        ),
      ],
    );
  }
}
