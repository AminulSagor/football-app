import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/model/knockout_page_ui_model.dart';
import '../../../shared/shared_knockout_page.dart';
import '../match_details_controller.dart';
import '../models/match_details_model.dart';

class MatchDetailsKnockoutPage extends GetView<MatchDetailsController> {
  const MatchDetailsKnockoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final knockout = controller.state.value.knockout;

      return SharedKnockoutPage(
        knockout: _mapMatchKnockout(knockout),
      );
    });
  }
}

SharedKnockoutUiModel _mapMatchKnockout(MatchDetailsKnockoutUiModel source) {
  return SharedKnockoutUiModel(
    topRoundOne: _mapMatchNodes(source.topRoundOne),
    topRoundTwo: _mapMatchNodes(source.topRoundTwo),
    upperCenter: _mapMatchCenter(source.upperCenter),
    finalCenter: _mapMatchCenter(source.finalCenter),
    lowerCenter: _mapMatchCenter(source.lowerCenter),
    bottomRoundTwo: _mapMatchNodes(source.bottomRoundTwo),
    bottomRoundOne: _mapMatchNodes(source.bottomRoundOne),
  );
}

List<SharedKnockoutNodeUiModel> _mapMatchNodes(
  List<MatchDetailsKnockoutNodeUiModel> nodes,
) {
  return nodes
      .map(
        (node) => SharedKnockoutNodeUiModel(
          homeSeed: node.homeSeed,
          awaySeed: node.awaySeed,
          score: node.score,
          isHighlighted: node.isHighlighted,
        ),
      )
      .toList(growable: false);
}

SharedKnockoutCenterUiModel _mapMatchCenter(
  MatchDetailsKnockoutCenterUiModel center,
) {
  return SharedKnockoutCenterUiModel(
    dateLabel: center.dateLabel,
    statusLabel: center.statusLabel,
    isFinalHighlight: center.isFinalHighlight,
  );
}
