import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../league_details_controller.dart';
import 'league_details_table.dart';

class LeagueDetailsTeamStatsPage extends GetView<LeagueDetailsController> {
  const LeagueDetailsTeamStatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LeagueDetailsPlaceholderPage(
      title: controller.teamStatsTitle,
      message: controller.teamStatsMessage,
    );
  }
}
