import 'package:echowater/core/domain/entities/system_access_entity/system_access_entity.dart';
import 'package:intl/intl.dart';

class SystemAccessStateDomain {
  const SystemAccessStateDomain(this._entity);
  final SystemAccessEntity _entity;

  bool get canAccessSystem => _entity.canAccessSystem;
  DateTime accessDate() {
    try {
      final format = DateFormat('yyyy-MM-ddTHH:mm:ss.sssZ');
      return format.parseUtc(_entity.accessDate);
    } catch (e) {
      return DateTime(2025, 2, 5);
    }
  }
}
