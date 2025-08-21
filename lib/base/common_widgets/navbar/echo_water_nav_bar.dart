import 'package:flutter/material.dart';

import '../../../core/services/walkthrough_manager/walk_through_manager.dart';
import '../../utils/colors.dart';

class NavContentView extends StatefulWidget {
  NavContentView(
      {required this.child,
      this.backgroundColor,
      this.isBaseScreen = false,
      super.key});
  final Widget child;
  final Color? backgroundColor;
  bool isBaseScreen = false;
  @override
  State<NavContentView> createState() => _NavContentViewState();
}

class _NavContentViewState extends State<NavContentView> {
  @override
  void initState() {
    super.initState();
    WalkThroughManager().onNotifyHeader = () {
      if (mounted) {
        setState(() {});
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
        color: widget.backgroundColor ?? Theme.of(context).colorScheme.tertiary,
        child: Stack(
          children: [
            widget.child,
            Visibility(
                visible: WalkThroughManager().isShowingWalkThrough &&
                    widget.isBaseScreen,
                child: Positioned.fill(
                    child: Container(
                  color: AppColors.walkthroughBarrierColor,
                ))),
          ],
        ));
  }
}

class EchoWaterNavBar extends StatelessWidget implements PreferredSizeWidget {
  EchoWaterNavBar(
      {required this.child,
      this.isBaseScreen = false,
      this.backgroundColor,
      super.key});
  final Widget child;
  final Color? backgroundColor;
  bool isBaseScreen = false;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: NavContentView(
          backgroundColor: backgroundColor,
          isBaseScreen: isBaseScreen,
          child: child,
        ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
