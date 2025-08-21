import 'package:echowater/base/constants/string_constants.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/domain_models/friend_domain.dart';
import 'package:echowater/core/domain/domain_models/user_domain.dart';
import 'package:echowater/screens/friends/friend_request_listing_view/friend_request_listing_view.dart';
import 'package:echowater/screens/friends/friends_listing_screen/bloc/friends_listing_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../base/app_specific_widgets/app_bottom_action_sheet_view.dart';
import '../../../base/app_specific_widgets/user_item_view.dart';
import '../../../base/common_widgets/empty_state_view.dart';
import '../../../base/common_widgets/loader/loader.dart';
import '../../../base/utils/colors.dart';
import '../../../base/utils/utilities.dart';
import '../../../core/domain/domain_models/fetch_style.dart';
import '../../../core/injector/injector.dart';
import '../add_friends_screen/add_friends_screen.dart';

class FriendsListingScreen extends StatefulWidget {
  const FriendsListingScreen(
      {required this.showsFriendRequests,
      required this.isSelectingFriend,
      this.onFriendSelected,
      this.selectedFriend,
      super.key});
  final bool showsFriendRequests;
  final bool isSelectingFriend;
  final Function(UserDomain)? onFriendSelected;
  final UserDomain? selectedFriend;

  @override
  State<FriendsListingScreen> createState() => _FriendsListingScreenState();

  static Route<void> route(
      {required bool showsFriendRequests, required bool isSelectingFriend}) {
    return MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/FriendsListingScreen'),
        builder: (_) => FriendsListingScreen(
              showsFriendRequests: showsFriendRequests,
              isSelectingFriend: isSelectingFriend,
            ));
  }
}

class _FriendsListingScreenState extends State<FriendsListingScreen> {
  late final FriendsListingScreenBloc _bloc;

  final _refreshController = RefreshController();
  final TextEditingController _searchController = TextEditingController();
  UserDomain? _selectedUser;

  @override
  void initState() {
    _selectedUser = widget.selectedFriend;
    _bloc = Injector.instance<FriendsListingScreenBloc>();
    super.initState();
    _bloc.add(FetchFriendListEvent(FetchStyle.normal, _searchController.text));
  }

  Widget _headerView() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: BlocBuilder<FriendsListingScreenBloc, FriendsListingScreenState>(
          bloc: _bloc,
          builder: (context, state) {
            return Row(
              children: [
                IconButton(
                    onPressed: () {
                      Utilities.dismissKeyboard();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios)),
                Expanded(
                    child: Text(
                  textAlign: TextAlign.center,
                  "${_bloc.user?.firstName ?? ''}'s ${'Friends'.localized}",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontFamily: StringConstants.fieldGothicTestFont),
                )),
                widget.isSelectingFriend
                    ? Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: InkWell(
                          onTap: () {
                            if (_selectedUser != null) {
                              widget.onFriendSelected?.call(_selectedUser!);
                              Navigator.pop(context);
                            }
                          },
                          child: Opacity(
                            opacity: _selectedUser == null ? 0.5 : 1.0,
                            child: Text(
                              'Add'.localized,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                            ),
                          ),
                        ),
                      )
                    : IconButton(
                        onPressed: () {
                          Utilities.showBottomSheet(
                              widget: const AddFriendsScreen(),
                              context: context);
                        },
                        icon: const Icon(Icons.add))
              ],
            );
          },
        ));
  }

  Widget _friendRequestListingView() {
    return Visibility(
      visible: widget.showsFriendRequests,
      child: FriendRequestListingView(
        isSubSectionView: true,
        onRequestStatusChanged: () {
          _bloc.add(
              FetchFriendListEvent(FetchStyle.normal, _searchController.text));
        },
      ),
    );
  }

  Widget _friendsListingView() {
    return Expanded(
        child:
            BlocConsumer<FriendsListingScreenBloc, FriendsListingScreenState>(
      bloc: _bloc,
      listener: (context, state) {
        _onStateChanged(state);
      },
      builder: (context, state) {
        return state is FetchingFriendsState
            ? const Center(child: Loader())
            : _mainContent();
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    //this is friend list and friend request page
    return Padding(
      padding: EdgeInsets.zero,
      child: DecoratedBox(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(offset: const Offset(0, -1), color: AppColors.color717171)
        ]),
        child: ColoredBox(
          color: Theme.of(context).colorScheme.secondary,
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
                maxWidth: MediaQuery.of(context).size.width,
                maxHeight: MediaQuery.of(context).size.height * 0.9,
                minHeight: MediaQuery.of(context).size.height * 0.9),
            child: ColoredBox(
              color: Theme.of(context).colorScheme.secondary,
              child: Column(
                children: [
                  _headerView(),
                  _friendRequestListingView(),
                  _friendsListingView()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _mainContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              'FriendListingScreen_title'.localized,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Visibility(
                  visible: _bloc.friendsWrapper.friends.isEmpty,
                  child: Center(
                    child: EmptyStateView(
                      title: 'FriendListingScreen_noFriendsMessage'.localized,
                      tags: const [],
                    ),
                  ),
                ),
                SmartRefresher(
                  controller: _refreshController,
                  enablePullUp: _bloc.friendsWrapper.hasMore,
                  onLoading: () async {
                    await Utilities.vibrate();
                    _bloc.add(FetchFriendListEvent(
                        FetchStyle.loadMore, _searchController.text));
                  },
                  onRefresh: () async {
                    await Utilities.vibrate();
                    _bloc.add(FetchFriendListEvent(
                        FetchStyle.pullToRefresh, _searchController.text));
                  },
                  child: ListView.builder(
                      itemCount: _bloc.friendsWrapper.friends.length,
                      itemBuilder: (context, index) {
                        final friend = _bloc.friendsWrapper.friends[index];
                        var isSelected = false;
                        if (_selectedUser != null) {
                          isSelected = friend.user == _selectedUser;
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: UserItemView(
                            user: friend.user,
                            isSelectingFriend: widget.isSelectingFriend,
                            isSelected: isSelected,
                            onSelection: (user) {
                              _selectedUser = user;
                              setState(() {});
                            },
                            onUnFriendButtonClick: (_) {
                              _showUnfriendActionSheet(friend);
                            },
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showUnfriendActionSheet(FriendDomain friend) {
    final title = '${"FriendListingScreen_unfriendActionSheet_title".localized}'
        ' ${friend.user.firstName}';
    Utilities.showBottomSheet(
        widget: AppBottomActionsheetView(
          title: title,
          message: 'FriendListingScreen_unfriendActionSheet_message'.localized,
          posiitiveButtonTitle: 'Yes'.localized,
          negativeButtonTitle: 'No'.localized,
          onNegativeButtonClick: () {
            Navigator.pop(context);
          },
          onPositiveButtonClick: () {
            Navigator.pop(context);
            _bloc.add(UnfriendEvent(friend));
          },
        ),
        context: context);
  }

  void _onStateChanged(FriendsListingScreenState state) {
    if (state is FriendsListingScreenMessageState) {
      Utilities.showSnackBar(context, state.message, state.style);
    } else if (state is FetchedFriendsState) {
      _refreshController
        ..loadComplete()
        ..refreshCompleted();
    }
  }
}
