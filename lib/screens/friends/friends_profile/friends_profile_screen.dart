import 'package:echowater/base/utils/utilities.dart';
import 'package:echowater/core/domain/domain_models/user_domain.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../base/app_specific_widgets/left_arrow_back_button.dart';
import '../../../base/common_widgets/navbar/echo_water_nav_bar.dart';
import '../../../base/common_widgets/navbar/nav_bar.dart';
import '../../../core/injector/injector.dart';
import '../../goals_module/personal_goal_listing_view/personal_goal_listing_view.dart';
import '../../goals_module/social_goal_listing_view/social_goal_listing_view.dart';
import '../../profile_module/profile_edit_screen/profile_edit_screen.dart';
import '../../profile_module/profile_screen/sub_views/profile_header_view.dart';
import 'bloc/friends_profile_bloc.dart';

class FriendsProfileScreen extends StatefulWidget {
  const FriendsProfileScreen({required this.id, super.key});

  final String id;

  @override
  State<FriendsProfileScreen> createState() => _FriendsProfileScreenState();

  static Route<void> route(String id) {
    return MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/FriendsProfileScreen'),
        builder: (_) => FriendsProfileScreen(id: id));
  }
}

class _FriendsProfileScreenState extends State<FriendsProfileScreen> {
  late final FriendsProfileBloc _bloc;

  final GlobalKey<PersonalGoalListingViewState>
      _personalGoalListingViewStateKey = GlobalKey();
  final GlobalKey<SocialGoalListingViewState> _socialGoalListingViewStateKey =
      GlobalKey();
  final DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    _bloc = Injector.instance<FriendsProfileBloc>();
    _bloc.add(InitialEvent(widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EchoWaterNavBar(
          child: BlocBuilder<FriendsProfileBloc, FriendsProfileState>(
        bloc: _bloc,
        builder: (context, state) {
          return NavBar(
              navStyle: NavStyle.singleLined,
              navTitle: _bloc.hasFetchedUserDetails ? _bloc.user.firstName : '',
              textColor: Theme.of(context).colorScheme.primaryElementColor,
              leftButton: const LeftArrowBackButton(),
              sideMenuItems: const []);
        },
      )),
      body: _getMainBlocBuilder(),
    );
  }

  Widget _headerView() {
    return BlocBuilder<FriendsProfileBloc, FriendsProfileState>(
      bloc: _bloc,
      builder: (context, state) {
        final user = _bloc.hasFetchedUserDetails ? _bloc.user : null;
        if (user == null) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 15),
          child: ProfileHeaderView(
            user: user,
            canEditProfile: user.isMe,
            onAddFriendButtonClick: () {
              _bloc.add(SendFriendRequestEvent(user));
            },
            unFriendButtonClick: () {
              _bloc.add(RequestActionFriendEvent(user, 'remove'));
            },
            onEditClick: () {
              Navigator.push(context, ProfileEditScreen.route(
                didUpdateProfile: () {
                  _bloc.add(FetchUserDetailEvent());
                },
              ));
            },
            onReportProfile: () {
              _bloc.add(ReportFriendEvent(user));
            },
            deleteFriendRequestButtonClick: () {
              _bloc.add(RequestActionFriendEvent(user, 'reject'));
            },
            cancelFriendRequestButtonClick: () {
              _bloc.add(RequestActionFriendEvent(user, 'cancel'));
            },
          ),
        );
      },
    );
  }

  Widget _getMainBlocBuilder() {
    return BlocConsumer<FriendsProfileBloc, FriendsProfileState>(
      bloc: _bloc,
      listener: _onStateChanged,
      builder: (context, state) {
        debugPrint('Friend');
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _headerView(),
                if (_bloc.hasFetchedUserDetails &&
                    _bloc.user.friendAction == FriendAction.friend)
                  PersonalGoalListingView(
                    user: _bloc.user,
                    key: _personalGoalListingViewStateKey,
                    date: _selectedDate,
                  ),
                const SizedBox(
                  height: 20,
                ),
                if (_bloc.hasFetchedUserDetails &&
                    _bloc.user.friendAction == FriendAction.friend)
                  SocialGoalListingView(
                    key: _socialGoalListingViewStateKey,
                    user: _bloc.user,
                    date: _selectedDate,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onStateChanged(
    BuildContext context,
    FriendsProfileState state,
  ) {
    if (state is FriendsProfileMessageState) {
      Utilities.showSnackBar(context, state.message, state.style);
    } else if (state is FriendRequestSentState) {
      Navigator.pop(context);
    }
  }
}
