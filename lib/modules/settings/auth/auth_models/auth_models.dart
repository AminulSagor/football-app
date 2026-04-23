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
  final String fullName;
  final String email;
  final String avatarSeed;

  const SettingsUserUiModel({
    required this.fullName,
    required this.email,
    required this.avatarSeed,
  });

  factory SettingsUserUiModel.fromJson(Map<String, dynamic> json) {
    return SettingsUserUiModel(
      fullName: json['full_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      avatarSeed: json['avatar_seed'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'full_name': fullName,
      'email': email,
      'avatar_seed': avatarSeed,
    };
  }
}

class SettingsAuthSessionUiModel {
  final String token;
  final SettingsUserUiModel user;

  const SettingsAuthSessionUiModel({required this.token, required this.user});

  factory SettingsAuthSessionUiModel.fromJson(Map<String, dynamic> json) {
    return SettingsAuthSessionUiModel(
      token: json['token'] as String? ?? '',
      user: SettingsUserUiModel.fromJson(
        (json['user'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'token': token, 'user': user.toJson()};
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
  final String fullName;
  final String email;
  final String oldPassword;
  final String newPassword;
  final String confirmPassword;

  const SettingsProfileUpdatePayloadModel({
    required this.fullName,
    required this.email,
    required this.oldPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'full_name': fullName,
      'email': email,
      'old_password': oldPassword,
      'new_password': newPassword,
      'confirm_password': confirmPassword,
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
    return <String, dynamic>{
      'confirmation_name': confirmationName,
      'current_user_name': currentUserName,
    };
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
