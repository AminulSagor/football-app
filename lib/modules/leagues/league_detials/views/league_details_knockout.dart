import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/model/knockout_page_ui_model.dart';
import '../../../shared/shared_knockout_page.dart';
import '../league_details_controller.dart';
import '../models/league_detials_model.dart';

class LeagueDetailsKnockoutPage extends GetView<LeagueDetailsController> {
  const LeagueDetailsKnockoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedKnockoutPage(
      knockout: _buildWorldCupKnockout(),
    );
  }

  SharedKnockoutUiModel _buildWorldCupKnockout() {
    final topSemi = controller.worldCupTopSemiMatch;
    final finalMatch = controller.worldCupFinalMatch;
    final bottomSemi = controller.worldCupBottomSemiMatch;

    return SharedKnockoutUiModel(
      topRoundOne: _mapLeagueMatches(controller.worldCupTopOpeningMatches),
      topRoundTwo: _mapLeagueMatches(controller.worldCupTopQuarterMatches),
      upperCenter: SharedKnockoutCenterUiModel(
        dateLabel: topSemi.dateLabel,
        statusLabel: 'TBD',
      ),
      finalCenter: SharedKnockoutCenterUiModel(
        dateLabel: finalMatch.dateLabel,
        statusLabel: _centerStatusLabel(finalMatch),
        isFinalHighlight: finalMatch.isHighlighted,
      ),
      lowerCenter: SharedKnockoutCenterUiModel(
        dateLabel: bottomSemi.dateLabel,
        statusLabel: 'TBD',
      ),
      bottomRoundTwo: _mapLeagueMatches(controller.worldCupBottomQuarterMatches),
      bottomRoundOne: _mapLeagueMatches(controller.worldCupBottomOpeningMatches),
    );
  }
}

List<SharedKnockoutNodeUiModel> _mapLeagueMatches(
  List<LeagueDetailsKnockoutMatchUiModel> matches,
) {
  return matches
      .map(
        (match) => SharedKnockoutNodeUiModel(
          homeSeed: match.homeSeed,
          awaySeed: match.awaySeed,
          score: match.dateLabel.isEmpty ? 'TBD' : match.dateLabel,
          isHighlighted: match.isHighlighted,
        ),
      )
      .toList(growable: false);
}

String _centerStatusLabel(LeagueDetailsKnockoutMatchUiModel match) {
  if (match.showChampionMark) {
    return 'FINAL';
  }

  if (match.isHighlighted) {
    return 'LIVE';
  }

  return 'TBD';
}
