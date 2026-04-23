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

  const PlayerProfileTrophyUiModel({
    required this.title,
    required this.country,
    required this.season,
    required this.result,
    required this.seed,
  });
}

class PlayerProfileMatchGroupUiModel {
  final String title;
  final String subtitle;
  final List<PlayerProfileMatchItemUiModel> matches;

  const PlayerProfileMatchGroupUiModel({
    required this.title,
    required this.subtitle,
    required this.matches,
  });
}

class PlayerProfileMatchItemUiModel {
  final String dateLabel;
  final String competitionLabel;
  final String opponentName;
  final String scoreLabel;
  final String statLabel;
  final String minuteLabel;
  final bool isGoalPositive;

  const PlayerProfileMatchItemUiModel({
    required this.dateLabel,
    required this.competitionLabel,
    required this.opponentName,
    required this.scoreLabel,
    required this.statLabel,
    required this.minuteLabel,
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

  const PlayerCareerClubUiModel({
    required this.title,
    required this.rangeLabel,
    required this.matches,
    required this.goals,
    required this.seed,
  });
}

class PlayerProfileViewModel {
  final String id;
  final String playerName;
  final String teamName;
  final String avatarSeed;
  final bool isFollowing;
  final String selectedSeason;
  final List<String> seasons;
  final List<PlayerProfileFactUiModel> facts;
  final List<PlayerProfileMetricUiModel> summaryMetrics;
  final List<PlayerProfileTraitUiModel> traits;
  final List<PlayerProfileTrophyUiModel> trophies;
  final List<PlayerProfileMatchGroupUiModel> matchGroups;
  final List<PlayerProfileStatSectionUiModel> statSections;
  final List<PlayerCareerClubUiModel> seniorCareer;
  final List<PlayerCareerClubUiModel> nationalCareer;

  const PlayerProfileViewModel({
    required this.id,
    required this.playerName,
    required this.teamName,
    required this.avatarSeed,
    this.isFollowing = false,
    this.selectedSeason = '',
    this.seasons = const <String>[],
    this.facts = const <PlayerProfileFactUiModel>[],
    this.summaryMetrics = const <PlayerProfileMetricUiModel>[],
    this.traits = const <PlayerProfileTraitUiModel>[],
    this.trophies = const <PlayerProfileTrophyUiModel>[],
    this.matchGroups = const <PlayerProfileMatchGroupUiModel>[],
    this.statSections = const <PlayerProfileStatSectionUiModel>[],
    this.seniorCareer = const <PlayerCareerClubUiModel>[],
    this.nationalCareer = const <PlayerCareerClubUiModel>[],
  });

  PlayerProfileViewModel copyWith({
    String? id,
    String? playerName,
    String? teamName,
    String? avatarSeed,
    bool? isFollowing,
    String? selectedSeason,
    List<String>? seasons,
    List<PlayerProfileFactUiModel>? facts,
    List<PlayerProfileMetricUiModel>? summaryMetrics,
    List<PlayerProfileTraitUiModel>? traits,
    List<PlayerProfileTrophyUiModel>? trophies,
    List<PlayerProfileMatchGroupUiModel>? matchGroups,
    List<PlayerProfileStatSectionUiModel>? statSections,
    List<PlayerCareerClubUiModel>? seniorCareer,
    List<PlayerCareerClubUiModel>? nationalCareer,
  }) {
    return PlayerProfileViewModel(
      id: id ?? this.id,
      playerName: playerName ?? this.playerName,
      teamName: teamName ?? this.teamName,
      avatarSeed: avatarSeed ?? this.avatarSeed,
      isFollowing: isFollowing ?? this.isFollowing,
      selectedSeason: selectedSeason ?? this.selectedSeason,
      seasons: seasons ?? this.seasons,
      facts: facts ?? this.facts,
      summaryMetrics: summaryMetrics ?? this.summaryMetrics,
      traits: traits ?? this.traits,
      trophies: trophies ?? this.trophies,
      matchGroups: matchGroups ?? this.matchGroups,
      statSections: statSections ?? this.statSections,
      seniorCareer: seniorCareer ?? this.seniorCareer,
      nationalCareer: nationalCareer ?? this.nationalCareer,
    );
  }
}
