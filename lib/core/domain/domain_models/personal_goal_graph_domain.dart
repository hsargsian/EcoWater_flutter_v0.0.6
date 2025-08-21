import 'dart:math';

import 'package:echowater/base/utils/date_utils.dart';
import 'package:echowater/core/domain/entities/personal_goal_graph_entity/personal_goal_graph_entity.dart';

class PersonalGoalGraphDomain {
  const PersonalGoalGraphDomain(this._entity);

  final PersonalGoalGraphEntity _entity;

  num get goal => _entity.goalAmount;

  num get actual => _entity.progress;

  String get date => _entity.date;

  static List<PersonalGoalGraphDomain> getDummyData() {
    final now = DateTime.now();
    final data = <PersonalGoalGraphDomain>[];
    var startOfWeek = now.startOfWeek;
    final random = Random();
    List.generate(7, (index) {
      data.add(PersonalGoalGraphDomain(PersonalGoalGraphEntity(startOfWeek.defaultStringDateFormat, 10, random.nextInt(6))));
      startOfWeek = startOfWeek.add(const Duration(days: 1));
    });
    return data;
  }
}
