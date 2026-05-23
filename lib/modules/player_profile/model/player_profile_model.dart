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
    final selected = int.tryParse(selectedSeason) ?? DateTime.now().year;
    return List<String>.generate(6, (index) => '${selected - index}');
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
