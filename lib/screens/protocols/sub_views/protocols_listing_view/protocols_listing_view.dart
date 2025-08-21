import 'package:echowater/base/common_widgets/loader/loader.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/injector/injector.dart';
import 'package:echowater/screens/protocols/sub_views/protocol_single_item_view.dart';
import 'package:echowater/screens/protocols/sub_views/protocols_horizontal_scroller.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../base/app_specific_widgets/app_boxed_container.dart';
import '../../../../base/common_widgets/navbar/echo_water_nav_bar.dart';
import '../../../../base/common_widgets/navbar/nav_bar.dart';
import '../../../../base/common_widgets/snackbar/snackbar_style.dart';
import '../../../../base/constants/string_constants.dart';
import '../../../../base/utils/utilities.dart';
import '../../../../core/domain/domain_models/fetch_style.dart';
import 'bloc/protocols_listing_bloc.dart';

class ProtocolsListingView extends StatefulWidget {
  const ProtocolsListingView(
      {required this.isSubSectionView,
      required this.title,
      required this.axis,
      required this.createProtocolNotifier,
      this.protocolCategory,
      this.fetchOnInit,
      super.key});

  final bool isSubSectionView;
  final String? protocolCategory;
  final String title;
  final Axis axis;
  final bool? fetchOnInit;
  final ValueNotifier<bool> createProtocolNotifier;

  @override
  State<ProtocolsListingView> createState() => ProtocolsListingViewState();

  static Route<void> route({
    required bool isSubSectionView,
    required String title,
    required Axis axis,
    required ValueNotifier<bool> createProtocolNotifier,
    String? category,
  }) {
    return MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/ProtocolsListingView'),
        builder: (_) => ProtocolsListingView(
              isSubSectionView: isSubSectionView,
              title: title,
              protocolCategory: category,
              axis: axis,
              createProtocolNotifier: createProtocolNotifier,
            ));
  }
}

class ProtocolsListingViewState extends State<ProtocolsListingView> {
  late final ProtocolsListingBloc _bloc;

  final _refreshController = RefreshController();
  String? type;
  String? category;

  @override
  void initState() {
    _bloc = Injector.instance<ProtocolsListingBloc>();
    super.initState();
    if (widget.fetchOnInit ?? true) {
      updateView(
        widget.axis,
        widget.isSubSectionView,
        widget.protocolCategory,
      );
    }
  }

  void updateView(Axis axis, bool isSubSectionView, String? protocolCategory) {
    if (axis == Axis.vertical) {
      category = widget.protocolCategory;
    } else {
      type = protocolCategory;
    }
    _bloc
      ..add(SetProtocolsListingType(isSubSectionView, protocolCategory))
      ..add(FetchProtocolsListingEvent(FetchStyle.normal, category, type));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.createProtocolNotifier.value) {
      updateView(
        widget.axis,
        widget.isSubSectionView,
        widget.protocolCategory,
      );
      widget.createProtocolNotifier.value = false;
    }
    if (widget.isSubSectionView) {
      return _getMainBlocBuilder();
    }
    return Scaffold(
      appBar: EchoWaterNavBar(
          child: NavBar(
              navStyle: NavStyle.singleLined,
              navTitle: widget.title.localized,
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
    return BlocConsumer<ProtocolsListingBloc, ProtocolsListingState>(
      bloc: _bloc,
      listener: (context, state) {
        _onStateChanged(state, context);
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(bottom: _bloc.isSubsectionView ? 10.0 : 0),
          child: AppBoxedContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: widget.isSubSectionView,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(widget.title.localized,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontFamily: StringConstants.fieldGothicTestFont)),
                        ),
                        BlocBuilder<ProtocolsListingBloc, ProtocolsListingState>(
                          bloc: _bloc,
                          builder: (context, state) {
                            return Visibility(
                              visible: widget.isSubSectionView && _bloc.protocolsWrapper.hasMore,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      ProtocolsListingView.route(
                                          title: widget.title,
                                          isSubSectionView: false,
                                          axis: Axis.vertical,
                                          createProtocolNotifier: widget.createProtocolNotifier,
                                          category: widget.protocolCategory));
                                },
                                child: Text(
                                  'See All',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
                mainContentView(),
              ],
            ),
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
        enablePullUp: _bloc.protocolsWrapper.hasMore,
        onLoading: () async {
          await Utilities.vibrate();
          _bloc.add(FetchProtocolsListingEvent(FetchStyle.loadMore, category, type));
        },
        onRefresh: () async {
          await Utilities.vibrate();
          _bloc.add(FetchProtocolsListingEvent(FetchStyle.pullToRefresh, category, type));
        },
        controller: _refreshController,
        child: _itemsGridView(),
      ),
    );
  }

  Widget _itemsGridView() {
    final protocols = _bloc.protocolsWrapper.protocols;

    if (!_bloc.protocolsWrapper.hasFetched) {
      return const Center(
          child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Loader(),
      ));
    } else if (_bloc.protocolsWrapper.hasFetched && protocols.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            'No protocols available',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.secondaryElementColor),
          ),
        ),
      );
    }

    switch (widget.axis) {
      case Axis.horizontal:
        return ProtocolsHorizontalScroller(
          protocolWrapper: _bloc.protocolsWrapper,
          title: widget.title,
          showsShowAll: _bloc.protocolsWrapper.hasMore,
          bloc: _bloc,
          scrollDirection: Axis.horizontal,
          onRefreshedPage: () {
            updateView(
              widget.axis,
              widget.isSubSectionView,
              widget.protocolCategory,
            );
          },
        );
      case Axis.vertical:
        return GridView.builder(
          padding: EdgeInsets.zero,
          physics: widget.isSubSectionView ? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics(),
          scrollDirection: widget.axis,
          shrinkWrap: widget.isSubSectionView,
          itemCount: protocols.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, childAspectRatio: 1.8),
          itemBuilder: (context, index) {
            return SingleProtocolItemView(
              protocol: protocols[index],
              protocolType: type ?? category ?? '',
              isFullWidth: widget.axis == Axis.vertical,
              bloc: _bloc,
              onRefreshedPage: () {
                updateView(
                  widget.axis,
                  widget.isSubSectionView,
                  widget.protocolCategory,
                );
              },
            );
          },
        );
    }
  }

  void _onStateChanged(ProtocolsListingState state, BuildContext context) {
    if (state is FetchedProtocolsListingState) {
      if (!widget.isSubSectionView) {
        _refreshController
          ..loadComplete()
          ..refreshCompleted();
      }
    } else if (state is ProtocolsFetchApiErrorState) {
      Utilities.showSnackBar(context, state.errorMessage, SnackbarStyle.error);
    }
  }
}
