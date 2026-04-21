import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../league_details_controller.dart';
import 'league_details_table.dart';

class LeagueDetailsPlayerStatsPage extends GetView<LeagueDetailsController> {
  const LeagueDetailsPlayerStatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LeagueDetailsPlaceholderPage(
      title: controller.playerStatsTitle,
      message: controller.playerStatsMessage,
    );
  }
}
