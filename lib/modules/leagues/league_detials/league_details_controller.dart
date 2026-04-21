import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../leagues_models.dart';
import 'league_detials_model.dart';

class LeagueDetailsController extends GetxController {
  static const List<String> _demoSeasons = <String>[
    '2025/2026',
    '2024/2025',
    '2023/2024',
  ];

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

  static const String _tableTitle = 'League Table';
  static const String _tableMessage = 'Table tab placeholder';
  static const String _fixturesTitle = 'Fixtures';
  static const String _fixturesMessage = 'Fixtures tab placeholder';
  static const String _playerStatsTitle = 'Player Stats';
  static const String _playerStatsMessage = 'Player stats tab placeholder';
  static const String _teamStatsTitle = 'Team Stats';
  static const String _teamStatsMessage = 'Team stats tab placeholder';

  final LeaguesTopLeagueUiModel? initialLeague;

  LeagueDetailsController({this.initialLeague});

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

  void toggleFollowing() {
    state.value = state.value.copyWith(isFollowing: !state.value.isFollowing);
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

    Get.lazyPut<LeagueDetailsController>(
      () => LeagueDetailsController(initialLeague: league),
    );
  }
}
