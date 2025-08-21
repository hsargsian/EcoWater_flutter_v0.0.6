enum ProtocolType {
  custom,
  template,
  topProtocols;

  String get name {
    switch (this) {
      case ProtocolType.custom:
        return 'custom';
      case ProtocolType.template:
        return 'template';
      case ProtocolType.topProtocols:
        return 'top_protocols';
    }
  }
}
