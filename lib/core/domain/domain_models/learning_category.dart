import 'package:echowater/base/utils/pair.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:uuid/uuid.dart';

import '../../../base/common_widgets/selectable_listview.dart';

enum LearningCategoryType {
  all,
  videos,
  articles;

  String get title {
    switch (this) {
      case LearningCategoryType.all:
        return 'learningCategoryType_all'.localized;
      case LearningCategoryType.videos:
        return 'learningCategoryType_videoLibrary'.localized;
      case LearningCategoryType.articles:
        return 'learningCategoryType_articles'.localized;
    }
  }
}

class LearningCategory implements ListItem {
  LearningCategory(
      {required this.id,
      required this.type,
      required this.selected,
      required this.width,
      this.isAll = false});
  final String id;
  final LearningCategoryType type;
  final int width;
  bool selected;
  bool isAll = false;

  static List<LearningCategory> getDummyLearningCategory(
      {required bool addAllCategory}) {
    final items = [
      Pair(first: LearningCategoryType.videos, second: 150),
      Pair(first: LearningCategoryType.articles, second: 100),
    ];

    final categories = items
        .map((e) => LearningCategory(
              id: const Uuid().v4(),
              type: e.first,
              width: e.second,
              selected: false,
            ))
        .toList();
    if (addAllCategory) {
      categories.insert(
          0,
          LearningCategory(
              id: const Uuid().v4(),
              type: LearningCategoryType.all,
              width: 80,
              selected: true,
              isAll: true));
    }
    return categories;
  }

  @override
  String get listTitle => type.title;

  @override
  bool get isSelected => selected;

  @override
  String? get imageUrl => '';
}
