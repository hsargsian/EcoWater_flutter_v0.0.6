import 'package:equatable/equatable.dart';

import '../entities/faq_entity/faq_entity.dart';

class FaqDomain extends Equatable {
  FaqDomain(this._faqEntity);
  final FaqEntity _faqEntity;
  var isExpanded = false;

  String get id => _faqEntity.id;

  @override
  List<Object?> get props => [id];

  String get tilte => _faqEntity.question;
  String get detail => _faqEntity.answer;
}
