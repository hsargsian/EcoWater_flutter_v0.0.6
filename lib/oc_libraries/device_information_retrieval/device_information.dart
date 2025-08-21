class DeviceInformation {
  DeviceInformation(
      {required this.name,
      required this.platform,
      required this.isPhysicalDevice,
      required this.model,
      required this.osVersion});
  final String name;
  final String platform;
  final bool isPhysicalDevice;
  final String model;
  final String osVersion;

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Platform': platform,
      'Is physical device': isPhysicalDevice,
      'Model': model,
      'OS version': osVersion
    };
  }
}
