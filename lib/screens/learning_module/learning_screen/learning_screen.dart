import 'package:echowater/base/app_specific_widgets/learning_link_items_view.dart';
import 'package:echowater/core/domain/domain_models/learning_category.dart';
import 'package:echowater/core/injector/injector.dart';
import 'package:echowater/core/services/walkthrough_manager/walk_through_wrapper.dart';
import 'package:echowater/screens/learning_module/learning_screen/bloc/learning_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../base/app_specific_widgets/learning_category_selectable_view/learning_category_selectable_view.dart';
import '../../../base/common_widgets/snackbar/snackbar_style.dart';
import '../../../base/utils/utilities.dart';
import '../../../core/services/walkthrough_manager/walk_through_info_view.dart';
import '../../../core/services/walkthrough_manager/walk_through_item.dart';
import '../../../core/services/walkthrough_manager/walk_through_manager.dart';
import '../../../core/services/walkthrough_manager/walk_through_screen_item.dart';
import '../../dashboard/sub_views/tab_contents.dart';
import 'article_learning_library_listing_view/article_learning_library_listing_view.dart';
import 'video_learning_library_listing_view/video_learning_library_listing_view.dart';

class LearningScreen extends StatefulWidget {
  const LearningScreen({super.key});

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  final _allCategories =
      LearningCategory.getDummyLearningCategory(addAllCategory: true);

  late final LearningScreenBloc _bloc;
  @override
  void initState() {
    _bloc = Injector.instance<LearningScreenBloc>();
    super.initState();
    _bloc.add(FetchBaseLearningUrlsEvent());
    _setUpWalkthrough();
  }

  void _setUpWalkthrough() {
    WalkThroughManager().reloadScreen = () {
      if (mounted) {
        setState(() {});
      }
      if (WalkThroughManager().currentWalkthroughItem == WalkThroughItem.none) {
        WalkThroughManager().switchTabScreen?.call(DashboardTabs.profile);
      }
    };
    Future.delayed(const Duration(seconds: 2), () {
      if (WalkThroughManager().currentTab != DashboardTabs.learning) {
        return;
      }
      WalkThroughManager().setLearningScreenWalkThrough();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              WalkThroughWrapper(
                radius: 25,
                hasWalkThough: WalkThroughManager().currentWalkthroughItem ==
                    WalkThroughItem.learningCategory,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: LearningCategorySelectableView(
                      sports: _allCategories,
                      onSelectionChanged: (categories) {
                        _onSelectionChanged(categories: categories);
                      },
                    ),
                  ),
                ),
              ),
              BlocConsumer<LearningScreenBloc, LearningScreenState>(
                bloc: _bloc,
                listener: (context, state) {
                  _onStateChanged(state);
                },
                builder: (context, state) {
                  return _bloc.hasFetchedLearningUrls
                      ? Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: LearningLinkItemsView(
                              learningUrls: _bloc.learningUrlsDomain),
                        )
                      : Container();
                },
              ),
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: isVideoLibrarySelected(),
                      child: const VideoLearningLibraryListingView(
                        isSubSectionView: true,
                      ),
                    ),
                    Visibility(
                      visible: isArticleLibrarySelected(),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: isVideoLibrarySelected() ? 15 : 0),
                        child: const ArticleLearningLibraryListingView(
                          isSubSectionView: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ))
            ],
          ),
          Visibility(
              visible: WalkThroughManager().isShowingWalkThrough,
              child: Positioned.fill(
                  child: Container(
                color: Colors.black.withValues(alpha: 0.5),
              ))),
          Visibility(
            visible: WalkThroughManager().currentWalkthroughItem !=
                WalkThroughItem.none,
            //// we can not make const
            // ignore: prefer_const_constructors
            child: Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                // ignore: prefer_const_constructors
                child: WalkThroughInfoView(
                  screenItem: WalkThroughScreenItem.learnings,
                )),
          )
        ],
      ),
    );
  }

  bool isVideoLibrarySelected() {
    for (final item in _allCategories) {
      if (item.type == LearningCategoryType.all && item.isSelected) {
        return true;
      }
      if (item.type == LearningCategoryType.videos && item.isSelected) {
        return true;
      }
    }
    return false;
  }

  bool isArticleLibrarySelected() {
    for (final item in _allCategories) {
      if (item.type == LearningCategoryType.all && item.isSelected) {
        return true;
      }
      if (item.type == LearningCategoryType.articles && item.isSelected) {
        return true;
      }
    }
    return false;
  }

  void _onSelectionChanged({required List<LearningCategory> categories}) {
    for (final category in _allCategories) {
      category.selected = categories.contains(category);
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _onStateChanged(LearningScreenState state) {
    if (state is LearningScreenApiErrorState) {
      Utilities.showSnackBar(context, state.errorMessage, SnackbarStyle.error);
    }
  }
}
