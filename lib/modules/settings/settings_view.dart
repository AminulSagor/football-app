import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/themes/app_text_styles.dart';
import '../../core/themes/theme_controller.dart';
import '../../core/widgets/app_bar_view.dart';
import '../../core/widgets/app_cached_network_image.dart';
import 'auth/auth_models/auth_models.dart';
import 'auth/signup_modal/views/create_account_modal_view.dart';
import '../../routes/app_routes.dart';
import 'settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeController = Get.find<ThemeController>();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.scaffoldBackgroundColor,
            theme.colorScheme.surface.withAlpha(
              theme.brightness == Brightness.dark ? 40 : 14,
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: Obx(() {
          final state = controller.state.value;

          return RefreshIndicator(
            onRefresh: controller.refreshSettings,
            color: theme.colorScheme.primary,
            child: ListView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 22.h),
              children: [
                CustomAppBar(
                  title: 'Settings',
                  padding: EdgeInsets.only(top: 2.h, bottom: 12.h),
                  titleStyle: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontSize: (AppTextStyles.sizeTitle + 2).sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (state.isRestoringSession && !state.isLoggedIn)
                  const _SessionLoadingCard()
                else if (state.isLoggedIn)
                  _LoggedInProfileCard(
                    user: state.user!,
                    onEditProfile: controller.openEditProfile,
                  )
                else
                  _GuestExperienceCard(
                    isSigningIn: state.isSigningIn,
                    onSignIn: () => controller.openSignInModal(context),
                    onJoin: () => CreateAccountModalView.show(context),
                  ),
                SizedBox(height: 16.h),
                const _SectionLabel(label: 'GENERAL'),
                SizedBox(height: 12.h),
                _GeneralCard(
                  isDarkMode: theme.brightness == Brightness.dark,
                  onThemeChanged: (value) => themeController.setThemeMode(
                    value ? ThemeMode.dark : ThemeMode.light,
                  ),
                ),
                // if (state.isLoggedIn) ...[
                SizedBox(height: 16.h),
                const _SectionLabel(label: 'NOTIFICATIONS'),
                SizedBox(height: 12.h),
                _NotificationsCard(
                  isMatchAlertsEnabled: state.matchAlertsEnabled,
                  isUpdating: state.isUpdatingMatchAlerts,
                  onMatchAlertsChanged: controller.setMatchAlertsEnabled,
                ),
                // ],
                SizedBox(height: 16.h),
                _InfoLinksCard(
                  onAboutTap: () => Get.toNamed(AppRoutes.aboutKicscore),
                  onPrivacyTap: () => Get.toNamed(AppRoutes.privacyPolicy),
                  onTermsTap: () => Get.toNamed(AppRoutes.termsAndCondition),
                ),
                if (state.isLoggedIn) ...[
                  SizedBox(height: 16.h),
                  _LogoutCard(
                    isLoading: state.isLoggingOut,
                    onLogout: controller.logout,
                  ),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _SessionLoadingCard extends StatelessWidget {
  const _SessionLoadingCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 252.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.dividerColor, width: 1.w),
      ),
      alignment: Alignment.center,
      child: SizedBox(
        width: 24.r,
        height: 24.r,
        child: CircularProgressIndicator(
          strokeWidth: 2.2.w,
          valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
        ),
      ),
    );
  }
}

class _GuestExperienceCard extends StatelessWidget {
  final bool isSigningIn;
  final VoidCallback onSignIn;
  final VoidCallback onJoin;

  const _GuestExperienceCard({
    required this.isSigningIn,
    required this.onSignIn,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.dividerColor, width: 1.w),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Experience More',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: AppTextStyles.sizeTitle.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'Sign in to sync your favorites across devices and get personalized match updates.',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withAlpha(180),
                fontSize: AppTextStyles.sizeBodySmall.sp,
                height: 1.45,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                ),
                onPressed: isSigningIn ? null : onSignIn,
                child: isSigningIn
                    ? SizedBox(
                        width: 20.r,
                        height: 20.r,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.1.w,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            theme.colorScheme.onPrimary,
                          ),
                        ),
                      )
                    : const Text('Sign In'),
              ),
            ),
            SizedBox(height: 10.h),
            Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  textStyle: TextStyle(
                    fontSize: AppTextStyles.sizeBodySmall.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onPressed: onJoin,
                child: const Text('New to Kicscore? Join Kicscore'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoggedInProfileCard extends StatelessWidget {
  final SettingsUserUiModel user;
  final VoidCallback onEditProfile;

  const _LoggedInProfileCard({required this.user, required this.onEditProfile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.dividerColor, width: 1.w),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(14.w, 22.h, 14.w, 24.h),
        child: Column(
          children: [
            _UserAvatar(
              fullName: user.fullName,
              avatarSeed: user.avatarSeed,
              photoReadUrl: user.photoReadUrl,
            ),
            SizedBox(height: 14.h),
            Text(
              user.fullName,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: AppTextStyles.sizeHeading.sp,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              height: 40.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                ),
                onPressed: onEditProfile,
                child: const Text('Edit Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GeneralCard extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const _GeneralCard({required this.isDarkMode, required this.onThemeChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        color: theme.colorScheme.surface,
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
        child: Column(
          children: [
            _ActionRow(
              icon: isDarkMode
                  ? Icons.dark_mode_outlined
                  : Icons.wb_sunny_outlined,
              label: 'Theme',
              trailing: Switch(
                value: isDarkMode,
                onChanged: onThemeChanged,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationsCard extends StatelessWidget {
  final bool isMatchAlertsEnabled;
  final bool isUpdating;
  final ValueChanged<bool> onMatchAlertsChanged;

  const _NotificationsCard({
    required this.isMatchAlertsEnabled,
    required this.isUpdating,
    required this.onMatchAlertsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        color: theme.colorScheme.surface,
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
        child: _ActionRow(
          icon: Icons.notifications_none,
          label: 'Notification alerts',
          trailing: isUpdating
              ? SizedBox(
                  width: 22.r,
                  height: 22.r,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.w,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.secondary,
                    ),
                  ),
                )
              : Switch(
                  value: isMatchAlertsEnabled,
                  onChanged: onMatchAlertsChanged,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
        ),
      ),
    );
  }
}

class _InfoLinksCard extends StatelessWidget {
  final VoidCallback onAboutTap;
  final VoidCallback onPrivacyTap;
  final VoidCallback onTermsTap;

  const _InfoLinksCard({
    required this.onAboutTap,
    required this.onPrivacyTap,
    required this.onTermsTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        color: theme.colorScheme.surface,
      ),
      child: Column(
        children: [
          _SettingsLinkTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: onPrivacyTap,
          ),
          Divider(height: 1.h, color: theme.dividerColor.withAlpha(120)),
          _SettingsLinkTile(
            icon: Icons.description_outlined,
            title: 'Terms & Condition',
            onTap: onTermsTap,
          ),
          Divider(height: 1.h, color: theme.dividerColor.withAlpha(120)),
          _SettingsLinkTile(
            icon: Icons.info_outline,
            title: 'About Kicscore',
            trailingText: 'v1.0.1',
            onTap: onAboutTap,
          ),
        ],
      ),
    );
  }
}

class _SettingsLinkTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailingText;
  final VoidCallback onTap;

  const _SettingsLinkTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailingText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      leading: _RowIcon(icon: icon),
      title: Text(
        title,
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontSize: AppTextStyles.sizeBodySmall.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: trailingText != null
          ? Text(
              trailingText!,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withAlpha(170),
                fontSize: AppTextStyles.sizeCaption.sp,
                fontWeight: FontWeight.w400,
              ),
            )
          : Icon(
              Icons.chevron_right_rounded,
              color: theme.colorScheme.onSurface.withAlpha(150),
              size: 22.r,
            ),
      onTap: onTap,
    );
  }
}

class _LogoutCard extends StatelessWidget {
  final bool isLoading;
  final Future<void> Function() onLogout;

  const _LogoutCard({required this.isLoading, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(24.r),
      onTap: isLoading ? null : () => onLogout(),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          color: theme.colorScheme.surface,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: Row(
            children: [
              _RowIcon(
                icon: Icons.logout,
                backgroundColor: theme.colorScheme.error.withAlpha(38),
                iconColor: theme.colorScheme.error,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'Logout',
                  style: TextStyle(
                    color: theme.colorScheme.error,
                    fontSize: AppTextStyles.sizeBodyLarge.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (isLoading)
                SizedBox(
                  width: 18.r,
                  height: 18.r,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.1.w,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.error,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      label,
      style: theme.textTheme.labelMedium?.copyWith(
        color: theme.colorScheme.onSurface.withAlpha(145),
        fontSize: AppTextStyles.sizeCaption.sp,
        letterSpacing: 1.4.sp,
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget trailing;

  const _ActionRow({
    required this.icon,
    required this.label,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        _RowIcon(icon: icon),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: AppTextStyles.sizeBodySmall.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        trailing,
      ],
    );
  }
}

class _RowIcon extends StatelessWidget {
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;

  const _RowIcon({required this.icon, this.backgroundColor, this.iconColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 40.r,
      height: 40.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? theme.scaffoldBackgroundColor.withAlpha(170),
      ),
      child: Icon(
        icon,
        size: 20.r,
        color: iconColor ?? theme.colorScheme.onSurface.withAlpha(190),
      ),
    );
  }
}

Widget buildDefaultAvatar(BuildContext context, double size) {
  final theme = Theme.of(context);
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: theme.colorScheme.surfaceContainerHighest,
    ),
    child: Icon(
      Icons.person,
      size: (size / 1.8).r,
      color: theme.colorScheme.onSurfaceVariant,
    ),
  );
}

class _UserAvatar extends StatelessWidget {
  final String fullName;
  final String avatarSeed;
  final String photoReadUrl;

  const _UserAvatar({
    required this.fullName,
    required this.avatarSeed,
    this.photoReadUrl = '',
  });

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoReadUrl.trim().isNotEmpty;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipOval(
          child: hasPhoto
              ? AppCachedNetworkImage(
                  imageUrl: photoReadUrl,
                  width: 106.r,
                  height: 106.r,
                  fit: BoxFit.cover,
                  errorBuilder: (context) {
                    return buildDefaultAvatar(context, 106.r);
                  },
                )
              : buildDefaultAvatar(context, 106.r),
        ),
      ],
    );
  }
}
