import 'package:echowater/base/common_widgets/image_widgets/app_image_view.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/domain_models/week_one_traning_domain.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';

import '../../../base/common_widgets/buttons/app_button.dart';

class TrainingWrapperView extends StatefulWidget {
  const TrainingWrapperView(
      {required this.models,
      required this.currentDay,
      required this.onDayChange,
      required this.updateWeekOneTraining,
      super.key});

  final List<WeekOneTraningDomain> models;
  final int currentDay;
  final Function(int day)? onDayChange;
  final Function()? updateWeekOneTraining;

  @override
  State<TrainingWrapperView> createState() => _TrainingWrapperViewState();
}

class _TrainingWrapperViewState extends State<TrainingWrapperView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    _pageController.addListener(() {
      _currentPage = _pageController.page?.toInt() ?? 0;
      setState(() {});
    });
    // Future.delayed(const Duration(seconds: 1), () {
    //   _pageController.jumpToPage(widget.currentDay);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            onPageChanged: (value) {
              widget.onDayChange?.call(value);
            },
            itemBuilder: (context, index) {
              final item = widget.models[index];
              return SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item.image != null)
                        AppImageView(width: double.infinity, cornerRadius: 0, height: 200, avatarUrl: item.image),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (item.title != null) Text(item.title!, style: const TextStyle(color: Colors.white)),
                            if (item.description != null) Text(item.description!, style: const TextStyle(color: Colors.white)),
                            if (item.checkItems.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: item.checkItems
                                    .map((item) => Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(right: 10),
                                                color: Theme.of(context).colorScheme.primaryElementInvertedeColor,
                                                width: 20,
                                                height: 20,
                                              ),
                                              Expanded(child: Text(item, style: const TextStyle(color: Colors.white)))
                                            ],
                                          ),
                                        ))
                                    .toList(),
                              ),
                            if (item.subDesctiption.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                child: Text(item.subDesctiption),
                              ),
                            if (item.quotes.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: item.quotes
                                      .map((item) => Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 5),
                                            child: Stack(
                                              children: [
                                                Positioned.fill(
                                                  child: Container(
                                                    decoration: const BoxDecoration(
                                                        gradient: LinearGradient(stops: [
                                                      0.2,
                                                      0.4,
                                                      0.8
                                                    ], colors: [
                                                      Color.fromRGBO(3, 162, 177, 0.95),
                                                      Color.fromRGBO(99, 162, 178, 1),
                                                      Color.fromRGBO(195, 162, 179, 0.93),
                                                    ])),
                                                  ),
                                                ),
                                                Container(
                                                  width: double.maxFinite,
                                                  margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                                  color: Theme.of(context).colorScheme.secondary,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        item.testimony,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall
                                                            ?.copyWith(fontStyle: FontStyle.italic),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(item.author, style: Theme.of(context).textTheme.bodySmall)
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ),
                            const SizedBox(
                              height: 50,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
            itemCount: widget.models.length,
          ),
          Positioned(bottom: 20, left: 15, right: 15, child: _bottomButtonView())
        ],
      ),
    );
  }

  Widget _bottomButtonView() {
    if (widget.currentDay == 0) {
      if (_currentPage == 0) {
        return Row(
          children: [
            Expanded(
                child: AppButton(
              title: 'Start'.localized,
              onClick: () {
                _pageController.jumpToPage(1);
              },
              hasGradientBackground: true,
            ))
          ],
        );
      } else {
        return Row(
          children: [
            Expanded(
                child: AppButton(
              height: 45,
              radius: 22.5,
              title: '<start'.localized,
              onClick: () {
                _pageController.jumpToPage(0);
              },
              backgroundColor: Theme.of(context).colorScheme.secondary,
              border: BorderSide(color: Theme.of(context).colorScheme.primaryElementColor),
            )),
            const SizedBox(
              width: 10,
            ),
            Expanded(child: Container())
          ],
        );
      }
    } else {
      if (widget.currentDay == _currentPage) {
        // widget.updateWeekOneTraining?.call();
        return AppButton(
          title: 'Complete Training',
          onClick: () {
            widget.updateWeekOneTraining?.call();
            Navigator.pop(context);
            // _pageController.jumpToPage(0);
          },
          hasGradientBackground: true,
        );
      } else {
        return Row(
          children: [
            Expanded(
                child: _currentPage == 0
                    ? Container()
                    : AppButton(
                        height: 45,
                        radius: 22.5,
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 14,
                        ),
                        title: 'Start'.localized,
                        onClick: () {
                          _pageController.jumpToPage(0);
                        },
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        border: BorderSide(color: Theme.of(context).colorScheme.primaryElementColor),
                      )),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: AppButton(
              title: '${'day'.localized} ${_currentPage + 1}',
              icon: const Icon(
                Icons.arrow_forward,
                size: 14,
              ),
              addIconAfterText: true,
              onClick: () {
                _pageController.jumpToPage(_currentPage + 1);
              },
              hasGradientBackground: true,
            ))
          ],
        );
      }
    }
  }
}
