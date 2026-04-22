import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/following_service.dart';
import '../../modules/leagues/leagues_models.dart';
import '../../routes/app_routes.dart';
import 'following_model.dart';

class FollowingController extends GetxController {
  final FollowingService _followingService;

  FollowingController({required FollowingService followingService})
    : _followingService = followingService;

  final Rx<FollowingViewModel> state = const FollowingViewModel().obs;
  Worker? _worker;

  static const List<FollowingItemUiModel> _leagueItems = <FollowingItemUiModel>[
    FollowingItemUiModel(
      id: 'premier-league',
      title: 'Premier League',
      subtitle: '',
      seed: 'EPL',
      accentColor: Color(0xFF293F80),
      type: FollowEntityType.league,
    ),
    FollowingItemUiModel(
      id: 'laliga',
      title: 'LaLiga',
      subtitle: '',
      seed: 'LL',
      accentColor: Color(0xFFC83A2E),
      type: FollowEntityType.league,
    ),
    FollowingItemUiModel(
      id: 'serie-a',
      title: 'Serie A',
      subtitle: '',
      seed: 'SA',
      accentColor: Color(0xFF1D4F9B),
      type: FollowEntityType.league,
    ),
    FollowingItemUiModel(
      id: 'champions-league',
      title: 'Champions League',
      subtitle: '',
      seed: 'UCL',
      accentColor: Color(0xFF1C2A5F),
      type: FollowEntityType.league,
    ),
    FollowingItemUiModel(
      id: 'bundesliga',
      title: 'Bundesliga',
      subtitle: '',
      seed: 'BL',
      accentColor: Color(0xFF0E4D7D),
      type: FollowEntityType.league,
    ),
    FollowingItemUiModel(
      id: 'fifa-world-cup',
      title: 'FIFA World Cup',
      subtitle: '',
      seed: 'WC',
      accentColor: Color(0xFF0E8B67),
      type: FollowEntityType.league,
    ),
  ];

  static const List<FollowingItemUiModel> _playerItems = <FollowingItemUiModel>[
    FollowingItemUiModel(
      id: 'cristiano-ronaldo',
      title: 'Cristiano Ronaldo',
      subtitle: 'Al Nassar FC',
      seed: 'CR7',
      accentColor: Color(0xFF28D8AE),
      type: FollowEntityType.player,
    ),
    FollowingItemUiModel(
      id: 'kylian-mbappe',
      title: 'Kylian Mbappé',
      subtitle: 'Real Madrid',
      seed: 'KM',
      accentColor: Color(0xFF28D8AE),
      type: FollowEntityType.player,
    ),
    FollowingItemUiModel(
      id: 'jude-bellingham',
      title: 'Jude Bellingham',
      subtitle: 'Real Madrid',
      seed: 'JB',
      accentColor: Color(0xFF28D8AE),
      type: FollowEntityType.player,
    ),
  ];

  static const List<FollowingItemUiModel> _teamItems = <FollowingItemUiModel>[
    FollowingItemUiModel(
      id: 'bangladesh',
      title: 'Bangladesh',
      subtitle: '',
      seed: 'BD',
      accentColor: Color(0xFF28D8AE),
      type: FollowEntityType.team,
    ),
    FollowingItemUiModel(
      id: 'arsenal',
      title: 'Country/Club',
      subtitle: '',
      seed: 'ARS',
      accentColor: Color(0xFF28D8AE),
      type: FollowEntityType.team,
    ),
    FollowingItemUiModel(
      id: 'al-nassr',
      title: 'Country/Club',
      subtitle: '',
      seed: 'AN',
      accentColor: Color(0xFF28D8AE),
      type: FollowEntityType.team,
    ),
    FollowingItemUiModel(
      id: 'barcelona',
      title: 'Country/Club',
      subtitle: '',
      seed: 'BAR',
      accentColor: Color(0xFF28D8AE),
      type: FollowEntityType.team,
    ),
    FollowingItemUiModel(
      id: 'atletico-madrid',
      title: 'Country/Club',
      subtitle: '',
      seed: 'ATM',
      accentColor: Color(0xFF28D8AE),
      type: FollowEntityType.team,
    ),
  ];

  static const List<FollowingItemUiModel> _coachItems = <FollowingItemUiModel>[
    FollowingItemUiModel(
      id: 'diego-simeone',
      title: 'Diego Simeone',
      subtitle: 'Atletico Madrid',
      seed: 'DS',
      accentColor: Color(0xFF28D8AE),
      type: FollowEntityType.coach,
    ),
    FollowingItemUiModel(
      id: 'mikel-arteta',
      title: 'Coach',
      subtitle: 'Current Club',
      seed: 'MA',
      accentColor: Color(0xFF28D8AE),
      type: FollowEntityType.coach,
    ),
    FollowingItemUiModel(
      id: 'pep-guardiola',
      title: 'Coach',
      subtitle: 'Current Club',
      seed: 'PG',
      accentColor: Color(0xFF28D8AE),
      type: FollowEntityType.coach,
    ),
  ];

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

  void follow(FollowingItemUiModel item) {
    _followingService.follow(item.type, item.id);
  }

  void unfollow(FollowingItemUiModel item) {
    _followingService.unfollow(item.type, item.id);
  }

  void openItem(FollowingItemUiModel item) {
    switch (item.type) {
      case FollowEntityType.league:
        Get.toNamed(
          AppRoutes.leagueDetails,
          arguments: LeaguesTopLeagueUiModel(
            leagueId: item.id,
            leagueName: item.title,
            badgeSeed: item.seed,
            badgeHex: '#0E8B67',
          ),
        );
        break;
      case FollowEntityType.player:
        Get.toNamed(AppRoutes.playerProfile, arguments: <String, dynamic>{'id': item.id});
        break;
      case FollowEntityType.team:
        Get.toNamed(AppRoutes.teamProfile, arguments: <String, dynamic>{'teamId': item.id});
        break;
      case FollowEntityType.coach:
        Get.toNamed(AppRoutes.coachProfile, arguments: <String, dynamic>{'id': item.id});
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

  void _rebuildState() {
    state.value = state.value.copyWith(
      leagues: _buildSection(_leagueItems),
      players: _buildSection(_playerItems),
      teams: _buildSection(_teamItems),
      coach: _buildSection(_coachItems),
    );
  }
}

class FollowingBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<FollowingService>()) {
      Get.lazyPut<FollowingService>(() => FollowingService(), fenix: true);
    }

    if (!Get.isRegistered<FollowingController>()) {
      Get.lazyPut<FollowingController>(
        () => FollowingController(followingService: Get.find<FollowingService>()),
      );
    }
  }
}
