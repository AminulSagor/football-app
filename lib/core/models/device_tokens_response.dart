class DeviceTokenResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final DeviceTokenData data;
  final DateTime timestamp;
  final String path;

  DeviceTokenResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.timestamp,
    required this.path,
  });

  factory DeviceTokenResponseModel.fromJson(Map<String, dynamic> json) {
    return DeviceTokenResponseModel(
      success: json['success'] as bool? ?? false,
      statusCode: json['statusCode'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      data: DeviceTokenData.fromJson(json['data'] as Map<String, dynamic>),
      timestamp: DateTime.parse(json['timestamp'] as String),
      path: json['path'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'statusCode': statusCode,
      'message': message,
      'data': data.toJson(),
      'timestamp': timestamp.toIso8601String(),
      'path': path,
    };
  }
}

class DeviceTokenData {
  final String id;
  final String token;
  final String platform;
  final String installationId;
  final String? userId;
  final String appVersion;
  final String deviceModel;
  final String osVersion;
  final String locale;
  final String timezone;
  final bool isActive;
  final DateTime lastSeenAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  DeviceTokenData({
    required this.id,
    required this.token,
    required this.platform,
    required this.installationId,
    required this.userId,
    required this.appVersion,
    required this.deviceModel,
    required this.osVersion,
    required this.locale,
    required this.timezone,
    required this.isActive,
    required this.lastSeenAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DeviceTokenData.fromJson(Map<String, dynamic> json) {
    return DeviceTokenData(
      id: json['id'] as String? ?? '',
      token: json['token'] as String? ?? '',
      platform: json['platform'] as String? ?? '',
      installationId: json['installationId'] as String? ?? '',
      userId: json['userId'] as String?,
      appVersion: json['appVersion'] as String? ?? '',
      deviceModel: json['deviceModel'] as String? ?? '',
      osVersion: json['osVersion'] as String? ?? '',
      locale: json['locale'] as String? ?? '',
      timezone: json['timezone'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? false,
      lastSeenAt: DateTime.parse(json['lastSeenAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'token': token,
      'platform': platform,
      'installationId': installationId,
      'userId': userId,
      'appVersion': appVersion,
      'deviceModel': deviceModel,
      'osVersion': osVersion,
      'locale': locale,
      'timezone': timezone,
      'isActive': isActive,
      'lastSeenAt': lastSeenAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
