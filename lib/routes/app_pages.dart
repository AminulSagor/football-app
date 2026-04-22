import 'package:get/get.dart';
import '../core/bootstrap/bootstrap_view.dart';
import '../modules/bottom_nav_bar/bottom_nav_bar_view.dart';
import '../modules/bottom_nav_bar/bottom_nav_bar_controller.dart';
import '../modules/leagues/league_detials/league_details_controller.dart';
import '../modules/leagues/league_detials/views/league_details.dart';
import '../modules/settings/edit_profile_view.dart';
import '../modules/coach_profile/coach_profile_controller.dart';
import '../modules/coach_profile/views/coach_profile_view.dart';
import '../modules/player_profile/player_profile_controller.dart';
import '../modules/player_profile/views/player_profile_view.dart';
import '../modules/team/team_profile_controller.dart';
import '../modules/team/views/team_profile_view.dart';
import '../modules/settings/auth/forgot_password/forgot_password_controller.dart';
import '../modules/settings/auth/forgot_password/forgot_password_views.dart';
import '../modules/settings/auth/signup_modal/verification_pending_OTP_view.dart';
import '../modules/settings/auth/signup_modal/verfied_profile_pic_upload.dart';
import '../modules/settings/auth/signup_modal/signup_controller.dart';
import '../modules/settings/settings_controller.dart';
import '../modules/matches/match_detials/match_details_controller.dart';
import '../modules/matches/match_detials/views/match_detials_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = AppRoutes.bootstrap;

  static final routes = [
    GetPage(name: AppRoutes.bootstrap, page: () => BootstrapView()),

    GetPage(
      name: AppRoutes.bottomNav,
      page: () => const BottomNavBarView(),
      binding: BottomNavBinding(),
    ),

    GetPage(
      name: AppRoutes.leagueDetails,
      page: () => const LeagueDetailsPage(),
      binding: LeagueDetailsBinding(),
    ),

    GetPage(
      name: AppRoutes.signupOtp,
      page: () => const VerificationPendingOtpView(),
      binding: SignupOtpBinding(),
    ),

    GetPage(
      name: AppRoutes.accountCreated,
      page: () => const VerifiedProfilePicUploadView(),
      binding: AccountCreatedBinding(),
    ),

    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordOtpView(),
      binding: ForgotPasswordOtpBinding(),
    ),

    GetPage(
      name: AppRoutes.forgotPasswordOtp,
      page: () => const ForgotPasswordOtpView(),
      binding: ForgotPasswordOtpBinding(),
    ),

    GetPage(
      name: AppRoutes.resetPassword,
      page: () => const ForgotPasswordResetView(),
      binding: ForgotPasswordResetBinding(),
    ),

    GetPage(
      name: AppRoutes.forgotPasswordSuccess,
      page: () => const ForgotPasswordSuccessView(),
      binding: ForgotPasswordSuccessBinding(),
    ),

    GetPage(
      name: AppRoutes.settingsEditProfile,
      page: () => const EditProfileView(),
      binding: SettingsBinding(),
    ),

    GetPage(
      name: AppRoutes.matchDetails,
      page: () => const MatchDetialsView(),
      binding: MatchDetailsBinding(),
    ),

    GetPage(
      name: AppRoutes.teamProfile,
      page: () => const TeamProfileView(),
      binding: TeamProfileBinding(),
    ),

    GetPage(
      name: AppRoutes.playerProfile,
      page: () => const PlayerProfileView(),
      binding: PlayerProfileBinding(),
    ),

    GetPage(
      name: AppRoutes.coachProfile,
      page: () => const CoachProfileView(),
      binding: CoachProfileBinding(),
    ),
  ];
}
