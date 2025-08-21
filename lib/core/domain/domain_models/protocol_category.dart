import 'package:echowater/core/domain/entities/protocol_wrapper_entity/protocol_category_entity.dart';
import '../../../base/common_widgets/selectable_listview.dart';

class ProtocolCategoryDomain implements ListItem {
  ProtocolCategoryDomain(this._entity);
  final ProtocolCategoryEntity _entity;

  bool selected = false;
  bool isAll = false;

  @override
  String get listTitle => _entity.title;

  String get key => _entity.key;

  @override
  bool get isSelected => selected;

  @override
  String? get imageUrl => '';
}
