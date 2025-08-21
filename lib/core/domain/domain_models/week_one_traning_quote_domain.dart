import 'package:echowater/core/domain/entities/week_one_traning_entity/week_one_traning_quote_entity.dart';

class WeekOneTraningQuoteDomain {
  WeekOneTraningQuoteDomain(this._entity);
  final WeekOneTraningQuoteEntity _entity;

  String get testimony => '"${_entity.testimony}"';
  String get author => '  -${_entity.author}';
}
