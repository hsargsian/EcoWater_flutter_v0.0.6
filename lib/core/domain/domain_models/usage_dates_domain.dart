import 'package:echowater/core/domain/entities/usage_dates_entity/usage_dates_entity.dart';

class UsageDatesDomain {
  UsageDatesDomain(this._entity);
  final UsageDatesEntity _entity;

  List<DateTime> get dates => _entity.usageDates.map(DateTime.parse).toList();
}
