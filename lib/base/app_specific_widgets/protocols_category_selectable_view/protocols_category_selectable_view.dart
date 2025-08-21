import 'package:echowater/core/domain/domain_models/protocol_category.dart';
import 'package:flutter/material.dart';

import '../../common_widgets/selectable_listview.dart';
import 'single_protocol_category_item_view.dart';

class ProtocolCategorySelectableView extends StatefulWidget {
  const ProtocolCategorySelectableView(
      {required this.protocols, required this.onSelectionChanged, super.key});
  final List<ProtocolCategoryDomain> protocols;
  final Function(List<ProtocolCategoryDomain>)? onSelectionChanged;

  @override
  State<ProtocolCategorySelectableView> createState() =>
      _ProtocolCategorySelectableViewState();
}

class _ProtocolCategorySelectableViewState
    extends State<ProtocolCategorySelectableView> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: SelectableView<ProtocolCategoryDomain>(
        items: widget.protocols,
        viewType: SelectableViewType.horizontalListView,
        onSelectionChanged: widget.onSelectionChanged,
        itemBuilder: (p0, item, isSelected) {
          return SingleLearningCategoryItemView(
            category: item,
            isSelected: isSelected,
            type: SingleProtocolCategoryItemViewType.horizontalSelectable,
          );
        },
      ),
    );
  }
}
