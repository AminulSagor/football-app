import 'package:get/get.dart';

import '../../core/models/following_models.dart';
import '../../core/services/api_client.dart';
import '../../core/services/api_error_handler.dart';
import '../../core/services/following_service.dart';
import '../../core/services/storage_service.dart';
import 'model/coach_profile_model.dart';
import 'service/coach_services.dart';

class CoachProfileController extends GetxController {
  final CoachServices _coachServices;
  final FollowingService _followingService;

  CoachProfileController({
    required CoachServices coachServices,
    required FollowingService followingService,
  }) : _coachServices = coachServices,
       _followingService = followingService;

  final Rx<CoachProfileViewModel> state = CoachProfileViewModel.initial().obs;

  Worker? _worker;

  String _coachId = '';
  String _teamId = '';
  String _fromDate = '';
  String _toDate = '';

  @override
  void onInit() {
    super.onInit();
    _readArguments();
    _worker = ever<int>(_followingService.revision, (_) => _syncFollowState());
    fetchCoachProfile();
  }

  @override
  void onClose() {
    _worker?.dispose();
    super.onClose();
  }

  Future<void> fetchCoachProfile() async {
    state.value = state.value.copyWith(isLoading: true, errorCode: null);

    final response = await ApiErrorHandler.handle<CoachProfileApiBundleModel>(
      () {
        if (_coachId.isNotEmpty) {
          return _coachServices.fetchCoachProfile(
            coachId: _coachId,
            teamId: _teamId,
            fromDate: _fromDate,
            toDate: _toDate,
          );
        }

        if (_teamId.isNotEmpty) {
          return _coachServices.fetchCoachByTeam(
            teamId: _teamId,
            fromDate: _fromDate,
            toDate: _toDate,
          );
        }

        throw Exception('coach_id_or_team_id_required');
      },
      fallbackErrorCode: 'coach_profile_fetch_failed',
      userMessage: 'Could not load coach profile right now.',
    );

    if (isClosed) {
      return;
    }

    if (!response.success || response.data == null) {
      state.value = state.value.copyWith(
        isLoading: false,
        errorCode: response.errorCode,
      );
      return;
    }

    final bundle = response.data!;

    _coachId = bundle.profile.id.isNotEmpty ? bundle.profile.id : _coachId;
    _teamId = bundle.profile.teamId.isNotEmpty
        ? bundle.profile.teamId
        : _teamId;

    _followingService.syncFollowState(
      entityType: FollowEntityType.coach,
      entityId: _coachId,
      isFollowing: bundle.isFollowing,
    );

    state.value = CoachProfileViewModel.fromApiBundle(
      bundle,
    ).copyWith(isLoading: false, errorCode: null);
  }

  Future<void> follow() async {
    if (_coachId.trim().isEmpty) {
      return;
    }

    final previousState = state.value;
    state.value = previousState.copyWith(isFollowing: true);

    final payload = FollowEntityPayloadModel(
      entityType: FollowEntityType.coach,
      entityId: _coachId,
      entityName: state.value.coachName,
      entityLogo: state.value.photo.isNotEmpty
          ? state.value.photo
          : state.value.teamLogo,
      notificationEnabled: true,
      metadata: <String, dynamic>{
        'teamId': state.value.teamId,
        'teamName': state.value.teamName,
      },
    );

    final response = await ApiErrorHandler.handle<FollowingActionUiModel>(
      () => _followingService.follow(payload),
      fallbackErrorCode: 'coach_follow_failed',
      userMessage: 'Could not follow this coach right now.',
    );

    if (!response.success && !isClosed) {
      state.value = previousState;
      return;
    }

    _followingService.syncFollowState(
      entityType: FollowEntityType.coach,
      entityId: _coachId,
      isFollowing: true,
    );
  }

  Future<void> unfollow() async {
    if (_coachId.trim().isEmpty) {
      return;
    }

    final previousState = state.value;
    state.value = previousState.copyWith(isFollowing: false);

    final payload = UnfollowPayloadModel(
      entityType: FollowEntityType.coach,
      entityId: _coachId,
    );

    final response = await ApiErrorHandler.handle<FollowingActionUiModel>(
      () => _followingService.unfollow(payload),
      fallbackErrorCode: 'coach_unfollow_failed',
      userMessage: 'Could not unfollow this coach right now.',
    );

    if (!response.success && !isClosed) {
      state.value = previousState;
      return;
    }

    _followingService.syncFollowState(
      entityType: FollowEntityType.coach,
      entityId: _coachId,
      isFollowing: false,
    );
  }

  void _syncFollowState() {
    if (_coachId.trim().isEmpty) {
      return;
    }

    state.value = state.value.copyWith(
      isFollowing: _followingService.isFollowing(
        FollowEntityType.coach,
        _coachId,
      ),
    );
  }

  void _readArguments() {
    final args = Get.arguments;

    if (args is Map<String, dynamic>) {
      _coachId = _readArg(args, const ['coachId', 'coach_id', 'id']);
      _teamId = _readArg(args, const ['teamId', 'team_id']);
      _fromDate = _readArg(args, const ['fromDate', 'from_date', 'from']);
      _toDate = _readArg(args, const ['toDate', 'to_date', 'to']);
      return;
    }

    if (args is String && args.trim().isNotEmpty) {
      _coachId = args.trim();
    }
  }

  String _readArg(Map<String, dynamic> args, List<String> keys) {
    for (final key in keys) {
      final value = args[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString().trim();
      }
    }

    return '';
  }
}

class CoachProfileBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<FollowingService>()) {
      Get.lazyPut<FollowingService>(
        () => FollowingService(
          apiClient: Get.find<ApiClient>(),
          storageService: Get.find<StorageService>(),
        ),
        fenix: true,
      );
    }

    if (!Get.isRegistered<CoachServices>()) {
      Get.lazyPut<CoachServices>(
        () => CoachServices(apiClient: Get.find<ApiClient>()),
        fenix: true,
      );
    }

    Get.lazyPut<CoachProfileController>(
      () => CoachProfileController(
        coachServices: Get.find<CoachServices>(),
        followingService: Get.find<FollowingService>(),
      ),
    );
  }
}
