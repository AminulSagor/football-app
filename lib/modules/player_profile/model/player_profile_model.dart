import 'package:flutter/material.dart';

class PlayerProfileFactUiModel {
  final String value;
  final String label;
  final bool isHighlighted;

  const PlayerProfileFactUiModel({
    required this.value,
    required this.label,
    this.isHighlighted = false,
  });
}

class PlayerProfileMetricUiModel {
  final String label;
  final String value;
  final Color valueColor;

  const PlayerProfileMetricUiModel({
    required this.label,
    required this.value,
    this.valueColor = const Color(0xFF39E0B3),
  });
}

class PlayerProfileTraitUiModel {
  final String label;
  final String value;
  final Alignment alignment;

  const PlayerProfileTraitUiModel({
    required this.label,
    required this.value,
    required this.alignment,
  });
}

class PlayerProfileTrophyUiModel {
  final String title;
  final String country;
  final String season;
  final String result;
  final String seed;
  final String logoUrl;

  const PlayerProfileTrophyUiModel({
    required this.title,
    required this.country,
    required this.season,
    required this.result,
    required this.seed,
    this.logoUrl = '',
  });
}

class PlayerProfileMatchGroupUiModel {
  final String title;
  final String subtitle;
  final String logoUrl;
  final List<PlayerProfileMatchItemUiModel> matches;

  const PlayerProfileMatchGroupUiModel({
    required this.title,
    required this.subtitle,
    required this.matches,
    this.logoUrl = '',
  });
}

class PlayerProfileMatchItemUiModel {
  final String dateLabel;
  final String competitionLabel;
  final String opponentName;
  final String opponentLogoUrl;
  final String scoreLabel;
  final String statLabel;
  final String minuteLabel;
  final List<String> eventChips;
  final bool isGoalPositive;

  const PlayerProfileMatchItemUiModel({
    required this.dateLabel,
    required this.competitionLabel,
    required this.opponentName,
    required this.scoreLabel,
    required this.statLabel,
    required this.minuteLabel,
    this.opponentLogoUrl = '',
    this.eventChips = const <String>[],
    this.isGoalPositive = true,
  });
}

class PlayerProfileStatSectionUiModel {
  final String title;
  final List<PlayerProfileMetricUiModel> metrics;

  const PlayerProfileStatSectionUiModel({
    required this.title,
    required this.metrics,
  });
}

class PlayerCareerClubUiModel {
  final String title;
  final String rangeLabel;
  final String matches;
  final String goals;
  final String seed;
  final String logoUrl;

  const PlayerCareerClubUiModel({
    required this.title,
    required this.rangeLabel,
    required this.matches,
    required this.goals,
    required this.seed,
    this.logoUrl = '',
  });
}

class PlayerProfileViewModel {
  static const Object _unset = Object();

  final String id;
  final String playerName;
  final String teamName;
  final String teamLogoUrl;
  final String leagueName;
  final String leagueLogoUrl;
  final String leagueFlagUrl;
  final String avatarSeed;
  final String avatarImageUrl;
  final bool isFollowing;
  final bool isLoading;
  final bool hasLoadedOnce;
  final String? errorMessage;

  final String selectedSeason;
  final List<String> seasons;

  final String topStatValue;
  final String topStatLabel;

  final List<PlayerProfileFactUiModel> facts;
  final List<PlayerProfileMetricUiModel> summaryMetrics;
  final List<PlayerProfileTraitUiModel> traits;
  final List<PlayerProfileTrophyUiModel> trophies;
  final List<PlayerProfileMatchGroupUiModel> matchGroups;
  final List<PlayerProfileStatSectionUiModel> statSections;
  final List<PlayerCareerClubUiModel> seniorCareer;
  final List<PlayerCareerClubUiModel> nationalCareer;
  final int matchPage;
  final bool hasMoreMatches;
  final bool isLoadingMoreMatches;

  const PlayerProfileViewModel({
    required this.id,
    required this.playerName,
    required this.teamName,
    required this.avatarSeed,
    this.teamLogoUrl = '',
    this.leagueName = '',
    this.leagueLogoUrl = '',
    this.leagueFlagUrl = '',
    this.avatarImageUrl = '',
    this.isFollowing = false,
    this.isLoading = false,
    this.hasLoadedOnce = false,
    this.errorMessage,
    this.selectedSeason = '',
    this.seasons = const <String>[],
    this.topStatValue = '0',
    this.topStatLabel = 'Minutes Played',
    this.facts = const <PlayerProfileFactUiModel>[],
    this.summaryMetrics = const <PlayerProfileMetricUiModel>[],
    this.traits = const <PlayerProfileTraitUiModel>[],
    this.trophies = const <PlayerProfileTrophyUiModel>[],
    this.matchGroups = const <PlayerProfileMatchGroupUiModel>[],
    this.statSections = const <PlayerProfileStatSectionUiModel>[],
    this.seniorCareer = const <PlayerCareerClubUiModel>[],
    this.nationalCareer = const <PlayerCareerClubUiModel>[],
    this.matchPage = 1,
    this.hasMoreMatches = true,
    this.isLoadingMoreMatches = false,
  });

  factory PlayerProfileViewModel.initial({
    required String playerId,
    required String season,
    String playerName = 'Loading player',
    String teamName = '',
  }) {
    return PlayerProfileViewModel(
      id: playerId,
      playerName: playerName,
      teamName: teamName,
      avatarSeed: _seedFromName(playerName),
      selectedSeason: season,
      seasons: _buildSeasonOptions(season),
      facts: const <PlayerProfileFactUiModel>[
        PlayerProfileFactUiModel(
          value: '-',
          label: 'Country',
          isHighlighted: true,
        ),
        PlayerProfileFactUiModel(
          value: '-',
          label: 'Shirt No.',
          isHighlighted: true,
        ),
        PlayerProfileFactUiModel(value: '-', label: 'Height'),
        PlayerProfileFactUiModel(value: '-', label: 'Birth Date'),
        PlayerProfileFactUiModel(
          value: '-',
          label: 'Field Position',
          isHighlighted: true,
        ),
      ],
      summaryMetrics: const <PlayerProfileMetricUiModel>[
        PlayerProfileMetricUiModel(label: 'Matches', value: '0'),
        PlayerProfileMetricUiModel(label: 'Assists', value: '0'),
        PlayerProfileMetricUiModel(label: 'Goals', value: '0'),
      ],
    );
  }

  bool get shouldSkeletonize => isLoading;

  PlayerProfileViewModel get skeletonized {
    if (!isLoading || hasLoadedOnce) {
      return this;
    }

    return copyWith(
      playerName: playerName.trim().isEmpty || playerName == 'Loading player'
          ? 'Player name'
          : playerName,
      teamName: teamName.trim().isEmpty ? 'Current Club' : teamName,
      leagueName: leagueName.trim().isEmpty ? 'Season League' : leagueName,
      topStatValue: '0000',
      topStatLabel: 'Minutes Played',
      facts: _skeletonFacts,
      summaryMetrics: _skeletonSummaryMetrics,
      traits: _skeletonTraits,
      trophies: _skeletonTrophies,
      matchGroups: _skeletonMatchGroups,
      statSections: _skeletonStatSections,
      seniorCareer: _skeletonSeniorCareer,
      nationalCareer: _skeletonNationalCareer,
    );
  }

  static const List<PlayerProfileFactUiModel> _skeletonFacts =
      <PlayerProfileFactUiModel>[
        PlayerProfileFactUiModel(
          value: 'Argentina',
          label: 'Country',
          isHighlighted: true,
        ),
        PlayerProfileFactUiModel(
          value: '10',
          label: 'Shirt No.',
          isHighlighted: true,
        ),
        PlayerProfileFactUiModel(value: '185 cm', label: 'Height'),
        PlayerProfileFactUiModel(value: 'Jan 01, 1998', label: 'Birth Date'),
        PlayerProfileFactUiModel(
          value: 'Centre Forward',
          label: 'Field Position',
          isHighlighted: true,
        ),
      ];

  static const List<PlayerProfileMetricUiModel> _skeletonSummaryMetrics =
      <PlayerProfileMetricUiModel>[
        PlayerProfileMetricUiModel(label: 'Matches', value: '00'),
        PlayerProfileMetricUiModel(label: 'Assists', value: '00'),
        PlayerProfileMetricUiModel(label: 'Goals', value: '00'),
      ];

  static const List<PlayerProfileTraitUiModel> _skeletonTraits =
      <PlayerProfileTraitUiModel>[
        PlayerProfileTraitUiModel(
          label: 'Speed',
          value: '82%',
          alignment: Alignment.centerRight,
        ),
        PlayerProfileTraitUiModel(
          label: 'Passing',
          value: '76%',
          alignment: Alignment.bottomRight,
        ),
        PlayerProfileTraitUiModel(
          label: 'Dribbling',
          value: '88%',
          alignment: Alignment.bottomLeft,
        ),
        PlayerProfileTraitUiModel(
          label: 'Defense',
          value: '58%',
          alignment: Alignment.centerLeft,
        ),
        PlayerProfileTraitUiModel(
          label: 'Physical',
          value: '71%',
          alignment: Alignment.topLeft,
        ),
        PlayerProfileTraitUiModel(
          label: 'Shooting',
          value: '84%',
          alignment: Alignment.topRight,
        ),
      ];

  static const List<PlayerProfileTrophyUiModel> _skeletonTrophies =
      <PlayerProfileTrophyUiModel>[
        PlayerProfileTrophyUiModel(
          title: 'League Champion',
          country: 'Country',
          season: '2025',
          result: 'Winner',
          seed: 'LC',
        ),
        PlayerProfileTrophyUiModel(
          title: 'Cup Winner',
          country: 'Country',
          season: '2024',
          result: 'Winner',
          seed: 'CW',
        ),
      ];

  static const List<PlayerProfileMatchGroupUiModel> _skeletonMatchGroups =
      <PlayerProfileMatchGroupUiModel>[
        PlayerProfileMatchGroupUiModel(
          title: 'Recent Matches',
          subtitle: 'Season League',
          matches: <PlayerProfileMatchItemUiModel>[
            PlayerProfileMatchItemUiModel(
              dateLabel: '12 MAY',
              competitionLabel: 'League Match',
              opponentName: 'Opponent Team',
              scoreLabel: '2 - 1',
              statLabel: '1 Goal',
              minuteLabel: '90\'',
            ),
            PlayerProfileMatchItemUiModel(
              dateLabel: '08 MAY',
              competitionLabel: 'Cup Match',
              opponentName: 'Opponent Club',
              scoreLabel: '1 - 1',
              statLabel: '1 Assist',
              minuteLabel: '76\'',
            ),
            PlayerProfileMatchItemUiModel(
              dateLabel: '02 MAY',
              competitionLabel: 'League Match',
              opponentName: 'Another Team',
              scoreLabel: '3 - 0',
              statLabel: 'Started',
              minuteLabel: '90\'',
            ),
          ],
        ),
      ];

  static const List<PlayerProfileStatSectionUiModel> _skeletonStatSections =
      <PlayerProfileStatSectionUiModel>[
        PlayerProfileStatSectionUiModel(
          title: 'Attacking',
          metrics: <PlayerProfileMetricUiModel>[
            PlayerProfileMetricUiModel(label: 'Goals', value: '00'),
            PlayerProfileMetricUiModel(label: 'Assists', value: '00'),
            PlayerProfileMetricUiModel(label: 'Shots on target', value: '00'),
          ],
        ),
        PlayerProfileStatSectionUiModel(
          title: 'Passing',
          metrics: <PlayerProfileMetricUiModel>[
            PlayerProfileMetricUiModel(label: 'Total passes', value: '000'),
            PlayerProfileMetricUiModel(label: 'Key passes', value: '00'),
            PlayerProfileMetricUiModel(label: 'Pass accuracy', value: '00%'),
          ],
        ),
        PlayerProfileStatSectionUiModel(
          title: 'Discipline',
          metrics: <PlayerProfileMetricUiModel>[
            PlayerProfileMetricUiModel(label: 'Yellow cards', value: '00'),
            PlayerProfileMetricUiModel(label: 'Red cards', value: '00'),
          ],
        ),
      ];

  static const List<PlayerCareerClubUiModel> _skeletonSeniorCareer =
      <PlayerCareerClubUiModel>[
        PlayerCareerClubUiModel(
          title: 'Current Club',
          rangeLabel: '2024 - Present',
          matches: '00',
          goals: '00',
          seed: 'CC',
        ),
        PlayerCareerClubUiModel(
          title: 'Previous Club',
          rangeLabel: '2021 - 2024',
          matches: '00',
          goals: '00',
          seed: 'PC',
        ),
        PlayerCareerClubUiModel(
          title: 'Academy Club',
          rangeLabel: '2019 - 2021',
          matches: '00',
          goals: '00',
          seed: 'AC',
        ),
      ];

  static const List<PlayerCareerClubUiModel> _skeletonNationalCareer =
      <PlayerCareerClubUiModel>[
        PlayerCareerClubUiModel(
          title: 'National Team',
          rangeLabel: '2022 - Present',
          matches: '00',
          goals: '00',
          seed: 'NT',
        ),
      ];

  PlayerProfileViewModel copyWith({
    String? id,
    String? playerName,
    String? teamName,
    String? teamLogoUrl,
    String? leagueName,
    String? leagueLogoUrl,
    String? leagueFlagUrl,
    String? avatarSeed,
    String? avatarImageUrl,
    bool? isFollowing,
    bool? isLoading,
    bool? hasLoadedOnce,
    Object? errorMessage = _unset,
    String? selectedSeason,
    List<String>? seasons,
    String? topStatValue,
    String? topStatLabel,
    List<PlayerProfileFactUiModel>? facts,
    List<PlayerProfileMetricUiModel>? summaryMetrics,
    List<PlayerProfileTraitUiModel>? traits,
    List<PlayerProfileTrophyUiModel>? trophies,
    List<PlayerProfileMatchGroupUiModel>? matchGroups,
    List<PlayerProfileStatSectionUiModel>? statSections,
    List<PlayerCareerClubUiModel>? seniorCareer,
    List<PlayerCareerClubUiModel>? nationalCareer,
    int? matchPage,
    bool? hasMoreMatches,
    bool? isLoadingMoreMatches,
  }) {
    return PlayerProfileViewModel(
      id: id ?? this.id,
      playerName: playerName ?? this.playerName,
      teamName: teamName ?? this.teamName,
      teamLogoUrl: teamLogoUrl ?? this.teamLogoUrl,
      leagueName: leagueName ?? this.leagueName,
      leagueLogoUrl: leagueLogoUrl ?? this.leagueLogoUrl,
      leagueFlagUrl: leagueFlagUrl ?? this.leagueFlagUrl,
      avatarSeed: avatarSeed ?? this.avatarSeed,
      avatarImageUrl: avatarImageUrl ?? this.avatarImageUrl,
      isFollowing: isFollowing ?? this.isFollowing,
      isLoading: isLoading ?? this.isLoading,
      hasLoadedOnce: hasLoadedOnce ?? this.hasLoadedOnce,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
      selectedSeason: selectedSeason ?? this.selectedSeason,
      seasons: seasons ?? this.seasons,
      topStatValue: topStatValue ?? this.topStatValue,
      topStatLabel: topStatLabel ?? this.topStatLabel,
      facts: facts ?? this.facts,
      summaryMetrics: summaryMetrics ?? this.summaryMetrics,
      traits: traits ?? this.traits,
      trophies: trophies ?? this.trophies,
      matchGroups: matchGroups ?? this.matchGroups,
      statSections: statSections ?? this.statSections,
      seniorCareer: seniorCareer ?? this.seniorCareer,
      nationalCareer: nationalCareer ?? this.nationalCareer,
      matchPage: matchPage ?? this.matchPage,
      hasMoreMatches: hasMoreMatches ?? this.hasMoreMatches,
      isLoadingMoreMatches: isLoadingMoreMatches ?? this.isLoadingMoreMatches,
    );
  }

  static List<String> _buildSeasonOptions(String selectedSeason) {
    final currentYear = DateTime.now().year;
    final selected = int.tryParse(selectedSeason);
    final anchorYear = selected != null && selected > currentYear
        ? selected
        : currentYear;

    return List<String>.generate(10, (index) => '${anchorYear - index}');
  }

  static String _seedFromName(String name) {
    final tokens = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((token) => token.trim().isNotEmpty)
        .toList(growable: false);

    if (tokens.isEmpty) return 'PL';

    if (tokens.length == 1) {
      final token = tokens.first;
      return token
          .substring(0, token.length >= 2 ? 2 : token.length)
          .toUpperCase();
    }

    return '${tokens.first[0]}${tokens.last[0]}'.toUpperCase();
  }
}
