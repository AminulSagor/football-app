import 'dart:async';

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
  static const int _apiPage = 1;
  static const int _apiLimit = 10;
  static const Duration _silentRefreshInterval = Duration(seconds: 45);

  final FollowingService _followingService;
  final ApiClient _apiClient;

  FollowingController({
    required FollowingService followingService,
    required ApiClient apiClient,
  }) : _followingService = followingService,
       _apiClient = apiClient;

  final Rx<FollowingViewModel> state = const FollowingViewModel().obs;
  Worker? _worker;
  DateTime? _lastRefreshAllAt;
  bool _isRefreshingAll = false;

  Map<FollowEntityType, List<FollowingItemUiModel>> _remoteFollowingItems =
      <FollowEntityType, List<FollowingItemUiModel>>{};

  Map<FollowEntityType, List<FollowingItemUiModel>> _trendingItems =
      <FollowEntityType, List<FollowingItemUiModel>>{
        FollowEntityType.league: <FollowingItemUiModel>[],
        FollowEntityType.player: <FollowingItemUiModel>[],
        FollowEntityType.team: <FollowingItemUiModel>[],
        FollowEntityType.coach: <FollowingItemUiModel>[],
      };

  @override
  void onInit() {
    super.onInit();
    _rebuildState();
    _worker = ever<int>(_followingService.revision, (_) => _rebuildState());
    unawaited(refreshAll());
  }

  @override
  void onClose() {
    _worker?.dispose();
    super.onClose();
  }

  void selectTab(FollowingTabType tab) {
    if (tab == state.value.selectedTab) return;
    state.value = state.value.copyWith(selectedTab: tab);
  }

  bool isFollowing(FollowEntityType type, String id) {
    return _followingService.isFollowing(type, id);
  }

  Future<void> ensureLoaded() async {
    if (_lastRefreshAllAt != null || _isRefreshingAll) return;
    await refreshAll();
  }

  Future<void> refreshSilentlyIfStale() async {
    final lastRefreshAllAt = _lastRefreshAllAt;
    if (lastRefreshAllAt != null &&
        DateTime.now().difference(lastRefreshAllAt) < _silentRefreshInterval) {
      return;
    }

    await refreshAll();
  }

  Future<void> refreshAll() async {
    if (_isRefreshingAll) return;

    _isRefreshingAll = true;
    try {
      await Future.wait<void>([
        refreshFollows(),
        loadTrendingSections(),
      ]);
      _lastRefreshAllAt = DateTime.now();
    } finally {
      _isRefreshingAll = false;
    }
  }

  Future<void> follow(FollowingItemUiModel item) async {
    final payload = _buildFollowPayload(item);

    final response = await ApiErrorHandler.handle<FollowingActionUiModel>(
      () => _followingService.follow(payload),
      fallbackErrorCode: 'follow_entity_failed',
      userMessage: 'Could not follow this right now.',
    );

    if (response.success) {
      await refreshFollows();
      _rebuildState();
    }
  }

  Future<void> unfollow(FollowingItemUiModel item) async {
    final payload = UnfollowPayloadModel(
      entityType: item.type,
      entityId: item.id,
    );

    final response = await ApiErrorHandler.handle<FollowingActionUiModel>(
      () => _followingService.unfollow(payload),
      fallbackErrorCode: 'unfollow_entity_failed',
      userMessage: 'Could not unfollow this right now.',
    );

    if (response.success) {
      await refreshFollows();
      _rebuildState();
    }
  }

  Future<void> refreshFollows() async {
    const payload = FollowListPayloadModel();

    final response = await ApiErrorHandler.handle<FollowingListUiModel>(
      () => _followingService.fetchFollows(payload),
      fallbackErrorCode: 'fetch_follows_failed',
      userMessage: 'Could not load follows right now.',
    );

    if (!response.success || response.data == null) return;

    _applyRemoteFollows(response.data!.items);
  }

  Future<void> loadTrendingSections() async {
    final results = await Future.wait<List<FollowingItemUiModel>>([
      _safeTrendingFetch(_fetchTopLeagues),
      _safeTrendingFetch(_fetchTopPlayers),
      _safeTrendingFetch(_fetchTopTeams),
    ]);

    _trendingItems = <FollowEntityType, List<FollowingItemUiModel>>{
      FollowEntityType.league: results[0],
      FollowEntityType.player: results[1],
      FollowEntityType.team: results[2],
      FollowEntityType.coach: <FollowingItemUiModel>[],
    };

    _rebuildState();
  }

  Future<List<FollowingItemUiModel>> _safeTrendingFetch(
    Future<List<FollowingItemUiModel>> Function() loader,
  ) async {
    try {
      return await loader();
    } catch (_) {
      return const <FollowingItemUiModel>[];
    }
  }

  Future<List<FollowingItemUiModel>> _fetchTopTeams() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/football/teams/top',
      queryParameters: <String, dynamic>{'page': _apiPage, 'limit': _apiLimit},
    );

    final data = _readDataMap(response.data);
    final sections = _readListOfMaps(data['sections']);
    final items = <FollowingItemUiModel>[];

    for (final section in sections) {
      final sectionTitle = _readString(section['title']);
      final rows = _readListOfMaps(section['items']);

      for (final row in rows) {
        final team = _readMap(row['team']);
        final id = _readString(team['id']);
        final name = _readString(team['name']);

        if (id.isEmpty || name.isEmpty) continue;

        final country = _readString(team['country']);
        final subtitle = _joinSubtitle(<String>[sectionTitle, country]);

        items.add(
          FollowingItemUiModel(
            id: id,
            title: name,
            subtitle: subtitle,
            entityLogo: _readString(team['logo']),
            seed: _seedFromName(name),
            accentColor: const Color(0xFF28D8AE),
            type: FollowEntityType.team,
          ),
        );
      }
    }

    return _uniqueItems(items);
  }

  Future<List<FollowingItemUiModel>> _fetchTopLeagues() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/football/leagues/top',
      queryParameters: <String, dynamic>{'page': _apiPage, 'limit': _apiLimit},
    );

    final data = _readDataMap(response.data);
    final rows = _readListOfMaps(data['response']);
    final items = <FollowingItemUiModel>[];

    for (final row in rows) {
      final league = _readMap(row['league']);
      final country = _readMap(row['country']);

      final id = _readString(league['id']);
      final name = _readString(league['name']);

      if (id.isEmpty || name.isEmpty) continue;

      // final type = _readString(league['type']);
      final countryName = _readString(country['name']);
      final subtitle = countryName;

      items.add(
        FollowingItemUiModel(
          id: id,
          title: name,
          subtitle: subtitle,
          entityLogo: _readString(league['logo']),
          seed: _seedFromName(name),
          accentColor: const Color(0xFF28D8AE),
          type: FollowEntityType.league,
        ),
      );
    }

    return _uniqueItems(items);
  }

  Future<List<FollowingItemUiModel>> _fetchTopPlayers() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/football/players/top',
      queryParameters: <String, dynamic>{'page': _apiPage, 'limit': _apiLimit},
    );

    final data = _readDataMap(response.data);
    final rows = _readListOfMaps(data['items']);
    final items = <FollowingItemUiModel>[];

    for (final row in rows) {
      final player = _readMap(row['player']);

      final id = _readString(player['id']);
      final name = _readString(player['name']);

      if (id.isEmpty || name.isEmpty) continue;

      final position = _readString(player['position']);
      final nationality = _readString(player['nationality']);
      final subtitle = _joinSubtitle(<String>[position, nationality]);

      items.add(
        FollowingItemUiModel(
          id: id,
          title: name,
          subtitle: subtitle,
          entityLogo: _readString(player['photo']),
          seed: _seedFromName(name),
          accentColor: const Color(0xFF28D8AE),
          type: FollowEntityType.player,
        ),
      );
    }

    return _uniqueItems(items);
  }

  void openItem(FollowingItemUiModel item) {
    switch (item.type) {
      case FollowEntityType.league:
        Get.toNamed(
          AppRoutes.leagueDetails,
          arguments: LeaguesTopLeagueUiModel(
            leagueId: item.id,
            image: item.entityLogo ?? '',
            leagueName: item.title,
            badgeSeed: item.seed,
            badgeHex: '#0E8B67',
            countryName: item.subtitle,
            leagueType: '',
            season: null,
            countryFlag: '',
          ),
        );
        break;

      case FollowEntityType.player:
        final arguments = <String, dynamic>{
          'id': item.id,
          'playerId': item.id,
          'playerName': item.title,
        };

        final teamId = item.teamId?.trim();
        if (teamId != null && teamId.isNotEmpty) {
          arguments['teamId'] = teamId;
          arguments['teamName'] = item.subtitle;
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

  FollowingTabSectionUiModel _buildSectionWithRemote(
    List<FollowingItemUiModel> trendingCandidates,
    FollowEntityType type,
  ) {
    final remoteItems = _remoteFollowingItems[type] ?? <FollowingItemUiModel>[];
    final remoteIds = remoteItems.map((item) => item.id).toSet();

    final followingItems = remoteItems.isNotEmpty
        ? remoteItems
        : trendingCandidates
              .where(
                (item) => _followingService.isFollowing(item.type, item.id),
              )
              .toList(growable: false);

    final followingIds = followingItems.map((item) => item.id).toSet();

    final trendingItems = trendingCandidates
        .where((item) => !remoteIds.contains(item.id))
        .where((item) => !followingIds.contains(item.id))
        .where((item) => !_followingService.isFollowing(item.type, item.id))
        .toList(growable: false);

    return FollowingTabSectionUiModel(
      followingItems: followingItems,
      trendingItems: trendingItems,
    );
  }

  void _rebuildState() {
    state.value = state.value.copyWith(
      leagues: _buildSectionWithRemote(
        _trendingItems[FollowEntityType.league] ?? <FollowingItemUiModel>[],
        FollowEntityType.league,
      ),
      players: _buildSectionWithRemote(
        _trendingItems[FollowEntityType.player] ?? <FollowingItemUiModel>[],
        FollowEntityType.player,
      ),
      teams: _buildSectionWithRemote(
        _trendingItems[FollowEntityType.team] ?? <FollowingItemUiModel>[],
        FollowEntityType.team,
      ),
      coach: _buildSectionWithRemote(
        const <FollowingItemUiModel>[],
        FollowEntityType.coach,
      ),
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
      if (type == null) continue;

      final snapshot = record.entitySnapshot;
      final title = snapshot?.entityName ?? record.entityId;
      final entityLogo = snapshot?.entityLogo ?? '';

      final item = FollowingItemUiModel(
        id: record.entityId,
        title: title,
        subtitle: '',
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

  Map<String, dynamic> _readDataMap(dynamic response) {
    final root = _readMap(response);
    final data = root['data'];

    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    return root;
  }

  Map<String, dynamic> _readMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return <String, dynamic>{};
  }

  List<Map<String, dynamic>> _readListOfMaps(dynamic value) {
    if (value is! List) return const <Map<String, dynamic>>[];

    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList(growable: false);
  }

  String _readString(dynamic value) {
    if (value == null) return '';

    final text = value.toString().trim();
    if (text.isEmpty || text.toLowerCase() == 'null') return '';

    return text;
  }

  String _joinSubtitle(List<String> values) {
    return values
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .join(' • ');
  }

  List<FollowingItemUiModel> _uniqueItems(List<FollowingItemUiModel> items) {
    final seen = <String>{};
    final result = <FollowingItemUiModel>[];

    for (final item in items) {
      final key = '${item.type}::${item.id}';
      if (seen.add(key)) {
        result.add(item);
      }
    }

    return result;
  }

  String _seedFromName(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '';

    final parts = trimmed
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList(growable: false);

    if (parts.length == 1) {
      final word = parts.first;
      return word.length <= 2
          ? word.toUpperCase()
          : word.substring(0, 2).toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
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
        () => FollowingController(
          followingService: Get.find<FollowingService>(),
          apiClient: Get.find<ApiClient>(),
        ),
      );
    }
  }
}
