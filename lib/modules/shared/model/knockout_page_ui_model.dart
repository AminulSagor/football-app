class SharedKnockoutNodeUiModel {
  final String homeSeed;
  final String awaySeed;
  final String score;
  final bool isHighlighted;

  const SharedKnockoutNodeUiModel({
    required this.homeSeed,
    required this.awaySeed,
    required this.score,
    this.isHighlighted = false,
  });
}

class SharedKnockoutCenterUiModel {
  final String dateLabel;
  final String statusLabel;
  final bool isFinalHighlight;

  const SharedKnockoutCenterUiModel({
    required this.dateLabel,
    required this.statusLabel,
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

  const SharedKnockoutUiModel({
    required this.topRoundOne,
    required this.topRoundTwo,
    required this.upperCenter,
    required this.finalCenter,
    required this.lowerCenter,
    required this.bottomRoundTwo,
    required this.bottomRoundOne,
  });
}