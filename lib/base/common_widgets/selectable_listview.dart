import 'package:echowater/base/utils/iterable.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/colors.dart';
import 'image_widgets/app_image_view.dart';

enum SelectableViewSelectionMode {
  single,
  multi,
}

enum SelectableViewType {
  verticalListView,
  horizontalListView,
  wrapGridView;

  Axis get axis {
    switch (this) {
      case SelectableViewType.verticalListView:
        return Axis.vertical;
      case SelectableViewType.horizontalListView:
        return Axis.horizontal;
      case SelectableViewType.wrapGridView:
        return Axis.horizontal;
    }
  }
}

abstract class ListItem {
  String get listTitle;
  bool get isSelected;
  String? get imageUrl;
}

class ListItemString extends Equatable implements ListItem {
  ListItemString(this._value, this.selected);
  final String _value;
  bool selected;

  @override
  String get listTitle => _value;

  @override
  bool get isSelected => selected;

  @override
  String? get imageUrl => null;

  @override
  List<Object?> get props => [_value];
}

class SelectableView<T extends ListItem> extends StatefulWidget {
  const SelectableView(
      {required this.items,
      super.key,
      this.onSelectionChanged,
      this.itemBuilder,
      this.selectionMode = SelectableViewSelectionMode.single,
      this.viewType = SelectableViewType.verticalListView,
      this.srinkWrap = false,
      this.showsDefaultIcon = true});
  final List<T> items;
  final Function(List<T>)? onSelectionChanged;
  final Widget Function(BuildContext, T, bool)? itemBuilder;
  final SelectableViewSelectionMode selectionMode;
  final SelectableViewType viewType;
  final bool srinkWrap;
  final bool showsDefaultIcon;

  @override
  SelectableViewState<T> createState() => SelectableViewState<T>();
}

class SelectableViewState<T extends ListItem> extends State<SelectableView<T>> {
  late List<bool> _selected;
  List<T> _items = [];

  @override
  void initState() {
    _items = widget.items;
    _selected = [];
    for (final item in _items) {
      _selected.add(item.isSelected);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.viewType) {
      case SelectableViewType.wrapGridView:
        return Wrap(
          runSpacing: 15,
          spacing: 5,
          children: widget.items.enumerate().map((item) {
            if (widget.itemBuilder != null) {
              return InkWell(
                onTap: () {
                  _handleSelection(item.key);
                },
                child: widget.itemBuilder!(
                    context, item.value, _selected[item.key]),
              );
            } else {
              return _defaultItemBuilder(
                  context, item.value, item.key, _selected[item.key]);
            }
          }).toList(),
        );
      default:
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: widget.items.length,
          shrinkWrap: widget.srinkWrap,
          scrollDirection: widget.viewType.axis,
          itemBuilder: (context, index) {
            final item = widget.items[index];
            if (widget.itemBuilder != null) {
              return InkWell(
                onTap: () {
                  _handleSelection(index);
                },
                child: widget.itemBuilder!(context, item, _selected[index]),
              );
            } else {
              return _defaultItemBuilder(
                  context, item, index, _selected[index]);
            }
          },
        );
    }
  }

  Widget _defaultItemBuilder(
      BuildContext context, T item, int index, bool isSelected) {
    switch (widget.viewType) {
      case SelectableViewType.verticalListView:
        return _verticalScrollableDefaultItem(context, item, index, isSelected);
      default:
        return _horizontalScrollableDefaultItem(
            context, item, index, isSelected);
    }
  }

  Widget _verticalScrollableDefaultItem(
      BuildContext context, T item, int index, bool isSelected) {
    return ListTile(
      leading: widget.showsDefaultIcon && item.imageUrl != null
          ? AppImageView(
              avatarUrl: item.imageUrl,
              width: 40,
              height: 40,
              cornerRadius: 20,
            )
          : null, // You can replace this with your image
      title: Text(
        item.listTitle,
        style: GoogleFonts.quicksand(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.primaryElementColor),
      ), // Use the provided title
      trailing: Checkbox(
        value: _selected[index],
        checkColor: Theme.of(context).colorScheme.primaryElementColor,
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Theme.of(context).colorScheme.primary;
          }
          return Theme.of(context).primaryColor;
        }),
        onChanged: (widget.selectionMode == SelectableViewSelectionMode.single)
            ? null
            : (value) {
                _handleSelection(index);
              },
      ),
      onTap: () {
        _handleSelection(index);
      },
    );
  }

  Widget _horizontalScrollableDefaultItem(
      BuildContext context, T item, int index, bool isSelected) {
    return GestureDetector(
      onTap: () {
        _handleSelection(index);
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : AppColors.transparent,
              border: Border.all(
                  color: Theme.of(context).colorScheme.primary, width: 1.5)),
          child: Text(
            item.listTitle,
            style: isSelected
                ? Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontWeight: FontWeight.bold)
                : Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
          )),
    );
  }

  void _handleSelection(int index) {
    setState(() {
      if (widget.selectionMode == SelectableViewSelectionMode.single) {
        _selected = List<bool>.filled(widget.items.length, false);
      }
      _selected[index] = !_selected[index];
      if (widget.onSelectionChanged != null) {
        final selectedItems = getSelectedItems();
        widget.onSelectionChanged!(selectedItems);
      }
    });
  }

  List<T> getSelectedItems() {
    final selectedItems = <T>[];
    for (var i = 0; i < _selected.length; i++) {
      if (_selected[i]) {
        selectedItems.add(widget.items[i]);
      }
    }
    return selectedItems;
  }
}
