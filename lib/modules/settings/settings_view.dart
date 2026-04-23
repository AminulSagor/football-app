import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/themes/app_text_styles.dart';
import '../../core/themes/theme_controller.dart';
import '../shared/app_bar_view.dart';
import 'auth/auth_models/auth_models.dart';
import 'auth/signup_modal/views/create_account_modal_view.dart';
import 'settings_controller.dart';
import 'model/settings_models.dart';

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

          return ListView(
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
                selectedUnits: state.units,
                onUnitsChanged: controller.setUnits,
                isDarkMode: theme.brightness == Brightness.dark,
                onThemeChanged: (value) => themeController.setThemeMode(
                  value ? ThemeMode.dark : ThemeMode.light,
                ),
              ),
              if (state.isLoggedIn) ...[
                SizedBox(height: 16.h),
                const _SectionLabel(label: 'NOTIFICATIONS'),
                SizedBox(height: 12.h),
                _NotificationsCard(
                  isMatchAlertsEnabled: state.matchAlertsEnabled,
                  onMatchAlertsChanged: controller.setMatchAlertsEnabled,
                ),
              ],
              SizedBox(height: 16.h),
              const _AboutCard(),
              if (state.isLoggedIn) ...[
                SizedBox(height: 16.h),
                _LogoutCard(
                  isLoading: state.isLoggingOut,
                  onLogout: controller.logout,
                ),
              ],
            ],
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
              showEditBadge: true,
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
              height: 46.h,
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
  final SettingsUnits selectedUnits;
  final ValueChanged<SettingsUnits> onUnitsChanged;
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const _GeneralCard({
    required this.selectedUnits,
    required this.onUnitsChanged,
    required this.isDarkMode,
    required this.onThemeChanged,
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
        child: Column(
          children: [
            _ActionRow(
              icon: Icons.straighten,
              label: 'Units',
              trailing: _UnitsToggle(
                selected: selectedUnits,
                onChanged: onUnitsChanged,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Divider(color: theme.dividerColor, height: 1.h),
            ),
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
  final ValueChanged<bool> onMatchAlertsChanged;

  const _NotificationsCard({
    required this.isMatchAlertsEnabled,
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
          label: 'Match Alerts',
          trailing: Switch(
            value: isMatchAlertsEnabled,
            onChanged: onMatchAlertsChanged,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  const _AboutCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        color: theme.colorScheme.surface,
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        leading: const _RowIcon(icon: Icons.info_outline),
        title: Text(
          'About Kicscore',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: AppTextStyles.sizeBodyLarge.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Text(
          'v1.0.0',
          style: TextStyle(
            color: theme.colorScheme.onSurface.withAlpha(170),
            fontSize: AppTextStyles.sizeBody.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
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
              fontSize: AppTextStyles.sizeBodyLarge.sp,
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
      width: 44.r,
      height: 44.r,
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

class _UnitsToggle extends StatelessWidget {
  final SettingsUnits selected;
  final ValueChanged<SettingsUnits> onChanged;

  const _UnitsToggle({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 40.h,
      padding: EdgeInsets.all(3.r),
      decoration: BoxDecoration(
        color: theme.dividerColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          _ToggleItem(
            label: 'Metric',
            selected: selected == SettingsUnits.metric,
            onTap: () => onChanged(SettingsUnits.metric),
          ),
          _ToggleItem(
            label: 'Imperial',
            selected: selected == SettingsUnits.imperial,
            onTap: () => onChanged(SettingsUnits.imperial),
          ),
        ],
      ),
    );
  }
}

class _ToggleItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: selected ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface.withAlpha(180),
              fontSize: AppTextStyles.sizeBodySmall.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  final String fullName;
  final String avatarSeed;
  final bool showEditBadge;

  const _UserAvatar({
    required this.fullName,
    required this.avatarSeed,
    this.showEditBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Image.asset(
          'assets/avatars/default.png',
          width: 106.r,
          height: 106.r,
          fit: BoxFit.cover,
        ),
        if (showEditBadge)
          Positioned(
            right: 10.w,
            bottom: 10.h,
            child: Container(
              width: 23.r,
              height: 23.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary,
                border: Border.all(
                  color: theme.colorScheme.onPrimary,
                  width: 1.2,
                ),
              ),
              child: Icon(
                Icons.edit,
                size: 14.r,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
      ],
    );
  }
}
