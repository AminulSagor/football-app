import 'package:get/get.dart';

import '../../core/models/following_models.dart';
import '../../core/services/api_client.dart';
import '../../core/services/api_error_handler.dart';
import '../../core/services/following_service.dart';
import '../../core/services/storage_service.dart';
import 'model/player_profile_model.dart';
import 'player_profile_service.dart';

class PlayerProfileController extends GetxController {
  final FollowingService _followingService;
  final PlayerProfileService _playerProfileService;

  PlayerProfileController({
    required FollowingService followingService,
    required PlayerProfileService playerProfileService,
  }) : _followingService = followingService,
       _playerProfileService = playerProfileService;

  static const String _fallbackPlayerId = '874';

  final Rx<PlayerProfileViewModel> state = PlayerProfileViewModel.initial(
    playerId: _fallbackPlayerId,
    season: _defaultSeason(),
    playerName: 'Cristiano Ronaldo',
  ).obs;

  Worker? _worker;

  String _playerId = _fallbackPlayerId;
  String _selectedSeason = _defaultSeason();

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    _playerId = _resolvePlayerId(
      _readArg(args, const <String>['playerId', 'id']),
    );

    _selectedSeason =
        _readArg(args, const <String>['season']) ?? _defaultSeason();

    final initialPlayerName = _readArg(args, const <String>[
      'playerName',
      'name',
      'title',
    ]);

    final initialTeamName = _readArg(args, const <String>[
      'teamName',
      'team',
      'subtitle',
    ]);

    state.value = PlayerProfileViewModel.initial(
      playerId: _playerId,
      season: _selectedSeason,
      playerName: initialPlayerName ?? state.value.playerName,
      teamName: initialTeamName ?? state.value.teamName,
    );

    _syncFollowState();

    _worker = ever<int>(_followingService.revision, (_) => _syncFollowState());

    fetchPlayerDetails();
  }

  @override
  void onClose() {
    _worker?.dispose();
    super.onClose();
  }

  Future<void> fetchPlayerDetails() async {
    state.value = state.value.copyWith(isLoading: true, errorMessage: null);

    final response = await ApiErrorHandler.handle<PlayerProfileViewModel>(
      () => _playerProfileService.fetchPlayerDetails(
        playerId: _playerId,
        season: _selectedSeason,
        previous: state.value,
      ),
      fallbackErrorCode: 'player_profile_fetch_failed',
      userMessage: 'Unable to load player details right now.',
    );

    if (isClosed) return;

    if (!response.success || response.data == null) {
      state.value = state.value.copyWith(
        isLoading: false,
        hasLoadedOnce: true,
        errorMessage: 'Could not load player details.',
      );
      return;
    }

    state.value = response.data!.copyWith(
      isLoading: false,
      hasLoadedOnce: true,
      errorMessage: null,
      isFollowing: _followingService.isFollowing(
        FollowEntityType.player,
        _playerId,
      ),
    );
  }

  Future<void> refreshPlayerDetails() async {
    await fetchPlayerDetails();
  }

  Future<void> selectSeason(String season) async {
    final cleanSeason = season.trim();

    if (cleanSeason.isEmpty || cleanSeason == _selectedSeason) {
      return;
    }

    if (!state.value.seasons.contains(cleanSeason)) {
      return;
    }

    _selectedSeason = cleanSeason;

    state.value = state.value.copyWith(selectedSeason: cleanSeason);

    await fetchPlayerDetails();
  }

  Future<void> follow() async {
    final payload = FollowEntityPayloadModel(
      entityType: FollowEntityType.player,
      entityId: _playerId,
      entityName: state.value.playerName,
      entityLogo: state.value.avatarImageUrl,
      notificationEnabled: true,
    );

    await ApiErrorHandler.handle<FollowingActionUiModel>(
      () => _followingService.follow(payload),
      fallbackErrorCode: 'player_follow_failed',
      userMessage: 'Could not follow this player right now.',
    );
  }

  Future<void> unfollow() async {
    final payload = UnfollowPayloadModel(
      entityType: FollowEntityType.player,
      entityId: _playerId,
    );

    await ApiErrorHandler.handle<FollowingActionUiModel>(
      () => _followingService.unfollow(payload),
      fallbackErrorCode: 'player_unfollow_failed',
      userMessage: 'Could not unfollow this player right now.',
    );
  }

  void _syncFollowState() {
    state.value = state.value.copyWith(
      isFollowing: _followingService.isFollowing(
        FollowEntityType.player,
        _playerId,
      ),
    );
  }

  static String? _readArg(Object? args, List<String> keys) {
    if (args is! Map) return null;

    for (final key in keys) {
      final value = args[key];
      final text = value?.toString().trim();

      if (text != null && text.isNotEmpty) {
        return text;
      }
    }

    return null;
  }

  static String _resolvePlayerId(String? rawId) {
    final id = rawId?.trim() ?? '';

    if (RegExp(r'^\d+$').hasMatch(id)) {
      return id;
    }

    return _fallbackPlayerId;
  }

  static String _defaultSeason() {
    final now = DateTime.now();
    final seasonStartYear = now.month >= 7 ? now.year : now.year - 1;
    return seasonStartYear.toString();
  }
}

class PlayerProfileBinding extends Bindings {
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

    if (!Get.isRegistered<PlayerProfileService>()) {
      Get.lazyPut<PlayerProfileService>(
        () => PlayerProfileService(apiClient: Get.find<ApiClient>()),
        fenix: true,
      );
    }

    Get.lazyPut<PlayerProfileController>(
      () => PlayerProfileController(
        followingService: Get.find<FollowingService>(),
        playerProfileService: Get.find<PlayerProfileService>(),
      ),
    );
  }
}
