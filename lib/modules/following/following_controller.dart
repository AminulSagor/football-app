import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/models/following_models.dart';
import '../../core/services/api_client.dart';
import '../../core/services/api_error_handler.dart';
import '../../core/services/following_service.dart';
import '../../core/services/storage_service.dart';
import '../leagues/model/leagues_models.dart';
import '../../routes/app_routes.dart';
import 'model/following_model.dart';

class FollowingController extends GetxController {
  final FollowingService _followingService;

  FollowingController({required FollowingService followingService})
    : _followingService = followingService;

  final Rx<FollowingViewModel> state = const FollowingViewModel().obs;
  Worker? _worker;

  Map<FollowEntityType, List<FollowingItemUiModel>> _remoteFollowingItems =
      <FollowEntityType, List<FollowingItemUiModel>>{};

  // Hardcoded follow data removed in favor of backend hydration.
  static const List<FollowingItemUiModel> _leagueItems =
      <FollowingItemUiModel>[];
  static const List<FollowingItemUiModel> _playerItems =
      <FollowingItemUiModel>[];
  static const List<FollowingItemUiModel> _teamItems = <FollowingItemUiModel>[];
  static const List<FollowingItemUiModel> _coachItems =
      <FollowingItemUiModel>[];

  @override
  void onInit() {
    super.onInit();
    _rebuildState();
    _worker = ever<int>(_followingService.revision, (_) => _rebuildState());
  }

  @override
  void onClose() {
    _worker?.dispose();
    super.onClose();
  }

  void selectTab(FollowingTabType tab) {
    if (tab == state.value.selectedTab) {
      return;
    }
    state.value = state.value.copyWith(selectedTab: tab);
  }

  bool isFollowing(FollowEntityType type, String id) {
    return _followingService.isFollowing(type, id);
  }

  Future<void> follow(FollowingItemUiModel item) async {
    final payload = _buildFollowPayload(item);

    await ApiErrorHandler.handle<FollowingActionUiModel>(
      () => _followingService.follow(payload),
      fallbackErrorCode: 'follow_entity_failed',
      userMessage: 'Could not follow this right now.',
    );
  }

  Future<void> unfollow(FollowingItemUiModel item) async {
    final payload = UnfollowPayloadModel(
      entityType: item.type,
      entityId: item.id,
    );

    await ApiErrorHandler.handle<FollowingActionUiModel>(
      () => _followingService.unfollow(payload),
      fallbackErrorCode: 'unfollow_entity_failed',
      userMessage: 'Could not unfollow this right now.',
    );
  }

  Future<void> refreshFollows() async {
    const payload = FollowListPayloadModel();

    final response = await ApiErrorHandler.handle<FollowingListUiModel>(
      () => _followingService.fetchFollows(payload),
      fallbackErrorCode: 'fetch_follows_failed',
      userMessage: 'Could not load follows right now.',
    );

    if (!response.success || response.data == null) {
      return;
    }

    _applyRemoteFollows(response.data!.items);
  }

  void openItem(FollowingItemUiModel item) {
    switch (item.type) {
      case FollowEntityType.league:
        Get.toNamed(
          AppRoutes.leagueDetails,
          arguments: LeaguesTopLeagueUiModel(
            leagueId: item.id,
            image: 'assets/images/Overlay (1).png',
            leagueName: item.title,
            badgeSeed: item.seed,
            badgeHex: '#0E8B67',
          ),
        );
        break;
      case FollowEntityType.player:
        final arguments = <String, dynamic>{
          'playerId': item.id,
          'playerName': item.title,
          'teamName': item.subtitle,
        };

        final teamId = item.teamId?.trim();
        if (teamId != null && teamId.isNotEmpty) {
          arguments['teamId'] = teamId;
        }

        Get.toNamed(AppRoutes.playerProfile, arguments: arguments);
        break;
      case FollowEntityType.team:
        Get.toNamed(
          AppRoutes.teamProfile,
          arguments: <String, dynamic>{'teamId': item.id},
        );
        break;
      case FollowEntityType.coach:
        Get.toNamed(
          AppRoutes.coachProfile,
          arguments: <String, dynamic>{'id': item.id},
        );
        break;
      case FollowEntityType.match:
        break;
    }
  }

  FollowingTabSectionUiModel _buildSection(List<FollowingItemUiModel> items) {
    return FollowingTabSectionUiModel(
      followingItems: items
          .where((item) => _followingService.isFollowing(item.type, item.id))
          .toList(growable: false),
      trendingItems: items
          .where((item) => !_followingService.isFollowing(item.type, item.id))
          .toList(growable: false),
    );
  }

  FollowingTabSectionUiModel _buildSectionWithRemote(
    List<FollowingItemUiModel> items,
    FollowEntityType type,
  ) {
    final remoteItems = _remoteFollowingItems[type];
    if (remoteItems == null || remoteItems.isEmpty) {
      return _buildSection(items);
    }

    final remoteIds = remoteItems.map((item) => item.id).toSet();

    return FollowingTabSectionUiModel(
      followingItems: remoteItems,
      trendingItems: items
          .where((item) => !remoteIds.contains(item.id))
          .toList(growable: false),
    );
  }

  void _rebuildState() {
    state.value = state.value.copyWith(
      leagues: _buildSectionWithRemote(_leagueItems, FollowEntityType.league),
      players: _buildSectionWithRemote(_playerItems, FollowEntityType.player),
      teams: _buildSectionWithRemote(_teamItems, FollowEntityType.team),
      coach: _buildSectionWithRemote(_coachItems, FollowEntityType.coach),
    );
  }

  FollowEntityPayloadModel _buildFollowPayload(FollowingItemUiModel item) {
    return FollowEntityPayloadModel(
      entityType: item.type,
      entityId: item.id,
      entityName: item.title,
      entityLogo: item.entityLogo,
      notificationEnabled: true,
    );
  }

  void _applyRemoteFollows(List<FollowRecordUiModel> records) {
    final mapped = <FollowEntityType, List<FollowingItemUiModel>>{};

    for (final record in records) {
      final type = record.entityType;
      if (type == null) {
        continue;
      }
      final snapshot = record.entitySnapshot;
      final title = snapshot?.entityName ?? record.entityId;
      final entityLogo = snapshot?.entityLogo ?? '';

      // Postman does not contain the proper variable name
      final subtitle = '';

      final item = FollowingItemUiModel(
        id: record.entityId,
        title: title,
        subtitle: subtitle,
        entityLogo: entityLogo,
        seed: _seedFromName(title),
        accentColor: const Color(0xFF28D8AE),
        type: type,
      );

      mapped.putIfAbsent(type, () => <FollowingItemUiModel>[]).add(item);
    }

    _remoteFollowingItems = mapped;
    _rebuildState();
  }

  String _seedFromName(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return '';
    }

    final parts = trimmed
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty);
    final letters = <String>[];
    for (final part in parts) {
      letters.add(part.substring(0, 1).toUpperCase());
      if (letters.length == 2) {
        break;
      }
    }

    if (letters.isNotEmpty) {
      return letters.join();
    }

    return trimmed.substring(0, 1).toUpperCase();
  }
}

class FollowingBinding extends Bindings {
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

    if (!Get.isRegistered<FollowingController>()) {
      Get.lazyPut<FollowingController>(
        () =>
            FollowingController(followingService: Get.find<FollowingService>()),
      );
    }
  }
}
