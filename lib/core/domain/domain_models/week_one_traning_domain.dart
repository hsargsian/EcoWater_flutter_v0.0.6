import 'package:echowater/core/domain/domain_models/week_one_traning_quote_domain.dart';
import 'package:echowater/core/domain/entities/week_one_traning_entity/week_one_traning_entity.dart';

class WeekOneTraningDomain {
  WeekOneTraningDomain(this._entity);
  final WeekOneTraningEntity _entity;

  String get tagTitle => _entity.tagTitle;

  String? get image => _entity.image;
  String? get title => _entity.title;
  String? get description => _entity.description;
  List<String> get checkItems => _entity.checkItems ?? [];
  String get subDesctiption => _entity.subDesctiption ?? '';
  List<WeekOneTraningQuoteDomain> get quotes =>
      (_entity.quotes ?? []).map(WeekOneTraningQuoteDomain.new).toList();
}
