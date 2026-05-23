class SharedKnockoutNodeUiModel {
  final String homeSeed;
  final String awaySeed;
  final String score;
  final String homeLogoUrl;
  final String awayLogoUrl;
  final bool isHighlighted;

  const SharedKnockoutNodeUiModel({
    required this.homeSeed,
    required this.awaySeed,
    required this.score,
    this.homeLogoUrl = '',
    this.awayLogoUrl = '',
    this.isHighlighted = false,
  });
}

class SharedKnockoutCenterUiModel {
  final String dateLabel;
  final String statusLabel;
  final String homeSeed;
  final String awaySeed;
  final String homeLogoUrl;
  final String awayLogoUrl;
  final bool isFinalHighlight;

  bool get isPlaceholder {
    return homeSeed.trim().toUpperCase() == 'TBD' &&
        awaySeed.trim().toUpperCase() == 'TBD' &&
        homeLogoUrl.trim().isEmpty &&
        awayLogoUrl.trim().isEmpty;
  }

  const SharedKnockoutCenterUiModel({
    required this.dateLabel,
    required this.statusLabel,
    this.homeSeed = 'TBD',
    this.awaySeed = 'TBD',
    this.homeLogoUrl = '',
    this.awayLogoUrl = '',
    this.isFinalHighlight = false,
  });
}

class SharedKnockoutUiModel {
  final List<SharedKnockoutNodeUiModel> topRoundOne;
  final List<SharedKnockoutNodeUiModel> topRoundTwo;
  final SharedKnockoutCenterUiModel upperCenter;
  final SharedKnockoutCenterUiModel finalCenter;
  final SharedKnockoutCenterUiModel lowerCenter;
  final List<SharedKnockoutNodeUiModel> bottomRoundTwo;
  final List<SharedKnockoutNodeUiModel> bottomRoundOne;
  final String championLogoUrl;
  final String championSeed;

  const SharedKnockoutUiModel({
    required this.topRoundOne,
    required this.topRoundTwo,
    required this.upperCenter,
    required this.finalCenter,
    required this.lowerCenter,
    required this.bottomRoundTwo,
    required this.bottomRoundOne,
    this.championLogoUrl = '',
    this.championSeed = '?',
  });
}