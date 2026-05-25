import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/model/knockout_page_ui_model.dart';
import '../../../../core/widgets/shared_knockout_page.dart';
import '../league_details_controller.dart';
import '../models/league_detials_model.dart';

class LeagueDetailsKnockoutPage extends GetView<LeagueDetailsController> {
  const LeagueDetailsKnockoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.state.value;
      return Skeletonizer(
        enabled: state.isKnockoutLoading && !state.hasLoadedKnockout,
        child: SharedKnockoutPage(knockout: _buildWorldCupKnockout()),
      );
    });
  }

  SharedKnockoutUiModel _buildWorldCupKnockout() {
    final topSemi = controller.worldCupTopSemiMatch;
    final finalMatch = controller.worldCupFinalMatch;
    final bottomSemi = controller.worldCupBottomSemiMatch;

    return SharedKnockoutUiModel(
      topRoundOne: _mapLeagueMatches(controller.worldCupTopOpeningMatches),
      topRoundTwo: _mapLeagueMatches(controller.worldCupTopQuarterMatches),
      upperCenter: _mapCenterMatch(topSemi),
      finalCenter: _mapCenterMatch(finalMatch, isFinal: true),
      lowerCenter: _mapCenterMatch(bottomSemi),
      bottomRoundTwo: _mapLeagueMatches(
        controller.worldCupBottomQuarterMatches,
      ),
      bottomRoundOne: _mapLeagueMatches(
        controller.worldCupBottomOpeningMatches,
      ),
      championLogoUrl: _championLogoUrl(finalMatch),
      championSeed: _championSeed(finalMatch),
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
          homeLogoUrl: match.homeLogoUrl,
          awayLogoUrl: match.awayLogoUrl,
          isHighlighted: match.isHighlighted,
        ),
      )
      .toList(growable: false);
}

SharedKnockoutCenterUiModel _mapCenterMatch(
  LeagueDetailsKnockoutMatchUiModel match, {
  bool isFinal = false,
}) {
  return SharedKnockoutCenterUiModel(
    dateLabel: match.dateLabel.isEmpty ? 'TBD' : match.dateLabel,
    statusLabel: _centerStatusLabel(match),
    homeSeed: match.homeSeed,
    awaySeed: match.awaySeed,
    homeLogoUrl: match.homeLogoUrl,
    awayLogoUrl: match.awayLogoUrl,
    isFinalHighlight: isFinal || match.isHighlighted,
  );
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

String _championLogoUrl(LeagueDetailsKnockoutMatchUiModel match) {
  if (!match.isFinished) {
    return '';
  }
  if (match.homeWinner) {
    return match.homeLogoUrl;
  }
  if (match.awayWinner) {
    return match.awayLogoUrl;
  }
  return '';
}

String _championSeed(LeagueDetailsKnockoutMatchUiModel match) {
  if (!match.isFinished) {
    return '?';
  }
  if (match.homeWinner) {
    return match.homeSeed;
  }
  if (match.awayWinner) {
    return match.awaySeed;
  }
  return '?';
}
