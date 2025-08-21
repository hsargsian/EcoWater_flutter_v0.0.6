class CustomizeProtocolActiveRequestEntity {
  CustomizeProtocolActiveRequestEntity({
    required this.protocolType,
    required this.protocolId,
    required this.updateGoals,
    required this.activate,
  });

  String protocolType;
  int protocolId;
  bool updateGoals;
  bool activate;
}
