import 'package:echowater/base/app_specific_widgets/user_item_view.dart';
import 'package:echowater/base/common_widgets/loader/loader.dart';
import 'package:echowater/base/common_widgets/text_fields/search_bar_view.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/domain_models/fetch_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../base/common_widgets/empty_state_view.dart';
import '../../../base/constants/string_constants.dart';
import '../../../base/utils/colors.dart';
import '../../../base/utils/utilities.dart';
import '../../../core/injector/injector.dart';
import 'bloc/add_friends_bloc.dart';

class AddFriendsScreen extends StatefulWidget {
  const AddFriendsScreen({super.key});

  @override
  State<AddFriendsScreen> createState() => _AddFriendsScreenState();

  static Route<void> route() {
    return MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/AddFriendsScreen'), builder: (_) => const AddFriendsScreen());
  }
}

class _AddFriendsScreenState extends State<AddFriendsScreen> {
  late final AddFriendsBloc _bloc;
  final _refreshController = RefreshController();
  String _searchString = '';

  @override
  void initState() {
    _bloc = Injector.instance<AddFriendsBloc>();
    super.initState();
    // _bloc.add(SearchUsersEvent(_searchString, FetchStyle.normal));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: DecoratedBox(
        decoration: BoxDecoration(boxShadow: [BoxShadow(offset: const Offset(0, -1), color: AppColors.color717171)]),
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
              child: _getMainBlocBuilder(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getMainBlocBuilder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
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
                  'AddFriendsScreen_addFriendsTitle'.localized,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontFamily: StringConstants.fieldGothicTestFont),
                )),
                const SizedBox(),
              ],
            )),
        SearchBarView(
            hint: 'Email or Phone number',
            onFieldSubmitted: (value) {
              _searchString = value;
              _bloc.add(SearchUsersEvent(_searchString, FetchStyle.normal));
            }),
        Expanded(
          child: BlocConsumer<AddFriendsBloc, AddFriendsState>(
            bloc: _bloc,
            listener: (context, state) {
              _onStateChanged(state);
            },
            builder: (context, state) {
              return state is FetchingSearchResultState ? const Center(child: Loader()) : _mainContent();
            },
          ),
        ),
      ],
    );
  }

  Widget _mainContent() {
    return Stack(
      children: [
        Visibility(
          visible: _bloc.searchResult.users.isEmpty,
          child: Center(
            child: EmptyStateView(
              title:
                  _searchString.isEmpty ? 'FriendSearch_InitialMessage'.localized : 'AddFriendsScreen_noResultMessage'.localized,
              tags: const [],
            ),
          ),
        ),
        SmartRefresher(
          controller: _refreshController,
          enablePullUp: _bloc.searchResult.hasMore,
          onLoading: () async {
            await Utilities.vibrate();
            _bloc.add(SearchUsersEvent(_searchString, FetchStyle.loadMore));
          },
          onRefresh: () async {
            await Utilities.vibrate();
            _bloc.add(SearchUsersEvent(_searchString, FetchStyle.pullToRefresh));
          },
          child: ListView.builder(
              itemCount: _bloc.searchResult.users.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: UserItemView(
                    user: _bloc.searchResult.users[index],
                    isSelectingFriend: false,
                    isSelected: false,
                  ),
                );
              }),
        )
      ],
    );
  }

  void _onStateChanged(AddFriendsState state) {
    if (state is AddFriendMessageState) {
      Utilities.showSnackBar(context, state.messagae, state.style);
    } else if (state is FetchedSearchResultState) {
      _refreshController
        ..loadComplete()
        ..refreshCompleted();
    }
  }
}
