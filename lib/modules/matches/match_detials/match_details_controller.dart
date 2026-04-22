import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/routes.dart';
import 'match_details_model.dart';

class MatchDetailsController extends GetxController {
  final Rx<MatchDetailsScreenUiModel> state = _buildScreen(
    MatchDetailsScenario.finished,
  ).obs;
  String teamId = '12345';
  MatchDetailsScenario get scenario => state.value.header.scenario;

  @override
  void onInit() {
    super.onInit();

    final argument = Get.arguments;
    if (argument is String) {
      loadScenario(_scenarioFrom(argument));
      return;
    }

    if (argument is Map<String, dynamic>) {
      final raw = argument['scenario']?.toString() ?? 'finished';
      loadScenario(_scenarioFrom(raw));
    }
  }
  void onTeamNameTap() {
    Get.toNamed(AppRoutes.teamProfile, arguments: teamId);
  }
  void loadScenario(MatchDetailsScenario scenario) {
    state.value = _buildScreen(scenario);
  }

  MatchDetailsScenario _scenarioFrom(String value) {
    switch (value.toLowerCase()) {
      case 'live':
        return MatchDetailsScenario.live;
      case 'upcoming':
        return MatchDetailsScenario.upcoming;
      default:
        return MatchDetailsScenario.finished;
    }
  }

  static const MatchDetailsTeamUiModel _barcelona = MatchDetailsTeamUiModel(
    name: 'Barcelona',
    shortName: 'BAR',
    badgeColor: Color(0xFF7D1F1F),
  );

  static const MatchDetailsTeamUiModel _atletico = MatchDetailsTeamUiModel(
    name: 'Atletico Madrid',
    shortName: 'ATM',
    badgeColor: Color(0xFF274C93),
  );

  static const MatchDetailsVenueUiModel _venue = MatchDetailsVenueUiModel(
    stadiumName: 'Spotify Camp Nou',
    city: 'Barcelona, Spain',
    surface: 'Grass',
    mapLabel: 'Map',
  );

  static const MatchDetailsMetaInfoUiModel _meta = MatchDetailsMetaInfoUiModel(
    dateTime: 'Thu 15 April, 01:00',
    competition: 'Champions League Quarter-final',
    referee: 'István Kovács',
    stage: 'Champions League',
  );

  static const MatchDetailsTopScorerCompareUiModel _topScorers =
      MatchDetailsTopScorerCompareUiModel(
        title: 'Top scorers',
        competitionLabel: 'Champions League',
        homePlayerName: 'Player',
        awayPlayerName: 'Player',
        metrics: <MatchDetailsCompareMetricUiModel>[
          MatchDetailsCompareMetricUiModel(
            label: 'GOALS',
            homeValue: '5',
            awayValue: '8',
          ),
          MatchDetailsCompareMetricUiModel(
            label: 'ASSISTS',
            homeValue: '4',
            awayValue: '4',
          ),
          MatchDetailsCompareMetricUiModel(
            label: 'MATCHES PLAYED',
            homeValue: '11',
            awayValue: '12',
          ),
        ],
      );

  static const MatchDetailsTeamFormUiModel _teamForm = MatchDetailsTeamFormUiModel(
    title: 'Team form',
    homeResults: <String>['1 - 0', '1 - 0', '7 - 2'],
    awayResults: <String>['1 - 2', '3 - 2', '3 - 2'],
  );

  static const String _aboutText =
      'Barcelona faces Atletico Madrid at Spotify Camp Nou on Wed, Apr 8, 2026, 19:00 UTC. '
      'This match is part of the Champions League. You can check the recent head-to-head encounters, '
      'as well as full H2H record on this page to see how Barcelona and Atletico Madrid have fared '
      'against each other in the past. On FotMob, you can follow the Barcelona vs Atletico Madrid '
      'live score with a full set of details.';

  static const MatchDetailsPlayerOfMatchUiModel _playerOfTheMatch =
      MatchDetailsPlayerOfMatchUiModel(
        name: 'Juan Musso',
        teamName: 'ATLETICO MADRID',
      );

  static const List<MatchDetailsStatSectionUiModel> _factsTopStats =
      <MatchDetailsStatSectionUiModel>[
        MatchDetailsStatSectionUiModel(
          title: 'Top stats',
          showPossessionBar: true,
          rows: <MatchDetailsStatRowUiModel>[
            MatchDetailsStatRowUiModel(
              label: 'Ball possession',
              homeValue: '58%',
              awayValue: '42%',
            ),
            MatchDetailsStatRowUiModel(
              label: 'Total shots',
              homeValue: '18',
              awayValue: '5',
            ),
            MatchDetailsStatRowUiModel(
              label: 'Big chances',
              homeValue: '2',
              awayValue: '1',
            ),
          ],
        ),
      ];

  static const List<MatchDetailsEventUiModel> _events =
      <MatchDetailsEventUiModel>[
        MatchDetailsEventUiModel(
          minute: '31’',
          isHomeSide: false,
          type: MatchDetailsEventType.substitution,
          primaryText: 'Marc Pubill',
          secondaryText: 'Dávid Hancko',
          emphasizePrimary: true,
        ),
        MatchDetailsEventUiModel(
          minute: '31’',
          isHomeSide: false,
          type: MatchDetailsEventType.yellowCard,
          primaryText: 'Koke',
        ),
        MatchDetailsEventUiModel(
          minute: '42’',
          isHomeSide: true,
          type: MatchDetailsEventType.info,
          primaryText: 'Yellow card cancelled',
          secondaryText: 'Pau Cubarsí',
        ),
        MatchDetailsEventUiModel(
          minute: '44’',
          isHomeSide: true,
          type: MatchDetailsEventType.redCard,
          primaryText: 'Pau Cubarsí',
        ),
        MatchDetailsEventUiModel(
          minute: '45’',
          isHomeSide: false,
          type: MatchDetailsEventType.goal,
          primaryText: 'Julián Álvarez (0 - 1)',
          secondaryText: 'Direct free kick',
        ),
        MatchDetailsEventUiModel(
          minute: '46’',
          isHomeSide: true,
          type: MatchDetailsEventType.substitution,
          primaryText: 'Fermín López',
          secondaryText: 'Robert Lewandowski',
          emphasizePrimary: true,
        ),
        MatchDetailsEventUiModel(
          minute: '70’',
          isHomeSide: false,
          type: MatchDetailsEventType.goal,
          primaryText: 'Alexander Sørloth (0 - 2)',
          assistText: 'assist by Matteo Ruggeri',
        ),
      ];

  static const List<MatchDetailsTimelineMarkerUiModel> _timelineMarkers =
      <MatchDetailsTimelineMarkerUiModel>[
        MatchDetailsTimelineMarkerUiModel(label: 'HT 0 - 1'),
        MatchDetailsTimelineMarkerUiModel(label: 'FT 0 - 2'),
      ];

  static const List<MatchDetailsNextMatchUiModel> _nextMatches =
      <MatchDetailsNextMatchUiModel>[
        MatchDetailsNextMatchUiModel(
          title: 'Champions League Final Stage',
          timeLabel: '01:00',
          statusText: 'Tomorrow',
          homeTeam: _barcelona,
          awayTeam: _atletico,
        ),
        MatchDetailsNextMatchUiModel(
          title: 'Champions League Final Stage',
          timeLabel: '01:00',
          statusText: 'Tomorrow',
          homeTeam: _barcelona,
          awayTeam: _atletico,
        ),
      ];

  static const List<MatchDetailsStatSectionUiModel> _statsSections =
      <MatchDetailsStatSectionUiModel>[
        MatchDetailsStatSectionUiModel(
          title: 'Top stats',
          showPossessionBar: true,
          rows: <MatchDetailsStatRowUiModel>[
            MatchDetailsStatRowUiModel(
              label: 'Ball possession',
              homeValue: '58%',
              awayValue: '42%',
            ),
            MatchDetailsStatRowUiModel(
              label: 'Total shots',
              homeValue: '18',
              awayValue: '5',
            ),
            MatchDetailsStatRowUiModel(
              label: 'Shots on target',
              homeValue: '2',
              awayValue: '1',
            ),
            MatchDetailsStatRowUiModel(
              label: 'Big chances',
              homeValue: '2',
              awayValue: '1',
            ),
            MatchDetailsStatRowUiModel(
              label: 'Fouls committed',
              homeValue: '2',
              awayValue: '1',
            ),
            MatchDetailsStatRowUiModel(
              label: 'Corners',
              homeValue: '2',
              awayValue: '1',
            ),
          ],
        ),
        MatchDetailsStatSectionUiModel(
          title: 'Shots',
          rows: <MatchDetailsStatRowUiModel>[
            MatchDetailsStatRowUiModel(
              label: 'Total shots',
              homeValue: '18',
              awayValue: '5',
            ),
            MatchDetailsStatRowUiModel(
              label: 'Shots off target',
              homeValue: '2',
              awayValue: '1',
            ),
            MatchDetailsStatRowUiModel(
              label: 'Shots on target',
              homeValue: '2',
              awayValue: '1',
            ),
            MatchDetailsStatRowUiModel(
              label: 'Blocked shots',
              homeValue: '2',
              awayValue: '1',
            ),
            MatchDetailsStatRowUiModel(
              label: 'Hit woodwork',
              homeValue: '2',
              awayValue: '1',
            ),
            MatchDetailsStatRowUiModel(
              label: 'Shots inside box',
              homeValue: '2',
              awayValue: '1',
            ),
            MatchDetailsStatRowUiModel(
              label: 'Shots outside box',
              homeValue: '2',
              awayValue: '1',
            ),
          ],
        ),
        MatchDetailsStatSectionUiModel(
          title: 'Discipline',
          rows: <MatchDetailsStatRowUiModel>[
            MatchDetailsStatRowUiModel(
              label: 'Yellow Cards',
              homeValue: '1',
              awayValue: '3',
            ),
            MatchDetailsStatRowUiModel(
              label: 'Red Cards',
              homeValue: '1',
              awayValue: '0',
            ),
          ],
        ),
        MatchDetailsStatSectionUiModel(
          title: '',
          rows: <MatchDetailsStatRowUiModel>[
            MatchDetailsStatRowUiModel(
              label: 'Passes',
              homeValue: '2',
              awayValue: '1',
            ),
          ],
        ),
        MatchDetailsStatSectionUiModel(
          title: '',
          rows: <MatchDetailsStatRowUiModel>[
            MatchDetailsStatRowUiModel(
              label: 'Throws',
              homeValue: '2',
              awayValue: '1',
            ),
          ],
        ),
        MatchDetailsStatSectionUiModel(
          title: '',
          rows: <MatchDetailsStatRowUiModel>[
            MatchDetailsStatRowUiModel(
              label: 'Offside',
              homeValue: '2',
              awayValue: '1',
            ),
          ],
        ),
        MatchDetailsStatSectionUiModel(
          title: 'Defence',
          rows: <MatchDetailsStatRowUiModel>[
            MatchDetailsStatRowUiModel(
              label: 'Tackles',
              homeValue: '1',
              awayValue: '3',
            ),
            MatchDetailsStatRowUiModel(
              label: 'Interceptions',
              homeValue: '1',
              awayValue: '0',
            ),
            MatchDetailsStatRowUiModel(
              label: 'Blocks',
              homeValue: '1',
              awayValue: '0',
            ),
          ],
        ),
      ];

  static const MatchDetailsHeadToHeadSummaryUiModel _headToHeadSummary =
      MatchDetailsHeadToHeadSummaryUiModel(
        homeWins: 28,
        draws: 12,
        awayWins: 7,
      );

  static const List<MatchDetailsHeadToHeadMatchUiModel> _headToHeadMatches =
      <MatchDetailsHeadToHeadMatchUiModel>[
        MatchDetailsHeadToHeadMatchUiModel(
          dateLabel: 'Tomorrow',
          competitionLabel: 'Champions League',
          homeTeamName: 'Atletico Madrid',
          awayTeamName: 'Barcelona',
          centerLabel: '01:00',
          isUpcoming: true,
        ),
        MatchDetailsHeadToHeadMatchUiModel(
          dateLabel: '5 April',
          competitionLabel: 'LaLiga',
          homeTeamName: 'Atletico Madrid',
          awayTeamName: 'Barcelona',
          centerLabel: '1 - 2',
        ),
        MatchDetailsHeadToHeadMatchUiModel(
          dateLabel: '4 March',
          competitionLabel: 'Copa del Rey',
          homeTeamName: 'Barcelona',
          awayTeamName: 'Atletico Madrid',
          centerLabel: '3 - 0',
        ),
        MatchDetailsHeadToHeadMatchUiModel(
          dateLabel: '13 February',
          competitionLabel: 'Copa del Rey',
          homeTeamName: 'Atletico Madrid',
          awayTeamName: 'Barcelona',
          centerLabel: '4 - 0',
        ),
        MatchDetailsHeadToHeadMatchUiModel(
          dateLabel: '3 December 2025',
          competitionLabel: 'LaLiga',
          homeTeamName: 'Barcelona',
          awayTeamName: 'Atletico Madrid',
          centerLabel: '3 - 1',
        ),
        MatchDetailsHeadToHeadMatchUiModel(
          dateLabel: '3 April 2025',
          competitionLabel: 'Copa del Rey',
          homeTeamName: 'Atletico Madrid',
          awayTeamName: 'Barcelona',
          centerLabel: '0 - 1',
        ),
      ];

  static const MatchDetailsLineupUiModel _lineup = MatchDetailsLineupUiModel(
    isPredicted: true,
    home: MatchDetailsLineupTeamBlockUiModel(
      teamName: 'Barcelona',
      formation: '4-2-3-1',
      players: <MatchDetailsLineupPlayerUiModel>[
        MatchDetailsLineupPlayerUiModel(
          x: 0.50,
          y: 0.12,
          name: 'Player',
          subtitle: '',
        ),
        MatchDetailsLineupPlayerUiModel(
          x: 0.15,
          y: 0.24,
          name: 'Player',
          subtitle: '',
        ),
        MatchDetailsLineupPlayerUiModel(
          x: 0.38,
          y: 0.24,
          name: 'Player',
          subtitle: '',
        ),
        MatchDetailsLineupPlayerUiModel(
          x: 0.62,
          y: 0.24,
          name: 'Player',
          subtitle: '',
        ),
        MatchDetailsLineupPlayerUiModel(
          x: 0.85,
          y: 0.24,
          name: 'Player',
          subtitle: '',
        ),
        MatchDetailsLineupPlayerUiModel(
          x: 0.28,
          y: 0.38,
          name: 'Player',
          subtitle: '',
        ),
        MatchDetailsLineupPlayerUiModel(
          x: 0.72,
          y: 0.38,
          name: 'Player',
          subtitle: '',
        ),
        MatchDetailsLineupPlayerUiModel(
          x: 0.15,
          y: 0.53,
          name: 'Player',
          subtitle: '',
        ),
        MatchDetailsLineupPlayerUiModel(
          x: 0.50,
          y: 0.53,
          name: 'Player',
          subtitle: '',
        ),
        MatchDetailsLineupPlayerUiModel(
          x: 0.85,
          y: 0.53,
          name: 'Player',
          subtitle: '',
        ),
        MatchDetailsLineupPlayerUiModel(
          x: 0.50,
          y: 0.67,
          name: 'Player',
          subtitle: '',
        ),
      ],
    ),
    away: MatchDetailsLineupTeamBlockUiModel(
      teamName: 'Atletico Madrid',
      formation: '4-4-2',
      players: <MatchDetailsLineupPlayerUiModel>[
        MatchDetailsLineupPlayerUiModel(
          x: 0.30,
          y: 0.16,
          name: 'Player',
          subtitle: '',
        ),
        MatchDetailsLineupPlayerUiModel(
          x: 0.70,
          y: 0.16,
          name: 'Player',
          subtitle: '',
        ),
        MatchDetailsLineupPlayerUiModel(
          x: 0.15,
          y: 0.30,
          name: 'Player',
          subtitle: '',
        ),
        MatchDetailsLineupPlayerUiModel(
          x: 0.38,
          y: 0.30,
          name: 'Player',
          subtitle: '',
        ),
        MatchDetailsLineupPlayerUiModel(
          x: 0.62,
          y: 0.30,
          name: 'Player',
          subtitle: '',
        ),
        MatchDetailsLineupPlayerUiModel(
          x: 0.85,
          y: 0.30,
          name: 'Player',
          subtitle: '',
        ),
        MatchDetailsLineupPlayerUiModel(
          x: 0.15,
          y: 0.47,
          name: 'Player',
          subtitle: '',
        ),
        MatchDetailsLineupPlayerUiModel(
          x: 0.38,
          y: 0.47,
          name: 'Player',
          subtitle: '',
        ),
        MatchDetailsLineupPlayerUiModel(
          x: 0.62,
          y: 0.47,
          name: 'Player',
          subtitle: '',
        ),
        MatchDetailsLineupPlayerUiModel(
          x: 0.85,
          y: 0.47,
          name: 'Player',
          subtitle: '',
        ),
        MatchDetailsLineupPlayerUiModel(
          x: 0.50,
          y: 0.65,
          name: 'Player',
          subtitle: '',
        ),
      ],
    ),
    coaches: <MatchDetailsLineupPlayerUiModel>[
      MatchDetailsLineupPlayerUiModel(
        x: 0.20,
        y: 0.50,
        name: 'Player',
        subtitle: '',
      ),
      MatchDetailsLineupPlayerUiModel(
        x: 0.80,
        y: 0.50,
        name: 'Player',
        subtitle: '',
      ),
    ],
    substitutes: <MatchDetailsLineupPlayerUiModel>[
      MatchDetailsLineupPlayerUiModel(
        x: 0.25,
        y: 0.18,
        name: 'Player',
        subtitle: 'Defender',
      ),
      MatchDetailsLineupPlayerUiModel(
        x: 0.75,
        y: 0.18,
        name: 'Player',
        subtitle: 'Defender',
      ),
      MatchDetailsLineupPlayerUiModel(
        x: 0.25,
        y: 0.50,
        name: 'Player',
        subtitle: 'Defender',
      ),
      MatchDetailsLineupPlayerUiModel(
        x: 0.75,
        y: 0.50,
        name: 'Player',
        subtitle: 'Defender',
      ),
      MatchDetailsLineupPlayerUiModel(
        x: 0.25,
        y: 0.82,
        name: 'Player',
        subtitle: 'Defender',
      ),
      MatchDetailsLineupPlayerUiModel(
        x: 0.75,
        y: 0.82,
        name: 'Player',
        subtitle: 'Defender',
      ),
    ],
    bench: <MatchDetailsLineupPlayerUiModel>[
      MatchDetailsLineupPlayerUiModel(
        x: 0.25,
        y: 0.25,
        name: 'Player',
        subtitle: 'Defender',
      ),
      MatchDetailsLineupPlayerUiModel(
        x: 0.75,
        y: 0.25,
        name: 'Player',
        subtitle: 'Defender',
      ),
      MatchDetailsLineupPlayerUiModel(
        x: 0.25,
        y: 0.70,
        name: 'Player',
        subtitle: 'Defender',
      ),
      MatchDetailsLineupPlayerUiModel(
        x: 0.75,
        y: 0.70,
        name: 'Player',
        subtitle: 'Defender',
      ),
    ],
  );

  static const MatchDetailsKnockoutUiModel _knockout = MatchDetailsKnockoutUiModel(
    topRoundOne: <MatchDetailsKnockoutNodeUiModel>[
      MatchDetailsKnockoutNodeUiModel(
        homeSeed: 'ASM',
        awaySeed: 'PSG',
        score: '4 - 5',
      ),
      MatchDetailsKnockoutNodeUiModel(
        homeSeed: 'GAL',
        awaySeed: 'JUV',
        score: '7 - 5',
      ),
      MatchDetailsKnockoutNodeUiModel(
        homeSeed: 'BEN',
        awaySeed: 'RMA',
        score: '1 - 3',
      ),
      MatchDetailsKnockoutNodeUiModel(
        homeSeed: 'BVB',
        awaySeed: 'ATA',
        score: '3 - 4',
      ),
      MatchDetailsKnockoutNodeUiModel(
        homeSeed: 'PSG',
        awaySeed: 'CHE',
        score: '8 - 2',
      ),
      MatchDetailsKnockoutNodeUiModel(
        homeSeed: 'GAL',
        awaySeed: 'LIV',
        score: '1 - 4',
      ),
      MatchDetailsKnockoutNodeUiModel(
        homeSeed: 'RMA',
        awaySeed: 'MCI',
        score: '5 - 1',
      ),
      MatchDetailsKnockoutNodeUiModel(
        homeSeed: 'ATA',
        awaySeed: 'FCB',
        score: '2 - 10',
      ),
    ],
    topRoundTwo: <MatchDetailsKnockoutNodeUiModel>[
      MatchDetailsKnockoutNodeUiModel(
        homeSeed: 'PSG',
        awaySeed: 'LIV',
        score: '2 - 0',
      ),
      MatchDetailsKnockoutNodeUiModel(
        homeSeed: 'RMA',
        awaySeed: 'FCB',
        score: '1 - 2',
      ),
    ],
    upperCenter: MatchDetailsKnockoutCenterUiModel(
      dateLabel: '28 Apr',
      statusLabel: 'TBD',
    ),
    finalCenter: MatchDetailsKnockoutCenterUiModel(
      dateLabel: '30 May',
      statusLabel: 'FINAL',
      isFinalHighlight: true,
    ),
    lowerCenter: MatchDetailsKnockoutCenterUiModel(
      dateLabel: '29 Apr',
      statusLabel: 'TBD',
    ),
    bottomRoundTwo: <MatchDetailsKnockoutNodeUiModel>[
      MatchDetailsKnockoutNodeUiModel(
        homeSeed: 'BAR',
        awaySeed: 'ATM',
        score: '0 - 2',
        isHighlighted: true,
      ),
      MatchDetailsKnockoutNodeUiModel(
        homeSeed: 'SCP',
        awaySeed: 'ARS',
        score: '0 - 1',
      ),
    ],
    bottomRoundOne: <MatchDetailsKnockoutNodeUiModel>[
      MatchDetailsKnockoutNodeUiModel(
        homeSeed: 'NEW',
        awaySeed: 'BAR',
        score: '3 - 8',
      ),
      MatchDetailsKnockoutNodeUiModel(
        homeSeed: 'ATM',
        awaySeed: 'TOT',
        score: '7 - 5',
      ),
      MatchDetailsKnockoutNodeUiModel(
        homeSeed: 'BOD',
        awaySeed: 'SCP',
        score: '3 - 5',
      ),
      MatchDetailsKnockoutNodeUiModel(
        homeSeed: 'BO4',
        awaySeed: 'ARS',
        score: '1 - 3',
      ),
      MatchDetailsKnockoutNodeUiModel(
        homeSeed: 'QRB',
        awaySeed: 'NEW',
        score: '3 - 9',
      ),
      MatchDetailsKnockoutNodeUiModel(
        homeSeed: 'CLB',
        awaySeed: 'ATM',
        score: '4 - 7',
      ),
      MatchDetailsKnockoutNodeUiModel(
        homeSeed: 'BOD',
        awaySeed: 'INT',
        score: '5 - 2',
      ),
      MatchDetailsKnockoutNodeUiModel(
        homeSeed: 'OLY',
        awaySeed: 'BO4',
        score: '0 - 2',
      ),
    ],
  );

  static MatchDetailsScreenUiModel _buildScreen(
    MatchDetailsScenario scenario,
  ) {
    switch (scenario) {
      case MatchDetailsScenario.live:
        return MatchDetailsScreenUiModel(
          title: 'Match Details',
          header: MatchDetailsHeaderUiModel(
            scenario: scenario,
            homeTeam: _barcelona,
            awayTeam: _atletico,
            scoreOrTimeLabel: '0-0',
            statusChipLabel: 'Live',
            statusText: '',
            metaDateTime: 'Thu 15 April, 01:00',
            metaCompetition: 'Champions League',
          ),
          visibleTabs: const <MatchDetailsTabType>[
            MatchDetailsTabType.preview,
            MatchDetailsTabType.lineup,
            MatchDetailsTabType.knockout,
            MatchDetailsTabType.headToHead,
          ],
          venue: _venue,
          meta: _meta,
          topScorers: null,
          teamForm: _teamForm,
          aboutText: _aboutText,
          playerOfTheMatch: null,
          factsTopStats: const <MatchDetailsStatSectionUiModel>[],
          events: const <MatchDetailsEventUiModel>[],
          timelineMarkers: const <MatchDetailsTimelineMarkerUiModel>[],
          nextMatches: const <MatchDetailsNextMatchUiModel>[],
          statsSections: const <MatchDetailsStatSectionUiModel>[],
          headToHeadSummary: _headToHeadSummary,
          headToHeadMatches: _headToHeadMatches,
          lineup: _lineup,
          knockout: _knockout,
        );
      case MatchDetailsScenario.upcoming:
        return MatchDetailsScreenUiModel(
          title: 'Match Details',
          header: MatchDetailsHeaderUiModel(
            scenario: scenario,
            homeTeam: _barcelona,
            awayTeam: _atletico,
            scoreOrTimeLabel: '01:00',
            statusChipLabel: 'Agg 0 - 2',
            statusText: 'Tomorrow',
            metaDateTime: 'Thu 15 April, 01:00',
            metaCompetition: 'Champions League',
          ),
          visibleTabs: const <MatchDetailsTabType>[
            MatchDetailsTabType.preview,
            MatchDetailsTabType.lineup,
            MatchDetailsTabType.knockout,
            MatchDetailsTabType.headToHead,
          ],
          venue: _venue,
          meta: _meta,
          topScorers: _topScorers,
          teamForm: _teamForm,
          aboutText: _aboutText,
          playerOfTheMatch: null,
          factsTopStats: const <MatchDetailsStatSectionUiModel>[],
          events: const <MatchDetailsEventUiModel>[],
          timelineMarkers: const <MatchDetailsTimelineMarkerUiModel>[],
          nextMatches: const <MatchDetailsNextMatchUiModel>[],
          statsSections: const <MatchDetailsStatSectionUiModel>[],
          headToHeadSummary: _headToHeadSummary,
          headToHeadMatches: _headToHeadMatches,
          lineup: _lineup,
          knockout: _knockout,
        );
      case MatchDetailsScenario.finished:
        return MatchDetailsScreenUiModel(
          title: 'Match Details',
          header: MatchDetailsHeaderUiModel(
            scenario: scenario,
            homeTeam: _barcelona,
            awayTeam: _atletico,
            scoreOrTimeLabel: '0 - 2',
            statusChipLabel: '1st leg',
            statusText: 'Full time',
            metaDateTime: 'Thu 9 April, 01:00',
            metaCompetition: 'Champions League',
          ),
          visibleTabs: const <MatchDetailsTabType>[
            MatchDetailsTabType.facts,
            MatchDetailsTabType.lineup,
            MatchDetailsTabType.knockout,
            MatchDetailsTabType.stats,
            MatchDetailsTabType.headToHead,
          ],
          venue: _venue,
          meta: _meta,
          topScorers: null,
          teamForm: _teamForm,
          aboutText: _aboutText,
          playerOfTheMatch: _playerOfTheMatch,
          factsTopStats: _factsTopStats,
          events: _events,
          timelineMarkers: _timelineMarkers,
          nextMatches: _nextMatches,
          statsSections: _statsSections,
          headToHeadSummary: _headToHeadSummary,
          headToHeadMatches: _headToHeadMatches,
          lineup: MatchDetailsLineupUiModel(
            isPredicted: false,
            home: _lineup.home,
            away: _lineup.away,
            coaches: _lineup.coaches,
            substitutes: _lineup.substitutes,
            bench: _lineup.bench,
          ),
          knockout: _knockout,
        );
    }
  }

}

class MatchDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MatchDetailsController>(() => MatchDetailsController());
  }
}