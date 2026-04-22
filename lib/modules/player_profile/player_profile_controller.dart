import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/following_service.dart';
import 'player_profile_model.dart';

class PlayerProfileController extends GetxController {
  final FollowingService _followingService;

  PlayerProfileController({required FollowingService followingService})
    : _followingService = followingService;

  final Rx<PlayerProfileViewModel> state = const PlayerProfileViewModel(
    id: 'cristiano-ronaldo',
    playerName: 'Cristiano Ronaldo',
    teamName: 'Al Nassar FC',
    avatarSeed: 'CR7',
    selectedSeason: 'Saudi Pro League 2025/2026',
    seasons: <String>[
      'Saudi Pro League 2025/2026',
      'Saudi Pro League 2024/2025',
      'Saudi Pro League 2023/2024',
    ],
    facts: <PlayerProfileFactUiModel>[
      PlayerProfileFactUiModel(value: 'POR', label: 'Country', isHighlighted: true),
      PlayerProfileFactUiModel(value: '7', label: 'Shirt No.', isHighlighted: true),
      PlayerProfileFactUiModel(value: '6ft 2in', label: 'Height'),
      PlayerProfileFactUiModel(value: '41 years', label: 'Feb 1, 1985'),
      PlayerProfileFactUiModel(value: 'Primary Striker', label: 'Field Position', isHighlighted: true),
    ],
    summaryMetrics: <PlayerProfileMetricUiModel>[
      PlayerProfileMetricUiModel(label: 'Matches', value: '24'),
      PlayerProfileMetricUiModel(label: 'Assists', value: '2'),
      PlayerProfileMetricUiModel(label: 'Goals', value: '24'),
    ],
    traits: <PlayerProfileTraitUiModel>[
      PlayerProfileTraitUiModel(label: 'DEFENSIVE CONTRIB.', value: '2%', alignment: Alignment.topLeft),
      PlayerProfileTraitUiModel(label: 'GOALS', value: '100%', alignment: Alignment.topRight),
      PlayerProfileTraitUiModel(label: 'AERIAL WON', value: '18%', alignment: Alignment.centerLeft),
      PlayerProfileTraitUiModel(label: 'SHOT\nATTEMPTS', value: '100%', alignment: Alignment.centerRight),
      PlayerProfileTraitUiModel(label: 'CHANCES CREATED', value: '41%', alignment: Alignment.bottomLeft),
      PlayerProfileTraitUiModel(label: 'TOUCHES', value: '38%', alignment: Alignment.bottomRight),
    ],
    trophies: <PlayerProfileTrophyUiModel>[
      PlayerProfileTrophyUiModel(
        title: 'Sudamericano U20',
        country: 'South-America',
        season: 'Peru 2011',
        result: 'Winner',
        seed: 'SA',
      ),
      PlayerProfileTrophyUiModel(
        title: 'Trophee des Champions',
        country: 'France',
        season: '2019/2020',
        result: 'Winner',
        seed: 'TC',
      ),
    ],
    matchGroups: <PlayerProfileMatchGroupUiModel>[
      PlayerProfileMatchGroupUiModel(
        title: 'Al Nassar FC',
        subtitle: 'Saudi Arabia',
        matches: <PlayerProfileMatchItemUiModel>[
          PlayerProfileMatchItemUiModel(
            dateLabel: 'APR 12, 26',
            competitionLabel: 'Saudi Pro League',
            opponentName: 'Al Akhdoud',
            scoreLabel: '2 - 0',
            statLabel: '1 Goal',
            minuteLabel: '82\'',
          ),
          PlayerProfileMatchItemUiModel(
            dateLabel: 'APR 4, 26',
            competitionLabel: 'Saudi Pro League',
            opponentName: 'Al Najma',
            scoreLabel: '2 - 0',
            statLabel: '1 Goal',
            minuteLabel: '82\'',
          ),
          PlayerProfileMatchItemUiModel(
            dateLabel: 'MAR 1, 26',
            competitionLabel: 'Saudi Pro League',
            opponentName: 'Al Fayha',
            scoreLabel: '2 - 0',
            statLabel: '1 Goal',
            minuteLabel: '82\'',
          ),
        ],
      ),
      PlayerProfileMatchGroupUiModel(
        title: 'Portugal',
        subtitle: 'International',
        matches: <PlayerProfileMatchItemUiModel>[
          PlayerProfileMatchItemUiModel(
            dateLabel: 'APR 12, 26',
            competitionLabel: 'WORLD CUP QUALIFICATION UEFA',
            opponentName: 'Ireland',
            scoreLabel: '2 - 0',
            statLabel: 'No Goal',
            minuteLabel: '82\'',
            isGoalPositive: false,
          ),
        ],
      ),
      PlayerProfileMatchGroupUiModel(
        title: 'Placeholder',
        subtitle: '',
        matches: <PlayerProfileMatchItemUiModel>[
          PlayerProfileMatchItemUiModel(
            dateLabel: '',
            competitionLabel: '',
            opponentName: '',
            scoreLabel: '',
            statLabel: '',
            minuteLabel: '',
          ),
        ],
      ),
    ],
    statSections: <PlayerProfileStatSectionUiModel>[
      PlayerProfileStatSectionUiModel(
        title: 'SHOOTING',
        metrics: <PlayerProfileMetricUiModel>[
          PlayerProfileMetricUiModel(label: 'GOALS', value: '3'),
          PlayerProfileMetricUiModel(label: 'PENALTY GOALS', value: '3'),
          PlayerProfileMetricUiModel(label: 'SHOTS', value: '3'),
          PlayerProfileMetricUiModel(label: 'SHOTS ON TARGET', value: '3'),
          PlayerProfileMetricUiModel(label: 'HEADED SHOTS', value: '3'),
        ],
      ),
      PlayerProfileStatSectionUiModel(
        title: 'PASSING',
        metrics: <PlayerProfileMetricUiModel>[
          PlayerProfileMetricUiModel(label: 'METRIC 1', value: '3'),
          PlayerProfileMetricUiModel(label: 'METRIC 2', value: '3'),
        ],
      ),
      PlayerProfileStatSectionUiModel(
        title: 'POSSESSION',
        metrics: <PlayerProfileMetricUiModel>[
          PlayerProfileMetricUiModel(label: 'METRIC 1', value: '3'),
          PlayerProfileMetricUiModel(label: 'METRIC 2', value: '3'),
        ],
      ),
      PlayerProfileStatSectionUiModel(
        title: 'DEFENDING',
        metrics: <PlayerProfileMetricUiModel>[
          PlayerProfileMetricUiModel(label: 'METRIC 1', value: '3'),
          PlayerProfileMetricUiModel(label: 'METRIC 2', value: '3'),
        ],
      ),
      PlayerProfileStatSectionUiModel(
        title: 'DISCIPLINE',
        metrics: <PlayerProfileMetricUiModel>[
          PlayerProfileMetricUiModel(label: 'YELLOW CARDS', value: '1', valueColor: Color(0xFFFFA500)),
          PlayerProfileMetricUiModel(label: 'RED CARDS', value: '0'),
        ],
      ),
    ],
    seniorCareer: <PlayerCareerClubUiModel>[
      PlayerCareerClubUiModel(title: 'Al Nassar FC', rangeLabel: 'JAN 2023 - NOW', matches: '3', goals: '3', seed: 'AN'),
      PlayerCareerClubUiModel(title: 'Man United', rangeLabel: 'AUG 2021 - NOV 2022', matches: '54', goals: '27', seed: 'MU'),
      PlayerCareerClubUiModel(title: 'Juventus', rangeLabel: 'JUL 2018 - AUG 2021', matches: '134', goals: '101', seed: 'JUV'),
      PlayerCareerClubUiModel(title: 'Real Madrid', rangeLabel: 'JUL 2009 - JUL 2018', matches: '292', goals: '311', seed: 'RM'),
      PlayerCareerClubUiModel(title: 'Sporting CP', rangeLabel: 'JUL 2002 - AUG 2003', matches: '31', goals: '5', seed: 'SCP'),
    ],
    nationalCareer: <PlayerCareerClubUiModel>[
      PlayerCareerClubUiModel(title: 'Portugal', rangeLabel: 'JAN 2023 - MAR 2026', matches: '226', goals: '143', seed: 'POR'),
    ],
  ).obs;

  Worker? _worker;
  String _playerId = 'cristiano-ronaldo';

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      final id = args['id']?.toString();
      if (id != null && id.isNotEmpty) {
        _applyPlayerId(id);
      }
    }
    _syncFollowState();
    _worker = ever<int>(_followingService.revision, (_) => _syncFollowState());
  }

  @override
  void onClose() {
    _worker?.dispose();
    super.onClose();
  }

  void selectSeason(String season) {
    if (!state.value.seasons.contains(season)) {
      return;
    }
    state.value = state.value.copyWith(selectedSeason: season);
  }

  void follow() {
    _followingService.follow(FollowEntityType.player, _playerId);
  }

  void unfollow() {
    _followingService.unfollow(FollowEntityType.player, _playerId);
  }

  void _syncFollowState() {
    state.value = state.value.copyWith(
      isFollowing: _followingService.isFollowing(FollowEntityType.player, _playerId),
    );
  }

  void _applyPlayerId(String id) {
    _playerId = id;
    switch (id) {
      case 'kylian-mbappe':
        state.value = state.value.copyWith(
          id: id,
          playerName: 'Kylian Mbappé',
          teamName: 'Real Madrid',
          avatarSeed: 'KM',
        );
        break;
      case 'jude-bellingham':
        state.value = state.value.copyWith(
          id: id,
          playerName: 'Jude Bellingham',
          teamName: 'Real Madrid',
          avatarSeed: 'JB',
        );
        break;
      default:
        _playerId = 'cristiano-ronaldo';
        state.value = state.value.copyWith(
          id: 'cristiano-ronaldo',
          playerName: 'Cristiano Ronaldo',
          teamName: 'Al Nassar FC',
          avatarSeed: 'CR7',
        );
        break;
    }
  }
}

class PlayerProfileBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<FollowingService>()) {
      Get.lazyPut<FollowingService>(() => FollowingService(), fenix: true);
    }
    Get.lazyPut<PlayerProfileController>(
      () => PlayerProfileController(followingService: Get.find<FollowingService>()),
    );
  }
}
