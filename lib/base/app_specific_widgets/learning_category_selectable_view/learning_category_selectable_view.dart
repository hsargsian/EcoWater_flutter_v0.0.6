import 'package:echowater/core/domain/domain_models/learning_category.dart';
import 'package:flutter/material.dart';

import '../../common_widgets/selectable_listview.dart';
import 'single_learning_category_item_view.dart';

class LearningCategorySelectableView extends StatefulWidget {
  const LearningCategorySelectableView(
      {required this.sports, required this.onSelectionChanged, super.key});
  final List<LearningCategory> sports;
  final Function(List<LearningCategory>)? onSelectionChanged;

  @override
  State<LearningCategorySelectableView> createState() =>
      _LearningCategorySelectableViewState();
}

class _LearningCategorySelectableViewState
    extends State<LearningCategorySelectableView> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: SelectableView<LearningCategory>(
        items: widget.sports,
        viewType: SelectableViewType.horizontalListView,
        onSelectionChanged: widget.onSelectionChanged,
        itemBuilder: (p0, item, isSelected) {
          return SingleLearningCategoryItemView(
            category: item,
            isSelected: isSelected,
            type: SingleLearningCategoryItemViewType.horizontalSelectable,
          );
        },
      ),
    );
  }
}
