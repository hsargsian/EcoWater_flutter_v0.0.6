import 'package:echowater/core/domain/domain_models/user_domain.dart';
import 'package:flutter/material.dart';

import '../../../base/utils/app_styles.dart';
import '../../../base/utils/colors.dart';
import '../../../base/utils/utilities.dart';
import '../../../core/services/walkthrough_manager/walk_through_manager.dart';
import 'tab_contents.dart';

class EchoWaterBottomNavigationBar extends StatefulWidget {
  const EchoWaterBottomNavigationBar(
      {required this.tabs, required this.currentIndex, required this.onTabClicked, required this.user, super.key});

  final List<DashboardPageItem> tabs;
  final int currentIndex;
  final UserDomain? user;
  final Function(DashboardTabs)? onTabClicked;

  @override
  State<EchoWaterBottomNavigationBar> createState() => _EchoWaterBottomNavigationBarState();
}

class _EchoWaterBottomNavigationBarState extends State<EchoWaterBottomNavigationBar> {
  @override
  void initState() {
    super.initState();
    WalkThroughManager().onNotifyFooter = () {
      setState(() {});
    };
    WalkThroughManager().switchTabScreen = (tab) {
      WalkThroughManager().currentTab = tab;
      widget.onTabClicked?.call(tab);
    };
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(border: Border(top: AppStyles.borderside()), boxShadow: [
            BoxShadow(
                offset: const Offset(0, -2),
                spreadRadius: 1,
                blurRadius: 1,
                color: AppColors.bottomsheetBarrierColor.withValues(alpha: 0.05)),
          ]),
          height: 90,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: widget.tabs.map((e) {
                final isActive = widget.currentIndex == e.tab.itemIndex;
                return GestureDetector(
                  onTap: () {
                    Utilities.vibrate();
                    WalkThroughManager().currentTab = e.tab;
                    widget.onTabClicked?.call(e.tab);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isActive ? e.tab.activeIcon(context, widget.user) : e.tab.icon(widget.user),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        e.tab.label,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w400,
                            color: isActive ? Theme.of(context).primaryColor : AppColors.colorB3B3B3),
                      )
                    ],
                  ),
                );
              }).toList()),
        ),
        Visibility(
            visible: WalkThroughManager().isShowingWalkThrough,
            child: Positioned.fill(
                child: Container(
              color: Colors.black.withValues(alpha: 0.5),
            ))),
      ],
    );
  }
}
