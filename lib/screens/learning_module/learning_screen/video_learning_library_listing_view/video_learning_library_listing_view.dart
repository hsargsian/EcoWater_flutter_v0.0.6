import 'package:echowater/base/app_specific_widgets/app_boxed_container.dart';
import 'package:echowater/base/constants/string_constants.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/domain_models/fetch_style.dart';
import 'package:echowater/core/injector/injector.dart';
import 'package:echowater/screens/learning_module/learning_screen/video_learning_library_listing_view/bloc/video_learning_library_listing_bloc.dart';
import 'package:echowater/screens/learning_module/learning_screen/video_learning_library_listing_view/video_learning_single_item_view.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../base/common_widgets/navbar/echo_water_nav_bar.dart';
import '../../../../base/common_widgets/navbar/nav_bar.dart';
import '../../../../base/common_widgets/snackbar/snackbar_style.dart';
import '../../../../base/utils/utilities.dart';

class VideoLearningLibraryListingView extends StatefulWidget {
  const VideoLearningLibraryListingView(
      {required this.isSubSectionView, super.key});
  final bool isSubSectionView;

  @override
  State<VideoLearningLibraryListingView> createState() =>
      _VideoLearningLibraryListingViewState();

  static Route<void> route({required bool isSubSectionView}) {
    return MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/VideoLearningLibraryListingView'),
        builder: (_) => VideoLearningLibraryListingView(
              isSubSectionView: isSubSectionView,
            ));
  }
}

class _VideoLearningLibraryListingViewState
    extends State<VideoLearningLibraryListingView> {
  late final VideoLearningLibraryListingBloc _bloc;

  final _refreshController = RefreshController();

  @override
  void initState() {
    _bloc = Injector.instance<VideoLearningLibraryListingBloc>();
    super.initState();
    _bloc
      ..add(SetVideoLearningLibraryListingType(widget.isSubSectionView))
      ..add(FetchVideoLearningLibraryListingEvent(FetchStyle.normal));
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
              navTitle: 'VideoLibrary_title'.localized,
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
    return BlocConsumer<VideoLearningLibraryListingBloc,
        VideoLearningLibraryListingState>(
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
                  child: Text('VideoLibrary_title'.localized,
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
        enablePullUp: _bloc.videoWrapper.hasMore,
        onLoading: () async {
          await Utilities.vibrate();
          _bloc.add(FetchVideoLearningLibraryListingEvent(FetchStyle.loadMore));
        },
        onRefresh: () async {
          await Utilities.vibrate();
          _bloc.add(
              FetchVideoLearningLibraryListingEvent(FetchStyle.pullToRefresh));
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
      itemCount: _bloc.videoWrapper.videos.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (context, index) {
        return VideoLearningSingleItemView(
          item: _bloc.videoWrapper.videos[index],
          onSeeAllClick: () {
            Navigator.push(context,
                VideoLearningLibraryListingView.route(isSubSectionView: false));
          },
        );
      },
    );
  }

  void _onStateChanged(
      VideoLearningLibraryListingState state, BuildContext context) {
    if (state is FetchedVideoLearningLibraryListingState &&
        !widget.isSubSectionView) {
      _refreshController
        ..loadComplete()
        ..refreshCompleted();
    } else if (state is VideoLearningLibraryApiErrorState) {
      Utilities.showSnackBar(context, state.errorMessage, SnackbarStyle.error);
    }
  }
}
