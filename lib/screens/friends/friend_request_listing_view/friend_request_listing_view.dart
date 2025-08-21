import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../base/common_widgets/empty_state_view.dart';
import '../../../base/common_widgets/navbar/echo_water_nav_bar.dart';
import '../../../base/common_widgets/navbar/nav_bar.dart';
import '../../../base/common_widgets/snackbar/snackbar_style.dart';
import '../../../base/utils/utilities.dart';
import '../../../core/domain/domain_models/fetch_style.dart';
import '../../../core/injector/injector.dart';
import 'bloc/friend_request_listing_view_bloc.dart';
import 'friend_request.dart';

class FriendRequestListingView extends StatefulWidget {
  const FriendRequestListingView(
      {required this.isSubSectionView,
      required this.onRequestStatusChanged,
      super.key});
  final bool isSubSectionView;
  final Function()? onRequestStatusChanged;
  @override
  State<FriendRequestListingView> createState() =>
      _FriendRequestListingViewState();

  static Route<void> route(
      {required bool isSubSectionView,
      required Function()? onRequestStatusChanged}) {
    return MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/FriendRequestListingView'),
        builder: (_) => FriendRequestListingView(
              isSubSectionView: isSubSectionView,
              onRequestStatusChanged: onRequestStatusChanged,
            ));
  }
}

class _FriendRequestListingViewState extends State<FriendRequestListingView> {
  late final FriendRequestsListingViewBloc _bloc;

  final _refreshController = RefreshController();

  @override
  void initState() {
    _bloc = Injector.instance<FriendRequestsListingViewBloc>();
    super.initState();
    _bloc
      ..add(SetFriendRequestListingType(widget.isSubSectionView))
      ..add(FetchFriendRequestsEvent(FetchStyle.normal));
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
              navTitle: 'FriendRequests_title'.localized,
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

  Widget _subSectionView() {
    if (_bloc.friendRequestWrapper.requests.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: widget.isSubSectionView,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Expanded(child: Text('FriendRequests_title'.localized)),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        FriendRequestListingView.route(
                            isSubSectionView: false,
                            onRequestStatusChanged: () {
                              _bloc.add(
                                  FetchFriendRequestsEvent(FetchStyle.normal));
                              widget.onRequestStatusChanged?.call();
                            }));
                  },
                  child: Text(
                    'SeeAll'.localized,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: mainContentView(),
        ),
      ],
    );
  }

  Widget _getMainBlocBuilder() {
    return BlocConsumer<FriendRequestsListingViewBloc,
        FriendRequestListingViewState>(
      bloc: _bloc,
      listener: (context, state) {
        _onStateChanged(state, context);
      },
      builder: (context, state) {
        return widget.isSubSectionView
            ? _subSectionView()
            : Padding(
                padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                child: mainContentView(),
              );
      },
    );
  }

  Widget mainContentView() {
    if (widget.isSubSectionView) {
      return _itemsGridView();
    }
    return Stack(
      children: [
        SmartRefresher(
          enablePullUp: _bloc.friendRequestWrapper.hasMore,
          onLoading: () async {
            await Utilities.vibrate();
            _bloc.add(FetchFriendRequestsEvent(FetchStyle.loadMore));
          },
          onRefresh: () async {
            await Utilities.vibrate();
            _bloc.add(FetchFriendRequestsEvent(FetchStyle.pullToRefresh));
          },
          controller: _refreshController,
          child: _itemsGridView(),
        ),
        Visibility(
          visible: _bloc.friendRequestWrapper.requests.isEmpty,
          child: Center(
            child: EmptyStateView(
              title: 'FriendRequestScreen_noFriendRequestsMessage'.localized,
              tags: const [],
            ),
          ),
        )
      ],
    );
  }

  Widget _itemsGridView() {
    return ListView.builder(
        physics: widget.isSubSectionView
            ? const NeverScrollableScrollPhysics()
            : const AlwaysScrollableScrollPhysics(),
        shrinkWrap: widget.isSubSectionView,
        itemCount: _bloc.friendRequestWrapper.requests.length,
        itemBuilder: (context, index) {
          final request = _bloc.friendRequestWrapper.requests[index];
          return FriendRequest(
            request,
            acceptRequest: (model) {
              _bloc.add(AcceptDeclineRequestEvent(model, true));
            },
            declineRequest: (model) {
              _bloc.add(AcceptDeclineRequestEvent(model, false));
            },
          );
          // return _friendRequest(_bloc.friendRequestWrapper.requests[index]);
        });
  }

  void _onStateChanged(
      FriendRequestListingViewState state, BuildContext context) {
    if (state is FetchedFriendRequestsListingState) {
      if (!widget.isSubSectionView) {
        _refreshController
          ..loadComplete()
          ..refreshCompleted();
      }
    } else if (state is FriendRequestListingViewApiErrorState) {
      Utilities.showSnackBar(context, state.errorMessage, SnackbarStyle.error);
    } else if (state is FriendRequestStatusChangedState) {
      widget.onRequestStatusChanged?.call();
    }
  }
}
