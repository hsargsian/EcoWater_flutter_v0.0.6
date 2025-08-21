import 'package:echowater/base/utils/images.dart';
import 'package:echowater/base/utils/strings.dart';

enum LearningLinkModelType {
  support,
  digitalManual;
}

class LearningLinkModel {
  LearningLinkModel(
      {required this.title,
      required this.icon,
      required this.buttonTitle,
      required this.type});
  final String title;
  final String icon;
  final String buttonTitle;
  final LearningLinkModelType type;

  static List<LearningLinkModel> getItems() {
    return [
      LearningLinkModel(
        title: 'need_help_flask'.localized,
        icon: Images.messageIcon,
        buttonTitle: 'get_support'.localized,
        type: LearningLinkModelType.support,
      ),
      LearningLinkModel(
        title: 'need_help_view_digital_manual'.localized,
        icon: Images.bookIcon,
        buttonTitle: 'need_help_digitial_manual_view'.localized,
        type: LearningLinkModelType.digitalManual,
      )
    ];
  }
}
