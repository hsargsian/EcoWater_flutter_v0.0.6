import 'package:echowater/base/utils/strings.dart';
import 'package:flutter/material.dart';

class TabbedNavBar extends StatelessWidget implements PreferredSizeWidget {
  const TabbedNavBar({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ColoredBox(
        color: Theme.of(context).colorScheme.primary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 24, bottom: 5),
                  child: Text(
                    title.localized,
                    style: Theme.of(context).textTheme.titleLarge!,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 0.5,
              child: Container(color: Theme.of(context).colorScheme.primary),
            )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => throw UnimplementedError();
}
