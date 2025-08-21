import 'package:echowater/base/app_specific_widgets/app_boxed_container.dart';
import 'package:echowater/core/domain/domain_models/personal_goal_option.dart';
import 'package:flutter/material.dart';

class PersonalGoalOptionsView extends StatelessWidget {
  const PersonalGoalOptionsView(
      {required this.title,
      required this.options,
      this.onItemClick,
      super.key});
  final String title;
  final List<PersonalGoalOption> options;
  final Function(PersonalGoalOption)? onItemClick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
        child: SingleChildScrollView(
          child: DecoratedBox(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0, 3),
                      spreadRadius: 5,
                      blurRadius: 5,
                      color: Colors.white.withValues(alpha: 0.2))
                ]),
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
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(
                  height: 30,
                ),
                ListView.builder(
                    itemCount: options.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          onItemClick?.call(options[index]);
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
                                    if (options[index].icon != null)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: options[index].icon!,
                                      ),
                                    Text(
                                      options[index].title,
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    )
                                  ],
                                ),
                              ),
                            )),
                      );
                    }),
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
