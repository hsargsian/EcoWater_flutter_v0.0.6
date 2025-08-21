import 'package:echowater/base/common_widgets/loader/loader.dart';
import 'package:echowater/core/domain/domain_models/notification_type.dart';
import 'package:echowater/core/domain/domain_models/protocol_category.dart';
import 'package:echowater/core/injector/injector.dart';
import 'package:echowater/screens/protocols/protocol_tab_dashboard_screen/bloc/protocol_tab_dashboard_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../base/app_specific_widgets/protocols_category_selectable_view/protocols_category_selectable_view.dart';
import '../../../base/common_widgets/snackbar/snackbar_style.dart';
import '../../../base/utils/utilities.dart';
import '../protocol_detail_screen/edit_custom_protocol/edit_custom_protocol_dialog.dart';
import '../sub_views/create_protocol_view.dart';
import '../sub_views/protocols_listing_view/protocols_listing_view.dart';

class ProtocolTabDashboardScreen extends StatefulWidget {
  const ProtocolTabDashboardScreen({super.key});

  @override
  State<ProtocolTabDashboardScreen> createState() => _ProtocolTabDashboardScreenState();
}

class _ProtocolTabDashboardScreenState extends State<ProtocolTabDashboardScreen> {
  late final ProtocolTabBloc _bloc;

  final GlobalKey<ProtocolsListingViewState> _protocolsListingViewState = GlobalKey();
  final ValueNotifier<bool> _createProtocolNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    _bloc = Injector.instance<ProtocolTabBloc>();
    super.initState();
    _bloc.add(FetchProtocolCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocConsumer<ProtocolTabBloc, ProtocolTabDashboardListingState>(
            bloc: _bloc,
            listener: (context, state) => _onStateChanged,
            builder: (context, state) {
              return Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  _bloc.categories.second
                      ? Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: ProtocolCategorySelectableView(
                            protocols: _bloc.categories.first,
                            onSelectionChanged: (categories) {
                              _onSelectionChanged(categories: categories);
                            },
                          ),
                        )
                      : const SizedBox.shrink(),
                  Expanded(
                      child: _bloc.categories.second
                          ? SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [_allTopCategoriesView(), _listingView()],
                              ),
                            )
                          : const Center(child: Loader()))
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _listingView() {
    if (_isAllSelected()) {
      return Column(
        children: _bloc.categories.first.where((item) => item.key != 'all').map((item) {
          return ProtocolsListingView(
            isSubSectionView: true,
            title: item.listTitle,
            axis: Axis.vertical,
            protocolCategory: item.key,
            createProtocolNotifier: _createProtocolNotifier,
          );
        }).toList(),
      );
    } else {
      return Column(
        children: _bloc.categories.first.where((item) => item.key != 'all').where((item) => item.isSelected).map((item) {
          return ProtocolsListingView(
            key: _protocolsListingViewState,
            isSubSectionView: true,
            title: item.listTitle,
            axis: Axis.vertical,
            protocolCategory: item.key,
            fetchOnInit: false,
            createProtocolNotifier: _createProtocolNotifier,
          );
        }).toList(),
      );
    }
  }

  bool _isAllSelected() {
    for (final item in _bloc.categories.first) {
      if (item.key == 'all' && item.isSelected) {
        return true;
      }
    }
    return false;
  }

  Widget _allTopCategoriesView() {
    return _isAllSelected()
        ? Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              ProtocolsListingView(
                isSubSectionView: true,
                title: 'Top Protocols',
                axis: Axis.horizontal,
                protocolCategory: 'top_protocols',
                createProtocolNotifier: _createProtocolNotifier,
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  ValueListenableBuilder<bool>(
                      valueListenable: _createProtocolNotifier,
                      builder: (context, value, child) {
                        return ProtocolsListingView(
                          isSubSectionView: true,
                          title: 'Custom',
                          axis: Axis.horizontal,
                          protocolCategory: 'custom',
                          createProtocolNotifier: _createProtocolNotifier,
                        );
                      }),
                  CreateProtocolView(
                    onClick: () {
                      final model = _bloc.getDefaultCustomProtocolData();
                      Utilities.showBottomSheet(
                          isDismissable: false,
                          widget: EditCustomProtocolDialog(
                            isFromBlankTemplate: true,
                            model: model,
                            onSaved: () {
                              Navigator.pop(context);
                              _createProtocolNotifier.value = true;
                            },
                          ),
                          context: context);
                      // Utilities.showBottomSheet(widget: const CreateCustomProtocolDialog(), context: context);
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          )
        : const SizedBox.shrink();
  }

  void _onStateChanged(ProtocolTabDashboardListingState state, BuildContext context) {
    if (state is ProtocolTabFetchApiErrorState) {
      Utilities.showSnackBar(context, state.errorMessage, SnackbarStyle.error);
    }
  }

  void _onSelectionChanged({required List<ProtocolCategoryDomain> categories}) {
    for (final category in _bloc.categories.first) {
      category.selected = categories.contains(category);
    }
    if (mounted) {
      setState(() {});
    }
    Future.delayed(const Duration(milliseconds: 300), () {
      final category = categories.firstWhereOrNull((item) => item.isSelected);
      _protocolsListingViewState.currentState?.updateView(Axis.vertical, true, category?.key);
    });
  }
}
