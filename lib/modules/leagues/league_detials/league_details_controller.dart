import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/following_service.dart';
import '../model/leagues_models.dart';
import 'models/league_detials_model.dart';

class LeagueDetailsController extends GetxController {
  static const List<String> _demoSeasons = <String>[
    '2025/2026',
    '2024/2025',
    '2023/2024',
  ];

  static const List<String> _worldCupSeasons = <String>['2026', '2022', '2018'];

  static const List<LeagueDetailsStandingsRowUiModel> _demoStandingsRows =
      <LeagueDetailsStandingsRowUiModel>[
        LeagueDetailsStandingsRowUiModel(
          rank: '1',
          teamName: 'Arsenal',
          badgeSeed: 'A',
          badgeColor: Color(0xFFBD1D28),
          played: '32',
          plusMinus: '62-24',
          goalDifference: '+38',
          points: '70',
        ),
        LeagueDetailsStandingsRowUiModel(
          rank: '2',
          teamName: 'Man City',
          badgeSeed: 'MC',
          badgeColor: Color(0xFF5CB9FF),
          played: '30',
          plusMinus: '60-28',
          goalDifference: '+32',
          points: '61',
        ),
        LeagueDetailsStandingsRowUiModel(
          rank: '3',
          teamName: 'Man United',
          badgeSeed: 'MU',
          badgeColor: Color(0xFFC13329),
          played: '31',
          plusMinus: '56-43',
          goalDifference: '+13',
          points: '55',
        ),
        LeagueDetailsStandingsRowUiModel(
          rank: '4',
          teamName: 'Aston Villa',
          badgeSeed: 'AV',
          badgeColor: Color(0xFF89C1F5),
          played: '31',
          plusMinus: '57-52',
          goalDifference: '+5',
          points: '54',
        ),
        LeagueDetailsStandingsRowUiModel(
          rank: '5',
          teamName: 'Liverpool',
          badgeSeed: 'LIV',
          badgeColor: Color(0xFFB91C1C),
          played: '32',
          plusMinus: '58-48',
          goalDifference: '+10',
          points: '52',
        ),
        LeagueDetailsStandingsRowUiModel(
          rank: '6',
          teamName: 'Chelsea',
          badgeSeed: 'CHE',
          badgeColor: Color(0xFF3B82F6),
          played: '31',
          plusMinus: '54-39',
          goalDifference: '+15',
          points: '48',
        ),
        LeagueDetailsStandingsRowUiModel(
          rank: '7',
          teamName: 'Brentford',
          badgeSeed: 'BRE',
          badgeColor: Color(0xFFD22B2B),
          played: '32',
          plusMinus: '53-49',
          goalDifference: '+4',
          points: '47',
        ),
        LeagueDetailsStandingsRowUiModel(
          rank: '8',
          teamName: 'Everton',
          badgeSeed: 'EVE',
          badgeColor: Color(0xFF244A95),
          played: '32',
          plusMinus: '49-47',
          goalDifference: '+2',
          points: '47',
        ),
        LeagueDetailsStandingsRowUiModel(
          rank: '9',
          teamName: 'Brighton',
          badgeSeed: 'BHA',
          badgeColor: Color(0xFF1F7FDB),
          played: '32',
          plusMinus: '56-50',
          goalDifference: '+6',
          points: '46',
        ),
        LeagueDetailsStandingsRowUiModel(
          rank: '10',
          teamName: 'Bournemouth',
          badgeSeed: 'BOU',
          badgeColor: Color(0xFF7F1D1D),
          played: '32',
          plusMinus: '42-43',
          goalDifference: '-1',
          points: '45',
        ),
        LeagueDetailsStandingsRowUiModel(
          rank: '11',
          teamName: 'Fulham',
          badgeSeed: 'FUL',
          badgeColor: Color(0xFF101010),
          played: '32',
          plusMinus: '41-44',
          goalDifference: '-3',
          points: '44',
        ),
        LeagueDetailsStandingsRowUiModel(
          rank: '12',
          teamName: 'Sunderland',
          badgeSeed: 'SUN',
          badgeColor: Color(0xFFE11D48),
          played: '31',
          plusMinus: '38-42',
          goalDifference: '-4',
          points: '43',
        ),
        LeagueDetailsStandingsRowUiModel(
          rank: '13',
          teamName: 'Newcastle',
          badgeSeed: 'NEW',
          badgeColor: Color(0xFF1E293B),
          played: '31',
          plusMinus: '43-44',
          goalDifference: '-1',
          points: '42',
        ),
        LeagueDetailsStandingsRowUiModel(
          rank: '14',
          teamName: 'Wolves',
          badgeSeed: 'WOL',
          badgeColor: Color(0xFFF59E0B),
          played: '32',
          plusMinus: '34-42',
          goalDifference: '-8',
          points: '40',
        ),
        LeagueDetailsStandingsRowUiModel(
          rank: '15',
          teamName: 'West Ham',
          badgeSeed: 'WHU',
          badgeColor: Color(0xFF7C1F3A),
          played: '32',
          plusMinus: '30-41',
          goalDifference: '-11',
          points: '38',
        ),
        LeagueDetailsStandingsRowUiModel(
          rank: '16',
          teamName: 'Crystal Palace',
          badgeSeed: 'CRY',
          badgeColor: Color(0xFF1D4ED8),
          played: '32',
          plusMinus: '28-40',
          goalDifference: '-12',
          points: '35',
        ),
        LeagueDetailsStandingsRowUiModel(
          rank: '17',
          teamName: 'Leicester',
          badgeSeed: 'LEI',
          badgeColor: Color(0xFF2563EB),
          played: '32',
          plusMinus: '24-40',
          goalDifference: '-16',
          points: '32',
        ),
        LeagueDetailsStandingsRowUiModel(
          rank: '18',
          teamName: 'Luton Town',
          badgeSeed: 'LUT',
          badgeColor: Color(0xFF1D4ED8),
          played: '32',
          plusMinus: '22-49',
          goalDifference: '-27',
          points: '25',
        ),
        LeagueDetailsStandingsRowUiModel(
          rank: '19',
          teamName: 'Burnley',
          badgeSeed: 'BUR',
          badgeColor: Color(0xFF8B2F2F),
          played: '32',
          plusMinus: '20-56',
          goalDifference: '-36',
          points: '21',
        ),
        LeagueDetailsStandingsRowUiModel(
          rank: '20',
          teamName: 'Sheffield Utd',
          badgeSeed: 'SHU',
          badgeColor: Color(0xFFDC2626),
          played: '32',
          plusMinus: '18-66',
          goalDifference: '-48',
          points: '16',
        ),
      ];

  static final LeagueDetailsOverviewUiModel _demoOverview =
      LeagueDetailsOverviewUiModel(
        teamName: 'Team name',
        roundLabel: 'Round 31',
        topThreeRows: _demoStandingsRows.take(3).toList(growable: false),
        topScorers: <LeagueDetailsPlayerStatRowUiModel>[
          LeagueDetailsPlayerStatRowUiModel(
            rank: '1.',
            name: 'Erling Haaland',
            teamName: 'Manchester City',
            value: '7',
          ),
          LeagueDetailsPlayerStatRowUiModel(
            rank: '2.',
            name: 'Igor Thiago',
            teamName: 'Brentford',
            value: '4',
          ),
          LeagueDetailsPlayerStatRowUiModel(
            rank: '3.',
            name: 'Antoine Semenyo',
            teamName: 'Bournemouth',
            value: '3',
          ),
        ],
        topAssists: <LeagueDetailsPlayerStatRowUiModel>[
          LeagueDetailsPlayerStatRowUiModel(
            rank: '1.',
            name: 'Bruno Fernandes',
            teamName: 'Manchester United',
            value: '5',
          ),
          LeagueDetailsPlayerStatRowUiModel(
            rank: '2.',
            name: 'Rayan Cherki',
            teamName: 'Fulham',
            value: '3',
          ),
          LeagueDetailsPlayerStatRowUiModel(
            rank: '3.',
            name: 'Jarrod Bowen',
            teamName: 'West Ham United',
            value: '3',
          ),
        ],
        teamOfTheWeekPlayers: <LeagueDetailsPitchPlayerPositionUiModel>[
          LeagueDetailsPitchPlayerPositionUiModel(
            x: 0.26,
            y: 0.12,
            label: 'Player',
          ),
          LeagueDetailsPitchPlayerPositionUiModel(
            x: 0.77,
            y: 0.12,
            label: 'Player',
          ),
          LeagueDetailsPitchPlayerPositionUiModel(
            x: 0.52,
            y: 0.33,
            label: 'Player',
          ),
          LeagueDetailsPitchPlayerPositionUiModel(
            x: 0.18,
            y: 0.46,
            label: 'Player',
          ),
          LeagueDetailsPitchPlayerPositionUiModel(
            x: 0.52,
            y: 0.56,
            label: 'Player',
          ),
          LeagueDetailsPitchPlayerPositionUiModel(
            x: 0.84,
            y: 0.46,
            label: 'Player',
          ),
          LeagueDetailsPitchPlayerPositionUiModel(
            x: 0.18,
            y: 0.74,
            label: 'Player',
          ),
          LeagueDetailsPitchPlayerPositionUiModel(
            x: 0.39,
            y: 0.74,
            label: 'Player',
          ),
          LeagueDetailsPitchPlayerPositionUiModel(
            x: 0.57,
            y: 0.74,
            label: 'Player',
          ),
          LeagueDetailsPitchPlayerPositionUiModel(
            x: 0.83,
            y: 0.74,
            label: 'Player',
          ),
          LeagueDetailsPitchPlayerPositionUiModel(
            x: 0.52,
            y: 0.92,
            label: 'Player',
          ),
        ],
      );

  static const LeagueDetailsFixtureTeamUiModel _arsenalTeam =
      LeagueDetailsFixtureTeamUiModel(
        teamName: 'Arsenal',
        shortName: 'ARS',
        badgeColor: Color(0xFFB53A3A),
      );
  static const LeagueDetailsFixtureTeamUiModel _crystalPalaceTeam =
      LeagueDetailsFixtureTeamUiModel(
        teamName: 'Crystal Palace',
        shortName: 'CRY',
        badgeColor: Color(0xFF274A8E),
      );
  static const LeagueDetailsFixtureTeamUiModel _newcastleUnitedTeam =
      LeagueDetailsFixtureTeamUiModel(
        teamName: 'Newcastle United',
        shortName: 'NEW',
        badgeColor: Color(0xFF273238),
      );
  static const LeagueDetailsFixtureTeamUiModel _nottinghamForestTeam =
      LeagueDetailsFixtureTeamUiModel(
        teamName: 'Nottingham Forest',
        shortName: 'NFO',
        badgeColor: Color(0xFFB91C1C),
      );
  static const LeagueDetailsFixtureTeamUiModel _astonVillaTeam =
      LeagueDetailsFixtureTeamUiModel(
        teamName: 'Aston Villa',
        shortName: 'AVL',
        badgeColor: Color(0xFF8CAFE6),
      );
  static const LeagueDetailsFixtureTeamUiModel _sunderlandTeam =
      LeagueDetailsFixtureTeamUiModel(
        teamName: 'Sunderland',
        shortName: 'SUN',
        badgeColor: Color(0xFFE11D48),
      );
  static const LeagueDetailsFixtureTeamUiModel _tottenhamHotspurTeam =
      LeagueDetailsFixtureTeamUiModel(
        teamName: 'Tottenham Hotspur',
        shortName: 'TOT',
        badgeColor: Color(0xFFC7D2DA),
      );
  static const LeagueDetailsFixtureTeamUiModel _chelseaTeam =
      LeagueDetailsFixtureTeamUiModel(
        teamName: 'Chelsea',
        shortName: 'CHE',
        badgeColor: Color(0xFF355FBD),
      );
  static const LeagueDetailsFixtureTeamUiModel _manchesterCityTeam =
      LeagueDetailsFixtureTeamUiModel(
        teamName: 'Manchester City',
        shortName: 'MCI',
        badgeColor: Color(0xFF5EA0D6),
      );
  static const LeagueDetailsFixtureTeamUiModel _brentfordTeam =
      LeagueDetailsFixtureTeamUiModel(
        teamName: 'Brentford',
        shortName: 'BRE',
        badgeColor: Color(0xFFD02B2B),
      );
  static const LeagueDetailsFixtureTeamUiModel _fulhamTeam =
      LeagueDetailsFixtureTeamUiModel(
        teamName: 'Fulham',
        shortName: 'FUL',
        badgeColor: Color(0xFF101010),
      );
  static const LeagueDetailsFixtureTeamUiModel _leedsUnitedTeam =
      LeagueDetailsFixtureTeamUiModel(
        teamName: 'Leeds United',
        shortName: 'LEE',
        badgeColor: Color(0xFF2F77C8),
      );
  static const LeagueDetailsFixtureTeamUiModel _wolverhamptonTeam =
      LeagueDetailsFixtureTeamUiModel(
        teamName: 'Wolverham. Wanderers',
        shortName: 'WOL',
        badgeColor: Color(0xFFCC8A19),
      );
  static const LeagueDetailsFixtureTeamUiModel _brightonTeam =
      LeagueDetailsFixtureTeamUiModel(
        teamName: 'Brighton & Hove Albion',
        shortName: 'BHA',
        badgeColor: Color(0xFF2572C9),
      );
  static const LeagueDetailsFixtureTeamUiModel _evertonTeam =
      LeagueDetailsFixtureTeamUiModel(
        teamName: 'Everton',
        shortName: 'EVE',
        badgeColor: Color(0xFF284C94),
      );
  static const LeagueDetailsFixtureTeamUiModel _bournemouthTeam =
      LeagueDetailsFixtureTeamUiModel(
        teamName: 'AFC Bournemouth',
        shortName: 'BOU',
        badgeColor: Color(0xFF7A2323),
      );

  static const LeagueDetailsFixtureUiModel _crystalPalaceVsNewcastleUnited =
      LeagueDetailsFixtureUiModel(
        fixtureId: 'crystal-palace-newcastle-united',
        homeTeam: _crystalPalaceTeam,
        awayTeam: _newcastleUnitedTeam,
        homeScore: 2,
        awayScore: 1,
        statusLabel: 'FT',
        statusDetail: '',
      );
  static const LeagueDetailsFixtureUiModel _nottinghamForestVsAstonVilla =
      LeagueDetailsFixtureUiModel(
        fixtureId: 'nottingham-forest-aston-villa',
        homeTeam: _nottinghamForestTeam,
        awayTeam: _astonVillaTeam,
        homeScore: 1,
        awayScore: 1,
        statusLabel: 'FT',
        statusDetail: '',
      );
  static const LeagueDetailsFixtureUiModel _sunderlandVsTottenhamHotspur =
      LeagueDetailsFixtureUiModel(
        fixtureId: 'sunderland-tottenham-hotspur',
        homeTeam: _sunderlandTeam,
        awayTeam: _tottenhamHotspurTeam,
        homeScore: 1,
        awayScore: 0,
        statusLabel: 'FT',
        statusDetail: '',
      );
  static const LeagueDetailsFixtureUiModel _chelseaVsManchesterCityFinished =
      LeagueDetailsFixtureUiModel(
        fixtureId: 'chelsea-manchester-city-finished',
        homeTeam: _chelseaTeam,
        awayTeam: _manchesterCityTeam,
        homeScore: 0,
        awayScore: 3,
        statusLabel: 'FT',
        statusDetail: '',
      );
  static const LeagueDetailsFixtureUiModel _chelseaVsManchesterCityUpcoming =
      LeagueDetailsFixtureUiModel(
        fixtureId: 'chelsea-manchester-city-upcoming',
        homeTeam: _chelseaTeam,
        awayTeam: _manchesterCityTeam,
        homeScore: null,
        awayScore: null,
        statusLabel: '17:30',
        statusDetail: '',
      );
  static const LeagueDetailsFixtureUiModel _brentfordVsFulhamUpcoming =
      LeagueDetailsFixtureUiModel(
        fixtureId: 'brentford-fulham-upcoming',
        homeTeam: _brentfordTeam,
        awayTeam: _fulhamTeam,
        homeScore: null,
        awayScore: null,
        statusLabel: '17:30',
        statusDetail: '',
      );
  static const LeagueDetailsFixtureUiModel _leedsUnitedVsWolverhampton =
      LeagueDetailsFixtureUiModel(
        fixtureId: 'leeds-united-wolverhampton',
        homeTeam: _leedsUnitedTeam,
        awayTeam: _wolverhamptonTeam,
        homeScore: null,
        awayScore: null,
        statusLabel: '17:30',
        statusDetail: '',
      );
  static const LeagueDetailsFixtureUiModel _arsenalVsSunderland =
      LeagueDetailsFixtureUiModel(
        fixtureId: 'arsenal-sunderland',
        homeTeam: _arsenalTeam,
        awayTeam: _sunderlandTeam,
        homeScore: 3,
        awayScore: 0,
        statusLabel: 'FT',
        statusDetail: '',
      );
  static const LeagueDetailsFixtureUiModel _arsenalVsBrentford =
      LeagueDetailsFixtureUiModel(
        fixtureId: 'arsenal-brentford',
        homeTeam: _arsenalTeam,
        awayTeam: _brentfordTeam,
        homeScore: 1,
        awayScore: 1,
        statusLabel: 'FT',
        statusDetail: '',
      );
  static const LeagueDetailsFixtureUiModel _arsenalVsWolverhampton =
      LeagueDetailsFixtureUiModel(
        fixtureId: 'arsenal-wolverhampton',
        homeTeam: _arsenalTeam,
        awayTeam: _wolverhamptonTeam,
        homeScore: 3,
        awayScore: 2,
        statusLabel: 'FT',
        statusDetail: '',
      );
  static const LeagueDetailsFixtureUiModel _arsenalVsTottenhamHotspur =
      LeagueDetailsFixtureUiModel(
        fixtureId: 'arsenal-tottenham-hotspur',
        homeTeam: _arsenalTeam,
        awayTeam: _tottenhamHotspurTeam,
        homeScore: 4,
        awayScore: 1,
        statusLabel: 'FT',
        statusDetail: '',
      );
  static const LeagueDetailsFixtureUiModel _arsenalVsChelsea =
      LeagueDetailsFixtureUiModel(
        fixtureId: 'arsenal-chelsea',
        homeTeam: _arsenalTeam,
        awayTeam: _chelseaTeam,
        homeScore: 2,
        awayScore: 1,
        statusLabel: 'FT',
        statusDetail: '',
      );
  static const LeagueDetailsFixtureUiModel _arsenalVsBrighton =
      LeagueDetailsFixtureUiModel(
        fixtureId: 'arsenal-brighton',
        homeTeam: _arsenalTeam,
        awayTeam: _brightonTeam,
        homeScore: 1,
        awayScore: 0,
        statusLabel: 'FT',
        statusDetail: '',
      );
  static const LeagueDetailsFixtureUiModel _arsenalVsEverton =
      LeagueDetailsFixtureUiModel(
        fixtureId: 'arsenal-everton',
        homeTeam: _arsenalTeam,
        awayTeam: _evertonTeam,
        homeScore: 2,
        awayScore: 0,
        statusLabel: 'FT',
        statusDetail: '',
      );
  static const LeagueDetailsFixtureUiModel _arsenalVsBournemouth =
      LeagueDetailsFixtureUiModel(
        fixtureId: 'arsenal-bournemouth',
        homeTeam: _arsenalTeam,
        awayTeam: _bournemouthTeam,
        homeScore: 1,
        awayScore: 2,
        statusLabel: 'FT',
        statusDetail: '',
      );

  static const LeagueDetailsFixturesViewModel
  _demoFixtures = LeagueDetailsFixturesViewModel(
    mode: LeagueDetailsFixturesMode.byDate,
    selectedDateIndex: 0,
    selectedRoundLabel: 'Round 32',
    selectedTeamLabel: 'Arsenal',
    teamRangeLabel: '7 FEB - 11 APR',
    byDateSections: const <LeagueDetailsFixtureSectionUiModel>[
      LeagueDetailsFixtureSectionUiModel(
        title: 'YESTERDAY - 19 APR',
        fixtures: const <LeagueDetailsFixtureUiModel>[
          _crystalPalaceVsNewcastleUnited,
          _nottinghamForestVsAstonVilla,
          _sunderlandVsTottenhamHotspur,
          _chelseaVsManchesterCityFinished,
        ],
      ),
      LeagueDetailsFixtureSectionUiModel(
        title: 'TOMORROW',
        fixtures: const <LeagueDetailsFixtureUiModel>[
          _chelseaVsManchesterCityUpcoming,
        ],
      ),
      LeagueDetailsFixtureSectionUiModel(
        title: 'SATURDAY 18 APR',
        fixtures: const <LeagueDetailsFixtureUiModel>[
          _brentfordVsFulhamUpcoming,
          _leedsUnitedVsWolverhampton,
        ],
      ),
      LeagueDetailsFixtureSectionUiModel(
        title: 'SUNDAY 19 APR',
        fixtures: const <LeagueDetailsFixtureUiModel>[
          _chelseaVsManchesterCityUpcoming,
        ],
      ),
    ],
    byRoundSections: const <LeagueDetailsFixtureSectionUiModel>[
      LeagueDetailsFixtureSectionUiModel(
        title: 'SATURDAY 11 APR',
        fixtures: const <LeagueDetailsFixtureUiModel>[
          _crystalPalaceVsNewcastleUnited,
          _nottinghamForestVsAstonVilla,
          _sunderlandVsTottenhamHotspur,
          _chelseaVsManchesterCityFinished,
        ],
      ),
      LeagueDetailsFixtureSectionUiModel(
        title: 'YESTERDAY',
        fixtures: const <LeagueDetailsFixtureUiModel>[
          _chelseaVsManchesterCityUpcoming,
        ],
      ),
      LeagueDetailsFixtureSectionUiModel(
        title: 'TOMORROW',
        fixtures: const <LeagueDetailsFixtureUiModel>[
          _brentfordVsFulhamUpcoming,
          _leedsUnitedVsWolverhampton,
        ],
      ),
    ],
    byTeamSections: const <LeagueDetailsFixtureSectionUiModel>[
      LeagueDetailsFixtureSectionUiModel(
        title: 'SAT, 7 FEB',
        fixtures: const <LeagueDetailsFixtureUiModel>[_arsenalVsSunderland],
      ),
      LeagueDetailsFixtureSectionUiModel(
        title: 'FRI, 13 FEB',
        fixtures: const <LeagueDetailsFixtureUiModel>[_arsenalVsBrentford],
      ),
      LeagueDetailsFixtureSectionUiModel(
        title: 'THU, 19 FEB',
        fixtures: const <LeagueDetailsFixtureUiModel>[_arsenalVsWolverhampton],
      ),
      LeagueDetailsFixtureSectionUiModel(
        title: 'SUN, 22 FEB',
        fixtures: const <LeagueDetailsFixtureUiModel>[
          _arsenalVsTottenhamHotspur,
        ],
      ),
      LeagueDetailsFixtureSectionUiModel(
        title: 'SUN, 1 MAR',
        fixtures: const <LeagueDetailsFixtureUiModel>[_arsenalVsChelsea],
      ),
      LeagueDetailsFixtureSectionUiModel(
        title: 'THU, 5 MAR',
        fixtures: const <LeagueDetailsFixtureUiModel>[_arsenalVsBrighton],
      ),
      LeagueDetailsFixtureSectionUiModel(
        title: 'SAT, 14 MAR',
        fixtures: const <LeagueDetailsFixtureUiModel>[_arsenalVsEverton],
      ),
      LeagueDetailsFixtureSectionUiModel(
        title: 'SAT, 11 APR',
        fixtures: const <LeagueDetailsFixtureUiModel>[_arsenalVsBournemouth],
      ),
    ],
  );


  bool get isWorldCup {
    final id = (state.value.league?.leagueId ?? '').toLowerCase();
    return id == 'fifa-world-cup' || id == 'world-cup';
  }

  List<LeagueDetailsWorldCupGroupUiModel> get worldCupGroups {
    const letters = <String>['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L'];
    return letters
        .map((letter) => LeagueDetailsWorldCupGroupUiModel(title: 'Group $letter', rows: _buildWorldCupGroupRows(letter)))
        .toList(growable: false);
  }

  List<LeagueDetailsStandingsRowUiModel> _buildWorldCupGroupRows(String letter) {
    return <LeagueDetailsStandingsRowUiModel>[
      LeagueDetailsStandingsRowUiModel(rank: '1', teamName: 'Country', badgeSeed: letter, badgeColor: const Color(0xFF223240), played: '32', plusMinus: '+38', goalDifference: '+38', points: '70'),
      LeagueDetailsStandingsRowUiModel(rank: '2', teamName: 'Country', badgeSeed: letter, badgeColor: const Color(0xFF223240), played: '32', plusMinus: '+38', goalDifference: '+38', points: '70'),
      LeagueDetailsStandingsRowUiModel(rank: '3', teamName: 'Country', badgeSeed: letter, badgeColor: const Color(0xFF223240), played: '32', plusMinus: '+38', goalDifference: '+38', points: '70'),
    ];
  }

  List<LeagueDetailsKnockoutMatchUiModel> get worldCupTopOpeningMatches => const <LeagueDetailsKnockoutMatchUiModel>[
    LeagueDetailsKnockoutMatchUiModel(homeSeed: 'ASM', awaySeed: 'PSG', homeLabel: 'ASM', awayLabel: 'PSG', dateLabel: '12 JUN'),
    LeagueDetailsKnockoutMatchUiModel(homeSeed: 'GAL', awaySeed: 'JUV', homeLabel: 'GAL', awayLabel: 'JUV', dateLabel: '12 JUN'),
    LeagueDetailsKnockoutMatchUiModel(homeSeed: 'BEN', awaySeed: 'RMA', homeLabel: 'BEN', awayLabel: 'RMA', dateLabel: '12 JUN'),
    LeagueDetailsKnockoutMatchUiModel(homeSeed: 'BVB', awaySeed: 'ATA', homeLabel: 'BVB', awayLabel: 'ATA', dateLabel: '12 JUN'),
    LeagueDetailsKnockoutMatchUiModel(homeSeed: 'PSG', awaySeed: 'CHE', homeLabel: 'PSG', awayLabel: 'CHE', dateLabel: '12 JUN'),
    LeagueDetailsKnockoutMatchUiModel(homeSeed: 'GAL', awaySeed: 'LIV', homeLabel: 'GAL', awayLabel: 'LIV', dateLabel: '12 JUN'),
    LeagueDetailsKnockoutMatchUiModel(homeSeed: 'RMA', awaySeed: 'MCI', homeLabel: 'RMA', awayLabel: 'MCI', dateLabel: '12 JUN'),
    LeagueDetailsKnockoutMatchUiModel(homeSeed: 'ATA', awaySeed: 'FCB', homeLabel: 'ATA', awayLabel: 'FCB', dateLabel: '12 JUN'),
  ];

  List<LeagueDetailsKnockoutMatchUiModel> get worldCupTopQuarterMatches => const <LeagueDetailsKnockoutMatchUiModel>[
    LeagueDetailsKnockoutMatchUiModel(homeSeed: 'PSG', awaySeed: 'LIV', homeLabel: 'PSG', awayLabel: 'LIV', dateLabel: '12 JUN'),
    LeagueDetailsKnockoutMatchUiModel(homeSeed: 'RMA', awaySeed: 'FCB', homeLabel: 'RMA', awayLabel: 'FCB', dateLabel: '12 JUN'),
  ];

  LeagueDetailsKnockoutMatchUiModel get worldCupTopSemiMatch => const LeagueDetailsKnockoutMatchUiModel(homeSeed: 'TBD', awaySeed: 'TBD', homeLabel: 'TBD', awayLabel: 'TBD', dateLabel: '12 JUN');
  LeagueDetailsKnockoutMatchUiModel get worldCupFinalMatch => const LeagueDetailsKnockoutMatchUiModel(homeSeed: 'TBD', awaySeed: 'TBD', homeLabel: 'TBD', awayLabel: 'TBD', dateLabel: '12 JUN', isHighlighted: true, showChampionMark: true);
  LeagueDetailsKnockoutMatchUiModel get worldCupBottomSemiMatch => const LeagueDetailsKnockoutMatchUiModel(homeSeed: 'TBD', awaySeed: 'TBD', homeLabel: 'TBD', awayLabel: 'TBD', dateLabel: '12 JUN');

  List<LeagueDetailsKnockoutMatchUiModel> get worldCupBottomQuarterMatches => const <LeagueDetailsKnockoutMatchUiModel>[
    LeagueDetailsKnockoutMatchUiModel(homeSeed: 'SCP', awaySeed: 'ARS', homeLabel: 'SCP', awayLabel: 'ARS', dateLabel: '12 JUN'),
    LeagueDetailsKnockoutMatchUiModel(homeSeed: 'SCP', awaySeed: 'ARS', homeLabel: 'SCP', awayLabel: 'ARS', dateLabel: '12 JUN'),
  ];

  List<LeagueDetailsKnockoutMatchUiModel> get worldCupBottomOpeningMatches => const <LeagueDetailsKnockoutMatchUiModel>[
    LeagueDetailsKnockoutMatchUiModel(homeSeed: 'NEW', awaySeed: 'BAR', homeLabel: 'NEW', awayLabel: 'BAR', dateLabel: '12 JUN'),
    LeagueDetailsKnockoutMatchUiModel(homeSeed: 'ATM', awaySeed: 'TOT', homeLabel: 'ATM', awayLabel: 'TOT', dateLabel: '12 JUN'),
    LeagueDetailsKnockoutMatchUiModel(homeSeed: 'BOD', awaySeed: 'SCP', homeLabel: 'BOD', awayLabel: 'SCP', dateLabel: '12 JUN'),
    LeagueDetailsKnockoutMatchUiModel(homeSeed: 'BO4', awaySeed: 'ARS', homeLabel: 'BO4', awayLabel: 'ARS', dateLabel: '12 JUN'),
    LeagueDetailsKnockoutMatchUiModel(homeSeed: 'QRB', awaySeed: 'NEW', homeLabel: 'QRB', awayLabel: 'NEW', dateLabel: '12 JUN'),
    LeagueDetailsKnockoutMatchUiModel(homeSeed: 'CLB', awaySeed: 'ATM', homeLabel: 'CLB', awayLabel: 'ATM', dateLabel: '12 JUN'),
    LeagueDetailsKnockoutMatchUiModel(homeSeed: 'BOD', awaySeed: 'INT', homeLabel: 'BOD', awayLabel: 'INT', dateLabel: '12 JUN'),
    LeagueDetailsKnockoutMatchUiModel(homeSeed: 'OLY', awaySeed: 'BO4', homeLabel: 'OLY', awayLabel: 'BO4', dateLabel: '12 JUN'),
  ];

  static const String _tableTitle = 'League Table';
  static const String _tableMessage = 'Table tab placeholder';
  static const String _fixturesTitle = 'Fixtures';
  static const String _fixturesMessage = 'Fixtures tab placeholder';
  static const String _playerStatsTitle = 'Player Stats';
  static const String _playerStatsMessage = 'Player stats tab placeholder';
  static const String _teamStatsTitle = 'Team Stats';
  static const String _teamStatsMessage = 'Team stats tab placeholder';

  final LeaguesTopLeagueUiModel? initialLeague;

  LeagueDetailsController({this.initialLeague}) : _followingService = Get.find<FollowingService>();

  final FollowingService _followingService;
  Worker? _worker;

  final Rx<LeagueDetailsViewModel> state = LeagueDetailsViewModel(
    seasons: _demoSeasons,
    selectedSeason: _demoSeasons.first,
    standingsRows: _demoStandingsRows,
    fixtures: _demoFixtures,
    overview: _demoOverview,
  ).obs;

  String get tableTitle => _tableTitle;
  String get tableMessage => _tableMessage;
  String get fixturesTitle => _fixturesTitle;
  String get fixturesMessage => _fixturesMessage;
  String get playerStatsTitle => _playerStatsTitle;
  String get playerStatsMessage => _playerStatsMessage;
  String get teamStatsTitle => _teamStatsTitle;
  String get teamStatsMessage => _teamStatsMessage;

  @override
  void onInit() {
    super.onInit();

    if (initialLeague != null) {
      state.value = state.value.copyWith(league: initialLeague);
    }

    if (isWorldCup) {
      state.value = state.value.copyWith(
        seasons: _worldCupSeasons,
        selectedSeason: _worldCupSeasons.first,
      );
    }

    _syncFollowingState();
    _worker = ever<int>(_followingService.revision, (_) => _syncFollowingState());
  }

  @override
  void onClose() {
    _worker?.dispose();
    super.onClose();
  }

  void selectSeason(String season) {
    final currentState = state.value;
    if (!currentState.seasons.contains(season) ||
        currentState.selectedSeason == season) {
      return;
    }

    state.value = currentState.copyWith(selectedSeason: season);
  }

  void cycleFixturesMode() {
    final currentFixtures = state.value.fixtures;
    final nextMode = switch (currentFixtures.mode) {
      LeagueDetailsFixturesMode.byDate => LeagueDetailsFixturesMode.byRound,
      LeagueDetailsFixturesMode.byRound => LeagueDetailsFixturesMode.byTeam,
      LeagueDetailsFixturesMode.byTeam => LeagueDetailsFixturesMode.byDate,
    };

    state.value = state.value.copyWith(
      fixtures: currentFixtures.copyWith(mode: nextMode),
    );
  }

  void showPreviousFixtureDate() {
    _shiftFixtureDate(-1);
  }

  void showNextFixtureDate() {
    _shiftFixtureDate(1);
  }

  void _shiftFixtureDate(int delta) {
    final currentFixtures = state.value.fixtures;
    final sections = currentFixtures.byDateSections;
    if (sections.isEmpty) {
      return;
    }

    final nextIndex = _normalizedIndex(
      currentFixtures.selectedDateIndex + delta,
      sections.length,
    );

    state.value = state.value.copyWith(
      fixtures: currentFixtures.copyWith(selectedDateIndex: nextIndex),
    );
  }

  int _normalizedIndex(int value, int length) {
    if (length <= 0) {
      return 0;
    }

    final index = value % length;
    return index < 0 ? index + length : index;
  }

  void follow() {
    _followingService.follow(FollowEntityType.league, state.value.league?.leagueId ?? 'premier-league');
  }

  void unfollow() {
    _followingService.unfollow(FollowEntityType.league, state.value.league?.leagueId ?? 'premier-league');
  }

  void _syncFollowingState() {
    state.value = state.value.copyWith(
      isFollowing: _followingService.isFollowing(
        FollowEntityType.league,
        state.value.league?.leagueId ?? 'premier-league',
      ),
    );
  }

  static const List<LeagueDetailsPlayerStatsCategoryData>
  playerStatsCategories = <LeagueDetailsPlayerStatsCategoryData>[
    LeagueDetailsPlayerStatsCategoryData(
      title: 'Top Stats',
      availableFilters: <String>[
        'Top scorer',
        'Assists',
        'Goals + Assists',
        'Minutes played',
      ],
      cards: <LeagueDetailsPlayerStatsCardData>[
        LeagueDetailsPlayerStatsCardData(
          title: 'Top Scorers',
          filterLabel: 'Top scorer',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Top Assists',
          filterLabel: 'Assists',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Minutes Played',
          filterLabel: 'Minutes played',
        ),
      ],
    ),
    LeagueDetailsPlayerStatsCategoryData(
      title: 'Attack',
      availableFilters: <String>[
        'Big chances created',
        'Chances created',
        'Big chances missed',
        'Penalties awarded',
      ],
      cards: <LeagueDetailsPlayerStatsCardData>[
        LeagueDetailsPlayerStatsCardData(
          title: 'Big Chances Created',
          filterLabel: 'Big chances created',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Big Chances Missed',
          filterLabel: 'Big chances missed',
        ),
      ],
    ),
    LeagueDetailsPlayerStatsCategoryData(
      title: 'Defence',
      availableFilters: <String>[
        'Defense contribution',
        'Tackles',
        'Interceptions',
        'Clearances',
        'Blocks',
        'Recoveries',
        'Penalties conceded',
      ],
      cards: <LeagueDetailsPlayerStatsCardData>[
        LeagueDetailsPlayerStatsCardData(
          title: 'Defense contribution',
          filterLabel: 'Defense contribution',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Tackles',
          filterLabel: 'Tackles',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Interceptions',
          filterLabel: 'Interceptions',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Clearance',
          filterLabel: 'Clearances',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Blocks',
          filterLabel: 'Blocks',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Recoveries',
          filterLabel: 'Recoveries',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Penalties conceded',
          filterLabel: 'Penalties conceded',
        ),
      ],
    ),
    LeagueDetailsPlayerStatsCategoryData(
      title: 'Goalkeeping',
      availableFilters: <String>[
        'Goals prevented',
        'Clean sheets',
        'Save percentage',
        'Goals conceded',
      ],
      cards: <LeagueDetailsPlayerStatsCardData>[
        LeagueDetailsPlayerStatsCardData(
          title: 'Goals prevented',
          filterLabel: 'Goals prevented',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Clean sheets',
          filterLabel: 'Clean sheets',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Save percentage',
          filterLabel: 'Save percentage',
        ),
      ],
    ),
    LeagueDetailsPlayerStatsCategoryData(
      title: 'Discipline',
      availableFilters: <String>[
        'Fouls committed',
        'Yellow cards',
        'Red cards',
      ],
      cards: <LeagueDetailsPlayerStatsCardData>[
        LeagueDetailsPlayerStatsCardData(
          title: 'Fouls committed',
          filterLabel: 'Fouls committed',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Yellow cards',
          filterLabel: 'Yellow cards',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Red cards',
          filterLabel: 'Red cards',
        ),
      ],
    ),
  ];

  static List<LeagueDetailsPlayerStatsPreviewRowData> playerStatsPreviewRowsFor(
    String filterLabel,
  ) {
    return const <LeagueDetailsPlayerStatsPreviewRowData>[
      LeagueDetailsPlayerStatsPreviewRowData(
        rank: '1.',
        name: 'Erling Haaland',
        teamName: 'Manchester City',
        value: '7',
      ),
      LeagueDetailsPlayerStatsPreviewRowData(
        rank: '2.',
        name: 'Igor Thiago',
        teamName: 'Brentford',
        value: '4',
      ),
      LeagueDetailsPlayerStatsPreviewRowData(
        rank: '3.',
        name: 'Antoine Semenyo',
        teamName: 'Bournemouth',
        value: '3',
      ),
    ];
  }

  static List<LeagueDetailsPlayerStatsDetailRowData> playerStatsDetailRowsFor(
    String filterLabel,
  ) {
    final values = _playerStatsValuesFor(filterLabel);
    final subtitles = _playerStatsSubtitleValuesFor(filterLabel);

    const names = <String>[
      'Erling Haaland',
      'Igor Thiago',
      'Antoine Semenyo',
      'João Pedro',
      'Danny Welbeck',
      'Viktor Gyökeres',
      'Hugo Ekitiké',
      'Harry Wilson',
    ];

    return List<LeagueDetailsPlayerStatsDetailRowData>.generate(
      names.length,
      (index) => LeagueDetailsPlayerStatsDetailRowData(
        rank: '${index + 1}',
        name: names[index],
        value: values[index],
        subtitleValue: subtitles[index],
      ),
    );
  }

  static String playerStatsSubtitleLabelFor(String filterLabel) {
    final normalized = filterLabel.toLowerCase();

    if (normalized == 'minutes played') {
      return 'Minutes per 90';
    }

    if (normalized == 'assists') {
      return 'Big chances';
    }

    if (normalized == 'goals + assists') {
      return 'Assists';
    }

    if (normalized == 'big chances created' ||
        normalized == 'chances created') {
      return 'Chances';
    }

    if (normalized == 'big chances missed') {
      return 'Shots on target';
    }

    if (normalized == 'penalties awarded' || normalized == 'top scorer') {
      return 'Penalty goals';
    }

    if (normalized == 'tackles') {
      return 'Successful tackles';
    }

    if (normalized == 'interceptions' || normalized == 'defense contribution') {
      return 'Interceptions';
    }

    if (normalized == 'clearances') {
      return 'Aerial duels won';
    }

    if (normalized == 'blocks') {
      return 'Shot blocks';
    }

    if (normalized == 'recoveries') {
      return 'Possession won';
    }

    if (normalized == 'penalties conceded') {
      return 'Errors';
    }

    if (normalized == 'clean sheets') {
      return 'Goals conceded';
    }

    if (normalized == 'save percentage') {
      return 'Saves';
    }

    if (normalized == 'goals prevented') {
      return 'Goals conceded';
    }

    if (normalized == 'goals conceded') {
      return 'Clean sheets';
    }

    if (normalized == 'fouls committed') {
      return 'Yellow cards';
    }

    if (normalized == 'yellow cards') {
      return 'Fouls';
    }

    if (normalized == 'red cards') {
      return 'Yellow cards';
    }

    return 'Penalty goals';
  }

  static List<String> _playerStatsValuesFor(String filterLabel) {
    final normalized = filterLabel.toLowerCase();

    if (normalized == 'minutes played') {
      return const <String>[
        '3120',
        '3084',
        '3028',
        '2991',
        '2910',
        '2875',
        '2818',
        '2789',
      ];
    }

    if (normalized == 'save percentage') {
      return const <String>[
        '82%',
        '80%',
        '78%',
        '77%',
        '76%',
        '75%',
        '74%',
        '73%',
      ];
    }

    if (normalized == 'clean sheets' || normalized == 'goals prevented') {
      return const <String>['17', '16', '14', '13', '12', '11', '10', '9'];
    }

    if (normalized == 'fouls committed' ||
        normalized == 'yellow cards' ||
        normalized == 'red cards') {
      return const <String>['14', '12', '11', '10', '9', '9', '8', '7'];
    }

    if (normalized == 'assists' ||
        normalized == 'big chances created' ||
        normalized == 'chances created') {
      return const <String>['12', '11', '10', '9', '8', '8', '7', '7'];
    }

    if (normalized == 'tackles' ||
        normalized == 'interceptions' ||
        normalized == 'clearances' ||
        normalized == 'blocks' ||
        normalized == 'recoveries' ||
        normalized == 'penalties conceded' ||
        normalized == 'defense contribution') {
      return const <String>['74', '71', '69', '63', '61', '58', '54', '50'];
    }

    return const <String>['22', '21', '15', '14', '12', '12', '11', '10'];
  }

  static List<String> _playerStatsSubtitleValuesFor(String filterLabel) {
    final normalized = filterLabel.toLowerCase();

    if (normalized == 'minutes played') {
      return const <String>[
        '284',
        '276',
        '264',
        '250',
        '244',
        '239',
        '233',
        '228',
      ];
    }

    if (normalized == 'assists') {
      return const <String>['6', '5', '4', '4', '3', '3', '2', '2'];
    }

    if (normalized == 'goals + assists') {
      return const <String>['9', '8', '7', '6', '5', '5', '4', '4'];
    }

    if (normalized == 'big chances created' ||
        normalized == 'chances created') {
      return const <String>['14', '12', '11', '9', '8', '7', '6', '6'];
    }

    if (normalized == 'big chances missed') {
      return const <String>['10', '9', '8', '7', '6', '6', '5', '5'];
    }

    if (normalized == 'penalties awarded' || normalized == 'top scorer') {
      return const <String>['3', '7', '1', '0', '1', '3', '0', '0'];
    }

    if (normalized == 'tackles') {
      return const <String>['38', '35', '33', '31', '29', '28', '27', '25'];
    }

    if (normalized == 'interceptions' ||
        normalized == 'defense contribution' ||
        normalized == 'clearances' ||
        normalized == 'blocks' ||
        normalized == 'recoveries' ||
        normalized == 'penalties conceded') {
      return const <String>['11', '10', '9', '8', '8', '7', '6', '6'];
    }

    if (normalized == 'clean sheets' ||
        normalized == 'goals prevented' ||
        normalized == 'goals conceded' ||
        normalized == 'save percentage') {
      return const <String>['3', '2', '2', '2', '1', '1', '1', '1'];
    }

    if (normalized == 'fouls committed' ||
        normalized == 'yellow cards' ||
        normalized == 'red cards') {
      return const <String>['5', '4', '4', '3', '3', '2', '2', '2'];
    }

    return const <String>['3', '7', '1', '0', '1', '3', '0', '0'];
  }
}

class LeagueDetailsBinding extends Bindings {
  @override
  void dependencies() {
    final arguments = Get.arguments;
    LeaguesTopLeagueUiModel? league;

    if (arguments is LeaguesTopLeagueUiModel) {
      league = arguments;
    } else if (arguments is Map<String, dynamic>) {
      final candidate = arguments['league'];
      if (candidate is LeaguesTopLeagueUiModel) {
        league = candidate;
      }
    }

    if (!Get.isRegistered<FollowingService>()) {
      Get.lazyPut<FollowingService>(() => FollowingService(), fenix: true);
    }

    Get.lazyPut<LeagueDetailsController>(
      () => LeagueDetailsController(initialLeague: league),
    );
  }
}

class LeagueDetailsPlayerStatsCategoryData {
  final String title;
  final List<String> availableFilters;
  final List<LeagueDetailsPlayerStatsCardData> cards;

  const LeagueDetailsPlayerStatsCategoryData({
    required this.title,
    required this.availableFilters,
    required this.cards,
  });
}

class LeagueDetailsPlayerStatsCardData {
  final String title;
  final String filterLabel;

  const LeagueDetailsPlayerStatsCardData({
    required this.title,
    required this.filterLabel,
  });
}

class LeagueDetailsPlayerStatsPreviewRowData {
  final String rank;
  final String name;
  final String teamName;
  final String value;

  const LeagueDetailsPlayerStatsPreviewRowData({
    required this.rank,
    required this.name,
    required this.teamName,
    required this.value,
  });
}

class LeagueDetailsPlayerStatsDetailRowData {
  final String rank;
  final String name;
  final String value;
  final String subtitleValue;

  const LeagueDetailsPlayerStatsDetailRowData({
    required this.rank,
    required this.name,
    required this.value,
    required this.subtitleValue,
  });
}
