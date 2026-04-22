import 'package:flutter/material.dart';

class CoachProfileFactUiModel {
  final String value;
  final String label;
  final bool highlighted;

  const CoachProfileFactUiModel({
    required this.value,
    required this.label,
    this.highlighted = false,
  });
}

class CoachProfileRecordUiModel {
  final String title;
  final String value;
  final double progress;
  final Color color;

  const CoachProfileRecordUiModel({
    required this.title,
    required this.value,
    required this.progress,
    required this.color,
  });
}

class CoachCareerItemUiModel {
  final String title;
  final String rangeLabel;
  final String seed;

  const CoachCareerItemUiModel({
    required this.title,
    required this.rangeLabel,
    required this.seed,
  });
}

class CoachProfileTrophyUiModel {
  final String title;
  final String country;
  final String season;
  final String result;
  final String seed;

  const CoachProfileTrophyUiModel({
    required this.title,
    required this.country,
    required this.season,
    required this.result,
    required this.seed,
  });
}

class CoachProfileViewModel {
  final String id;
  final String coachName;
  final String teamName;
  final String avatarSeed;
  final bool isFollowing;
  final List<CoachProfileFactUiModel> facts;
  final String matches;
  final String currentClub;
  final List<CoachProfileRecordUiModel> records;
  final List<CoachProfileTrophyUiModel> trophies;
  final List<CoachCareerItemUiModel> careerItems;

  const CoachProfileViewModel({
    required this.id,
    required this.coachName,
    required this.teamName,
    required this.avatarSeed,
    this.isFollowing = false,
    this.facts = const <CoachProfileFactUiModel>[],
    this.matches = '',
    this.currentClub = '',
    this.records = const <CoachProfileRecordUiModel>[],
    this.trophies = const <CoachProfileTrophyUiModel>[],
    this.careerItems = const <CoachCareerItemUiModel>[],
  });

  CoachProfileViewModel copyWith({
    String? id,
    String? coachName,
    String? teamName,
    String? avatarSeed,
    bool? isFollowing,
    List<CoachProfileFactUiModel>? facts,
    String? matches,
    String? currentClub,
    List<CoachProfileRecordUiModel>? records,
    List<CoachProfileTrophyUiModel>? trophies,
    List<CoachCareerItemUiModel>? careerItems,
  }) {
    return CoachProfileViewModel(
      id: id ?? this.id,
      coachName: coachName ?? this.coachName,
      teamName: teamName ?? this.teamName,
      avatarSeed: avatarSeed ?? this.avatarSeed,
      isFollowing: isFollowing ?? this.isFollowing,
      facts: facts ?? this.facts,
      matches: matches ?? this.matches,
      currentClub: currentClub ?? this.currentClub,
      records: records ?? this.records,
      trophies: trophies ?? this.trophies,
      careerItems: careerItems ?? this.careerItems,
    );
  }
}
