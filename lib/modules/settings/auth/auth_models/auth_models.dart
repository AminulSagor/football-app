class SettingsSignInPayloadModel {
  final String email;
  final String password;

  const SettingsSignInPayloadModel({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'email': email, 'password': password};
  }
}

class SettingsLoadSessionPayloadModel {
  const SettingsLoadSessionPayloadModel();

  Map<String, dynamic> toJson() {
    return <String, dynamic>{};
  }
}

class SettingsUserUiModel {
  final String id;
  final String fullName;
  final String email;
  final String role;
  final String avatarSeed;
  final String profilePhotoFileId;
  final String photoReadUrl;

  const SettingsUserUiModel({
    this.id = '',
    required this.fullName,
    required this.email,
    this.role = '',
    required this.avatarSeed,
    this.profilePhotoFileId = '',
    this.photoReadUrl = '',
  });

  bool get hasProfilePhoto => photoReadUrl.trim().isNotEmpty;

  factory SettingsUserUiModel.fromJson(Map<String, dynamic> json) {
    final profile = json['profile'] is Map<String, dynamic>
        ? json['profile'] as Map<String, dynamic>
        : <String, dynamic>{};

    final fullName =
        json['fullName'] as String? ??
        json['full_name'] as String? ??
        profile['fullName'] as String? ??
        '';

    return SettingsUserUiModel(
      id: json['id'] as String? ?? '',
      fullName: fullName,
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? '',
      avatarSeed: fullName,
      profilePhotoFileId:
          json['profilePhotoFileId'] as String? ??
          profile['profilePhotoFileId'] as String? ??
          '',
      photoReadUrl:
          json['photoReadUrl'] as String? ??
          profile['photoReadUrl'] as String? ??
          '',
    );
  }

  SettingsUserUiModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? role,
    String? avatarSeed,
    String? profilePhotoFileId,
    String? photoReadUrl,
  }) {
    return SettingsUserUiModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      avatarSeed: avatarSeed ?? this.avatarSeed,
      profilePhotoFileId: profilePhotoFileId ?? this.profilePhotoFileId,
      photoReadUrl: photoReadUrl ?? this.photoReadUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'fullName': fullName,
      'email': email,
      'role': role,
      'avatarSeed': avatarSeed,
      'profilePhotoFileId': profilePhotoFileId,
      'photoReadUrl': photoReadUrl,
    };
  }
}

class SettingsAuthTokenUiModel {
  final String accessToken;
  final String tokenType;
  final String expiresIn;

  const SettingsAuthTokenUiModel({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
  });

  factory SettingsAuthTokenUiModel.fromJson(Map<String, dynamic> json) {
    return SettingsAuthTokenUiModel(
      accessToken: json['accessToken'] as String? ?? '',
      tokenType: json['tokenType'] as String? ?? '',
      expiresIn: json['expiresIn'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'accessToken': accessToken,
      'tokenType': tokenType,
      'expiresIn': expiresIn,
    };
  }
}

class SettingsAuthSessionUiModel {
  final SettingsAuthTokenUiModel token;
  final SettingsUserUiModel user;

  const SettingsAuthSessionUiModel({required this.token, required this.user});

  factory SettingsAuthSessionUiModel.fromJson(Map<String, dynamic> json) {
    return SettingsAuthSessionUiModel(
      token: SettingsAuthTokenUiModel.fromJson(
        (json['token'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      ),
      user: SettingsUserUiModel.fromJson(
        (json['user'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'token': token.toJson(), 'user': user.toJson()};
  }
}

class SettingsLogoutPayloadModel {
  final String token;

  const SettingsLogoutPayloadModel({required this.token});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'token': token};
  }
}

class SettingsLogoutUiModel {
  final bool loggedOut;

  const SettingsLogoutUiModel({required this.loggedOut});

  factory SettingsLogoutUiModel.fromJson(Map<String, dynamic> json) {
    return SettingsLogoutUiModel(
      loggedOut: json['logged_out'] as bool? ?? false,
    );
  }
}

class SettingsProfileUpdatePayloadModel {
  final String initialFullName;
  final String fullName;
  final String email;
  final String oldPassword;
  final String newPassword;
  final String confirmPassword;

  const SettingsProfileUpdatePayloadModel({
    this.initialFullName = '',
    required this.fullName,
    required this.email,
    required this.oldPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  bool get hasProfileChanges => fullName.trim() != initialFullName.trim();

  bool get hasPasswordChanges =>
      oldPassword.isNotEmpty ||
      newPassword.isNotEmpty ||
      confirmPassword.isNotEmpty;

  Map<String, dynamic> toProfileJson() {
    return <String, dynamic>{'fullName': fullName.trim()};
  }

  Map<String, dynamic> toPasswordJson() {
    return <String, dynamic>{
      'currentPassword': oldPassword,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };
  }
}

class SettingsProfileUpdateUiModel {
  final bool updated;
  final SettingsUserUiModel user;

  const SettingsProfileUpdateUiModel({
    required this.updated,
    required this.user,
  });

  factory SettingsProfileUpdateUiModel.fromJson(Map<String, dynamic> json) {
    return SettingsProfileUpdateUiModel(
      updated: json['updated'] as bool? ?? false,
      user: SettingsUserUiModel.fromJson(
        (json['user'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      ),
    );
  }
}

class SettingsDeleteAccountPayloadModel {
  final String confirmationName;
  final String currentUserName;

  const SettingsDeleteAccountPayloadModel({
    required this.confirmationName,
    required this.currentUserName,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'fullName': confirmationName.trim()};
  }
}

class SettingsDeleteAccountUiModel {
  final bool deleted;

  const SettingsDeleteAccountUiModel({required this.deleted});

  factory SettingsDeleteAccountUiModel.fromJson(Map<String, dynamic> json) {
    return SettingsDeleteAccountUiModel(
      deleted: json['deleted'] as bool? ?? false,
    );
  }
}

class SettingsNotificationPreferencesUiModel {
  final bool pushEnabled;
  final bool inAppEnabled;
  final bool matchAlertsEnabled;
  final bool teamAlertsEnabled;
  final bool leagueAlertsEnabled;
  final bool playerAlertsEnabled;
  final bool newsEnabled;
  final bool dailyDigestEnabled;
  final bool weeklyDigestEnabled;
  final bool quietHoursEnabled;
  final String quietHoursStart;
  final String quietHoursEnd;
  final String timezone;

  const SettingsNotificationPreferencesUiModel({
    this.pushEnabled = true,
    this.inAppEnabled = true,
    this.matchAlertsEnabled = true,
    this.teamAlertsEnabled = true,
    this.leagueAlertsEnabled = true,
    this.playerAlertsEnabled = true,
    this.newsEnabled = true,
    this.dailyDigestEnabled = true,
    this.weeklyDigestEnabled = true,
    this.quietHoursEnabled = true,
    this.quietHoursStart = '22:00',
    this.quietHoursEnd = '07:00',
    this.timezone = 'UTC',
  });

  factory SettingsNotificationPreferencesUiModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final source = json['preferences'] is Map<String, dynamic>
        ? json['preferences'] as Map<String, dynamic>
        : json;

    return SettingsNotificationPreferencesUiModel(
      pushEnabled: _readBool(source, 'pushEnabled', true),
      inAppEnabled: _readBool(source, 'inAppEnabled', true),
      matchAlertsEnabled: _readBool(source, 'matchAlertsEnabled', true),
      teamAlertsEnabled: _readBool(source, 'teamAlertsEnabled', true),
      leagueAlertsEnabled: _readBool(source, 'leagueAlertsEnabled', true),
      playerAlertsEnabled: _readBool(source, 'playerAlertsEnabled', true),
      newsEnabled: _readBool(source, 'newsEnabled', true),
      dailyDigestEnabled: _readBool(source, 'dailyDigestEnabled', true),
      weeklyDigestEnabled: _readBool(source, 'weeklyDigestEnabled', true),
      quietHoursEnabled: _readBool(source, 'quietHoursEnabled', true),
      quietHoursStart:
          source['quietHoursStart'] as String? ??
          source['quiet_hours_start'] as String? ??
          '22:00',
      quietHoursEnd:
          source['quietHoursEnd'] as String? ??
          source['quiet_hours_end'] as String? ??
          '07:00',
      timezone:
          source['timezone'] as String? ??
          source['timeZone'] as String? ??
          'UTC',
    );
  }

  static bool _readBool(Map<String, dynamic> json, String key, bool fallback) {
    final value = json[key];
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    return fallback;
  }
}

class SettingsNotificationPreferencesPayloadModel {
  final String installationId;
  final bool enabled;
  final String quietHoursStart;
  final String quietHoursEnd;
  final String timezone;

  const SettingsNotificationPreferencesPayloadModel({
    required this.installationId,
    required this.enabled,
    required this.timezone,
    this.quietHoursStart = '22:00',
    this.quietHoursEnd = '07:00',
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'installationId': installationId,
      'pushEnabled': enabled,
      'inAppEnabled': enabled,
      'matchAlertsEnabled': enabled,
      'teamAlertsEnabled': enabled,
      'leagueAlertsEnabled': enabled,
      'playerAlertsEnabled': enabled,
      'newsEnabled': enabled,
      'dailyDigestEnabled': enabled,
      'weeklyDigestEnabled': enabled,
      'quietHoursEnabled': enabled,
      'quietHoursStart': quietHoursStart,
      'quietHoursEnd': quietHoursEnd,
      'timezone': timezone,
    };
  }
}
