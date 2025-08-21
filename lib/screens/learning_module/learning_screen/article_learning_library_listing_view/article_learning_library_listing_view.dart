import 'package:echowater/base/app_specific_widgets/app_boxed_container.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/domain_models/fetch_style.dart';
import 'package:echowater/core/injector/injector.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../base/common_widgets/navbar/echo_water_nav_bar.dart';
import '../../../../base/common_widgets/navbar/nav_bar.dart';
import '../../../../base/common_widgets/snackbar/snackbar_style.dart';
import '../../../../base/constants/string_constants.dart';
import '../../../../base/utils/utilities.dart';
import 'article_learning_single_item_view.dart';
import 'bloc/article_learning_library_listing_bloc.dart';

class ArticleLearningLibraryListingView extends StatefulWidget {
  const ArticleLearningLibraryListingView(
      {required this.isSubSectionView, super.key});
  final bool isSubSectionView;

  @override
  State<ArticleLearningLibraryListingView> createState() =>
      _ArticleLearningLibraryListingViewState();

  static Route<void> route({required bool isSubSectionView}) {
    return MaterialPageRoute<void>(
        settings:
            const RouteSettings(name: '/ArticleLearningLibraryListingView'),
        builder: (_) => ArticleLearningLibraryListingView(
              isSubSectionView: isSubSectionView,
            ));
  }
}

class _ArticleLearningLibraryListingViewState
    extends State<ArticleLearningLibraryListingView> {
  late final ArticleLearningLibraryListingBloc _bloc;

  final _refreshController = RefreshController();

  @override
  void initState() {
    _bloc = Injector.instance<ArticleLearningLibraryListingBloc>();
    super.initState();
    _bloc
      ..add(SetArticleLearningLibraryListingType(widget.isSubSectionView))
      ..add(FetchArticleLearningLibraryListingEvent(FetchStyle.normal));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSubSectionView) {
      return _getMainBlocBuilder();
    }
    return Scaffold(
      appBar: EchoWaterNavBar(
          child: NavBar(
              navStyle: NavStyle.singleLined,
              navTitle: 'ArticleLibrary_title'.localized,
              textColor: Theme.of(context).colorScheme.primaryElementColor,
              leftButton: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              sideMenuItems: const [])),
      body: _getMainBlocBuilder(),
    );
  }

  Widget _getMainBlocBuilder() {
    return BlocConsumer<ArticleLearningLibraryListingBloc,
        ArticleLearningLibraryListingState>(
      bloc: _bloc,
      listener: (context, state) {
        _onStateChanged(state, context);
      },
      builder: (context, state) {
        return AppBoxedContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: widget.isSubSectionView,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Text('ArticleLibrary_title'.localized,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontFamily: StringConstants.fieldGothicTestFont)),
                ),
              ),
              mainContentView(),
            ],
          ),
        );
      },
    );
  }

  Widget mainContentView() {
    if (widget.isSubSectionView) {
      return _itemsGridView();
    }
    return Expanded(
      child: SmartRefresher(
        enablePullUp: _bloc.articleWrapper.hasMore,
        onLoading: () async {
          await Utilities.vibrate();
          _bloc.add(
              FetchArticleLearningLibraryListingEvent(FetchStyle.loadMore));
        },
        onRefresh: () async {
          await Utilities.vibrate();
          _bloc.add(FetchArticleLearningLibraryListingEvent(
              FetchStyle.pullToRefresh));
        },
        controller: _refreshController,
        child: _itemsGridView(),
      ),
    );
  }

  Widget _itemsGridView() {
    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: widget.isSubSectionView
          ? const NeverScrollableScrollPhysics()
          : const AlwaysScrollableScrollPhysics(),
      shrinkWrap: widget.isSubSectionView,
      itemCount: _bloc.articleWrapper.articles.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1, childAspectRatio: 1.8),
      itemBuilder: (context, index) {
        return ArticleLearningSingleItemView(
          item: _bloc.articleWrapper.articles[index],
          onSeeAllClick: () {
            Navigator.push(
                context,
                ArticleLearningLibraryListingView.route(
                    isSubSectionView: false));
          },
        );
      },
    );
  }

  void _onStateChanged(
      ArticleLearningLibraryListingState state, BuildContext context) {
    if (state is FetchedArticleLearningLibraryListingState) {
      if (!widget.isSubSectionView) {
        _refreshController
          ..loadComplete()
          ..refreshCompleted();
      }
    } else if (state is ArticleLearningLibraryApiErrorState) {
      Utilities.showSnackBar(context, state.errorMessage, SnackbarStyle.error);
    }
  }
}
