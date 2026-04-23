import 'package:flutter/material.dart';

enum MatchDetailsScenario { live, upcoming, finished }

enum MatchDetailsTabType {
  preview,
  facts,
  lineup,
  knockout,
  stats,
  headToHead,
}

class MatchDetailsTeamUiModel {
  final String name;
  final String shortName;
  final Color badgeColor;

  const MatchDetailsTeamUiModel({
    required this.name,
    required this.shortName,
    required this.badgeColor,
  });
}

class MatchDetailsHeaderUiModel {
  final MatchDetailsScenario scenario;
  final MatchDetailsTeamUiModel homeTeam;
  final MatchDetailsTeamUiModel awayTeam;
  final String scoreOrTimeLabel;
  final String statusChipLabel;
  final String statusText;
  final String metaDateTime;
  final String metaCompetition;

  const MatchDetailsHeaderUiModel({
    required this.scenario,
    required this.homeTeam,
    required this.awayTeam,
    required this.scoreOrTimeLabel,
    required this.statusChipLabel,
    required this.statusText,
    required this.metaDateTime,
    required this.metaCompetition,
  });
}

class MatchDetailsVenueUiModel {
  final String stadiumName;
  final String city;
  final String surface;
  final String mapLabel;

  const MatchDetailsVenueUiModel({
    required this.stadiumName,
    required this.city,
    required this.surface,
    required this.mapLabel,
  });
}

class MatchDetailsMetaInfoUiModel {
  final String dateTime;
  final String competition;
  final String referee;
  final String stage;

  const MatchDetailsMetaInfoUiModel({
    required this.dateTime,
    required this.competition,
    required this.referee,
    required this.stage,
  });
}

class MatchDetailsTopScorerCompareUiModel {
  final String title;
  final String competitionLabel;
  final String homePlayerName;
  final String awayPlayerName;
  final List<MatchDetailsCompareMetricUiModel> metrics;

  const MatchDetailsTopScorerCompareUiModel({
    required this.title,
    required this.competitionLabel,
    required this.homePlayerName,
    required this.awayPlayerName,
    required this.metrics,
  });
}

class MatchDetailsCompareMetricUiModel {
  final String label;
  final String homeValue;
  final String awayValue;

  const MatchDetailsCompareMetricUiModel({
    required this.label,
    required this.homeValue,
    required this.awayValue,
  });
}

class MatchDetailsTeamFormUiModel {
  final String title;
  final List<String> homeResults;
  final List<String> awayResults;

  const MatchDetailsTeamFormUiModel({
    required this.title,
    required this.homeResults,
    required this.awayResults,
  });
}

class MatchDetailsPlayerOfMatchUiModel {
  final String name;
  final String teamName;

  const MatchDetailsPlayerOfMatchUiModel({
    required this.name,
    required this.teamName,
  });
}

class MatchDetailsStatRowUiModel {
  final String label;
  final String homeValue;
  final String awayValue;

  const MatchDetailsStatRowUiModel({
    required this.label,
    required this.homeValue,
    required this.awayValue,
  });
}

class MatchDetailsStatSectionUiModel {
  final String title;
  final List<MatchDetailsStatRowUiModel> rows;
  final bool showPossessionBar;

  const MatchDetailsStatSectionUiModel({
    required this.title,
    required this.rows,
    this.showPossessionBar = false,
  });
}

enum MatchDetailsEventType {
  goal,
  substitution,
  yellowCard,
  redCard,
  info,
}

class MatchDetailsEventUiModel {
  final String minute;
  final bool isHomeSide;
  final MatchDetailsEventType type;
  final String primaryText;
  final String? secondaryText;
  final String? assistText;
  final bool emphasizePrimary;

  const MatchDetailsEventUiModel({
    required this.minute,
    required this.isHomeSide,
    required this.type,
    required this.primaryText,
    this.secondaryText,
    this.assistText,
    this.emphasizePrimary = false,
  });
}

class MatchDetailsTimelineMarkerUiModel {
  final String label;

  const MatchDetailsTimelineMarkerUiModel({required this.label});
}

class MatchDetailsNextMatchUiModel {
  final String title;
  final String timeLabel;
  final String statusText;
  final MatchDetailsTeamUiModel homeTeam;
  final MatchDetailsTeamUiModel awayTeam;

  const MatchDetailsNextMatchUiModel({
    required this.title,
    required this.timeLabel,
    required this.statusText,
    required this.homeTeam,
    required this.awayTeam,
  });
}

class MatchDetailsHeadToHeadSummaryUiModel {
  final int homeWins;
  final int draws;
  final int awayWins;

  const MatchDetailsHeadToHeadSummaryUiModel({
    required this.homeWins,
    required this.draws,
    required this.awayWins,
  });
}

class MatchDetailsHeadToHeadMatchUiModel {
  final String dateLabel;
  final String competitionLabel;
  final String homeTeamName;
  final String awayTeamName;
  final String centerLabel;
  final bool isUpcoming;

  const MatchDetailsHeadToHeadMatchUiModel({
    required this.dateLabel,
    required this.competitionLabel,
    required this.homeTeamName,
    required this.awayTeamName,
    required this.centerLabel,
    this.isUpcoming = false,
  });
}

class MatchDetailsLineupPlayerUiModel {
  final double x;
  final double y;
  final String name;
  final String subtitle;

  const MatchDetailsLineupPlayerUiModel({
    required this.x,
    required this.y,
    required this.name,
    required this.subtitle,
  });
}

class MatchDetailsLineupTeamBlockUiModel {
  final String teamName;
  final String formation;
  final List<MatchDetailsLineupPlayerUiModel> players;

  const MatchDetailsLineupTeamBlockUiModel({
    required this.teamName,
    required this.formation,
    required this.players,
  });
}

class MatchDetailsLineupUiModel {
  final bool isPredicted;
  final MatchDetailsLineupTeamBlockUiModel home;
  final MatchDetailsLineupTeamBlockUiModel away;
  final List<MatchDetailsLineupPlayerUiModel> coaches;
  final List<MatchDetailsLineupPlayerUiModel> substitutes;
  final List<MatchDetailsLineupPlayerUiModel> bench;

  const MatchDetailsLineupUiModel({
    required this.isPredicted,
    required this.home,
    required this.away,
    required this.coaches,
    required this.substitutes,
    required this.bench,
  });
}

class MatchDetailsKnockoutNodeUiModel {
  final String homeSeed;
  final String awaySeed;
  final String score;
  final bool isHighlighted;

  const MatchDetailsKnockoutNodeUiModel({
    required this.homeSeed,
    required this.awaySeed,
    required this.score,
    this.isHighlighted = false,
  });
}

class MatchDetailsKnockoutCenterUiModel {
  final String dateLabel;
  final String statusLabel;
  final bool isFinalHighlight;

  const MatchDetailsKnockoutCenterUiModel({
    required this.dateLabel,
    required this.statusLabel,
    this.isFinalHighlight = false,
  });
}

class MatchDetailsKnockoutUiModel {
  final List<MatchDetailsKnockoutNodeUiModel> topRoundOne;
  final List<MatchDetailsKnockoutNodeUiModel> topRoundTwo;
  final MatchDetailsKnockoutCenterUiModel upperCenter;
  final MatchDetailsKnockoutCenterUiModel finalCenter;
  final MatchDetailsKnockoutCenterUiModel lowerCenter;
  final List<MatchDetailsKnockoutNodeUiModel> bottomRoundTwo;
  final List<MatchDetailsKnockoutNodeUiModel> bottomRoundOne;

  const MatchDetailsKnockoutUiModel({
    required this.topRoundOne,
    required this.topRoundTwo,
    required this.upperCenter,
    required this.finalCenter,
    required this.lowerCenter,
    required this.bottomRoundTwo,
    required this.bottomRoundOne,
  });
}

class MatchDetailsScreenUiModel {
  final String title;
  final MatchDetailsHeaderUiModel header;
  final List<MatchDetailsTabType> visibleTabs;
  final MatchDetailsVenueUiModel venue;
  final MatchDetailsMetaInfoUiModel meta;
  final MatchDetailsTopScorerCompareUiModel? topScorers;
  final MatchDetailsTeamFormUiModel teamForm;
  final String aboutText;
  final MatchDetailsPlayerOfMatchUiModel? playerOfTheMatch;
  final List<MatchDetailsStatSectionUiModel> factsTopStats;
  final List<MatchDetailsEventUiModel> events;
  final List<MatchDetailsTimelineMarkerUiModel> timelineMarkers;
  final List<MatchDetailsNextMatchUiModel> nextMatches;
  final List<MatchDetailsStatSectionUiModel> statsSections;
  final MatchDetailsHeadToHeadSummaryUiModel headToHeadSummary;
  final List<MatchDetailsHeadToHeadMatchUiModel> headToHeadMatches;
  final MatchDetailsLineupUiModel lineup;
  final MatchDetailsKnockoutUiModel knockout;

  const MatchDetailsScreenUiModel({
    required this.title,
    required this.header,
    required this.visibleTabs,
    required this.venue,
    required this.meta,
    required this.topScorers,
    required this.teamForm,
    required this.aboutText,
    required this.playerOfTheMatch,
    required this.factsTopStats,
    required this.events,
    required this.timelineMarkers,
    required this.nextMatches,
    required this.statsSections,
    required this.headToHeadSummary,
    required this.headToHeadMatches,
    required this.lineup,
    required this.knockout,
  });
}