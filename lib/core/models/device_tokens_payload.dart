class DeviceTokensPayload {
  String fcmToken;
  String platform;
  String installationId;
  String appVersion;
  String deviceModel;
  String osVersion;
  String locale;
  String timezone;

  DeviceTokensPayload({
    required this.fcmToken,
    required this.platform,
    required this.installationId,
    required this.appVersion,
    required this.deviceModel,
    required this.osVersion,
    required this.locale,
    required this.timezone,
  });

  static Map<String, dynamic> toJson(DeviceTokensPayload payload) {
    return {
      'token': payload.fcmToken,
      'platform': payload.platform,
      'installationId': payload.installationId,
      'appVersion': payload.appVersion,
      'deviceModel': payload.deviceModel,
      'osVersion': payload.osVersion,
      'locale': payload.locale,
      'timezone': payload.timezone,
    };
  }
}
