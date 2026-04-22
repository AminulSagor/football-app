import 'package:flutter/material.dart';

import '../../core/services/following_service.dart';

enum FollowingTabType { leagues, players, teams, coach }

class FollowingItemUiModel {
  final String id;
  final String title;
  final String subtitle;
  final String seed;
  final Color accentColor;
  final FollowEntityType type;

  const FollowingItemUiModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.seed,
    required this.accentColor,
    required this.type,
  });
}

class FollowingTabSectionUiModel {
  final List<FollowingItemUiModel> followingItems;
  final List<FollowingItemUiModel> trendingItems;

  const FollowingTabSectionUiModel({
    this.followingItems = const <FollowingItemUiModel>[],
    this.trendingItems = const <FollowingItemUiModel>[],
  });
}

class FollowingViewModel {
  final FollowingTabType selectedTab;
  final FollowingTabSectionUiModel leagues;
  final FollowingTabSectionUiModel players;
  final FollowingTabSectionUiModel teams;
  final FollowingTabSectionUiModel coach;

  const FollowingViewModel({
    this.selectedTab = FollowingTabType.leagues,
    this.leagues = const FollowingTabSectionUiModel(),
    this.players = const FollowingTabSectionUiModel(),
    this.teams = const FollowingTabSectionUiModel(),
    this.coach = const FollowingTabSectionUiModel(),
  });

  FollowingTabSectionUiModel get activeSection {
    switch (selectedTab) {
      case FollowingTabType.leagues:
        return leagues;
      case FollowingTabType.players:
        return players;
      case FollowingTabType.teams:
        return teams;
      case FollowingTabType.coach:
        return coach;
    }
  }

  FollowingViewModel copyWith({
    FollowingTabType? selectedTab,
    FollowingTabSectionUiModel? leagues,
    FollowingTabSectionUiModel? players,
    FollowingTabSectionUiModel? teams,
    FollowingTabSectionUiModel? coach,
  }) {
    return FollowingViewModel(
      selectedTab: selectedTab ?? this.selectedTab,
      leagues: leagues ?? this.leagues,
      players: players ?? this.players,
      teams: teams ?? this.teams,
      coach: coach ?? this.coach,
    );
  }
}
