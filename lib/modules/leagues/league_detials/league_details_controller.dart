import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/models/following_models.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/api_error_handler.dart';
import '../../../core/services/following_service.dart';
import '../../../core/services/storage_service.dart';
import '../model/leagues_models.dart';
import 'models/league_detials_model.dart';
import 'league_details_service.dart';

class LeagueDetailsController extends GetxController {
  static const List<String> _demoSeasons = <String>[
    '2025/2026',
    '2024/2025',
    '2023/2024',
  ];

  static const List<String> _worldCupSeasons = <String>['2022', '2026', '2018'];

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
    return (state.value.league?.leagueId ?? '').trim() == '1';
  }

  List<LeagueDetailsWorldCupGroupUiModel> get worldCupGroups {
    return state.value.worldCupGroups;
  }

  List<LeagueDetailsWorldCupGroupUiModel> mergeWorldCupGroups(
    List<LeagueDetailsWorldCupGroupUiModel> existing,
    List<LeagueDetailsWorldCupGroupUiModel> incoming,
  ) {
    final merged = <LeagueDetailsWorldCupGroupUiModel>[...existing];
    for (final incomingGroup in incoming) {
      final index = merged.indexWhere((group) => group.title == incomingGroup.title);
      if (index == -1) {
        merged.add(incomingGroup);
        continue;
      }
      final current = merged[index];
      merged[index] = LeagueDetailsWorldCupGroupUiModel(
        title: current.title,
        rows: <LeagueDetailsStandingsRowUiModel>[
          ...current.rows,
          ...incomingGroup.rows,
        ],
      );
    }
    return merged;
  }

  List<LeagueDetailsKnockoutMatchUiModel> get worldCupTopOpeningMatches {
    final matches = state.value.knockoutRoundOf16;
    if (matches.isEmpty) {
      return _knockoutPlaceholders(4);
    }
    return matches.take(4).toList(growable: false);
  }

  List<LeagueDetailsKnockoutMatchUiModel> get worldCupTopQuarterMatches {
    final matches = state.value.knockoutQuarterFinals;
    if (matches.isEmpty) {
      return _knockoutPlaceholders(2);
    }
    return matches.take(2).toList(growable: false);
  }

  LeagueDetailsKnockoutMatchUiModel get worldCupTopSemiMatch {
    final matches = state.value.knockoutSemiFinals;
    return matches.isEmpty ? _knockoutPlaceholder() : matches.first;
  }

  LeagueDetailsKnockoutMatchUiModel get worldCupFinalMatch {
    final matches = state.value.knockoutFinals;
    final match = matches.isEmpty ? _knockoutPlaceholder() : matches.first;
    return LeagueDetailsKnockoutMatchUiModel(
      homeSeed: match.homeSeed,
      awaySeed: match.awaySeed,
      homeLabel: match.homeLabel,
      awayLabel: match.awayLabel,
      homeLogoUrl: match.homeLogoUrl,
      awayLogoUrl: match.awayLogoUrl,
      dateLabel: match.dateLabel,
      isHighlighted: true,
      showChampionMark: true,
      isFinished: match.isFinished,
      homeWinner: match.homeWinner,
      awayWinner: match.awayWinner,
    );
  }

  LeagueDetailsKnockoutMatchUiModel get worldCupBottomSemiMatch {
    final matches = state.value.knockoutSemiFinals;
    return matches.length < 2 ? _knockoutPlaceholder() : matches[1];
  }

  List<LeagueDetailsKnockoutMatchUiModel> get worldCupBottomQuarterMatches {
    final matches = state.value.knockoutQuarterFinals;
    if (matches.length <= 2) {
      return _knockoutPlaceholders(2);
    }
    return matches.skip(2).take(2).toList(growable: false);
  }

  List<LeagueDetailsKnockoutMatchUiModel> get worldCupBottomOpeningMatches {
    final matches = state.value.knockoutRoundOf16;
    if (matches.length <= 4) {
      return _knockoutPlaceholders(4);
    }
    return matches.skip(4).take(4).toList(growable: false);
  }

  LeagueDetailsKnockoutMatchUiModel _knockoutPlaceholder() {
    return const LeagueDetailsKnockoutMatchUiModel(
      homeSeed: 'TBD',
      awaySeed: 'TBD',
      homeLabel: 'TBD',
      awayLabel: 'TBD',
      dateLabel: 'TBD',
    );
  }

  List<LeagueDetailsKnockoutMatchUiModel> _knockoutPlaceholders(int count) {
    return List<LeagueDetailsKnockoutMatchUiModel>.filled(
      count,
      _knockoutPlaceholder(),
      growable: false,
    );
  }

  static const String _tableTitle = 'League Table';
  static const String _tableMessage = 'Table tab placeholder';
  static const String _fixturesTitle = 'Fixtures';
  static const String _fixturesMessage = 'Fixtures tab placeholder';
  static const String _playerStatsTitle = 'Player Stats';
  static const String _playerStatsMessage = 'Player stats tab placeholder';
  static const String _teamStatsTitle = 'Team Stats';
  static const String _teamStatsMessage = 'Team stats tab placeholder';

  final LeaguesTopLeagueUiModel? initialLeague;
  final LeagueDetailsService _service;

  LeagueDetailsController({
    this.initialLeague,
    required LeagueDetailsService service,
  }) : _service = service,
       _followingService = Get.find<FollowingService>();

  final FollowingService _followingService;
  Worker? _worker;
  int _activeTabIndex = 0;
  final Map<String, int> _playerStatsCategoryPages = <String, int>{};
  final Set<String> _playerStatsCategoryHasMore = <String>{};
  bool _isLoadingMorePlayerStats = false;
  final Map<String, int> _teamStatsCategoryPages = <String, int>{};
  final Set<String> _teamStatsCategoryHasMore = <String>{};
  bool _isLoadingMoreTeamStats = false;
  bool _hasUserSelectedSeason = false;

  final Rx<LeagueDetailsViewModel> state = LeagueDetailsViewModel(
    seasons: _demoSeasons,
    selectedSeason: _demoSeasons.first,
    isLoading: true,
    standingsRows: _demoStandingsRows,
    fixtures: _demoFixtures,
    overview: _demoOverview,
    topScorersRows: _demoOverview.topScorers,
    topAssistsRows: _demoOverview.topAssists,
  ).obs;

  String get tableTitle => _tableTitle;
  String get tableMessage => _tableMessage;
  String get fixturesTitle => _fixturesTitle;
  String get fixturesMessage => _fixturesMessage;
  String get playerStatsTitle => _playerStatsTitle;
  String get playerStatsMessage => _playerStatsMessage;
  String get teamStatsTitle => _teamStatsTitle;
  String get teamStatsMessage => _teamStatsMessage;
  bool get isPlayerStatsTabActive => !isWorldCup && _activeTabIndex == 3;
  bool get isTeamStatsTabActive => !isWorldCup && _activeTabIndex == 4;

  @override
  void onInit() {
    super.onInit();

    if (initialLeague != null) {
      state.value = state.value.copyWith(league: initialLeague);
    }


    _syncFollowingState();
    _loadLeagueDetails();
    _worker = ever<int>(
      _followingService.revision,
      (_) => _syncFollowingState(),
    );
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

    _hasUserSelectedSeason = true;

    state.value = currentState.copyWith(
      selectedSeason: season,
      playerStatsSections: const <LeagueDetailsPlayerStatSectionUiModel>[],
      hasLoadedPlayerStats: false,
      teamStatsSections: const <LeagueDetailsPlayerStatSectionUiModel>[],
      hasLoadedTeamStats: false,
      worldCupGroups: const <LeagueDetailsWorldCupGroupUiModel>[],
      standingsPage: 1,
      standingsTotalPages: 1,
      isStandingsLoadingMore: false,
      isFixturesLoadingMore: false,
      knockoutRoundOf16: const <LeagueDetailsKnockoutMatchUiModel>[],
      knockoutQuarterFinals: const <LeagueDetailsKnockoutMatchUiModel>[],
      knockoutSemiFinals: const <LeagueDetailsKnockoutMatchUiModel>[],
      knockoutFinals: const <LeagueDetailsKnockoutMatchUiModel>[],
      hasLoadedKnockout: false,
      isKnockoutLoading: false,
      fixtures: const LeagueDetailsFixturesViewModel(),
    );
    _resetStatsPagination();
    _loadLeagueDetails().then((_) {
      if (isWorldCup && _activeTabIndex == 1) {
        ensureKnockoutLoaded(force: true);
      } else if (isWorldCup && _activeTabIndex == 3) {
        ensureSeasonHistoryLoaded(force: true);
      } else if (!isWorldCup && _activeTabIndex == 3) {
        ensurePlayerStatsLoaded(force: true);
      } else if (!isWorldCup && _activeTabIndex == 4) {
        ensureTeamStatsLoaded(force: true);
      }
    });
  }

  Future<void> reload() async {
    state.value = state.value.copyWith(
      playerStatsSections: const <LeagueDetailsPlayerStatSectionUiModel>[],
      hasLoadedPlayerStats: false,
      teamStatsSections: const <LeagueDetailsPlayerStatSectionUiModel>[],
      hasLoadedTeamStats: false,
      worldCupGroups: const <LeagueDetailsWorldCupGroupUiModel>[],
      standingsPage: 1,
      standingsTotalPages: 1,
      isStandingsLoadingMore: false,
      isFixturesLoadingMore: false,
      knockoutRoundOf16: const <LeagueDetailsKnockoutMatchUiModel>[],
      knockoutQuarterFinals: const <LeagueDetailsKnockoutMatchUiModel>[],
      knockoutSemiFinals: const <LeagueDetailsKnockoutMatchUiModel>[],
      knockoutFinals: const <LeagueDetailsKnockoutMatchUiModel>[],
      hasLoadedKnockout: false,
      isKnockoutLoading: false,
    );
    _resetStatsPagination();
    await _loadLeagueDetails();
    if (isWorldCup && _activeTabIndex == 3) {
      await ensureSeasonHistoryLoaded(force: true);
    } else if (!isWorldCup && _activeTabIndex == 3) {
      await ensurePlayerStatsLoaded(force: true);
    } else if (!isWorldCup && _activeTabIndex == 4) {
      await ensureTeamStatsLoaded(force: true);
    }
  }

  Future<void> refreshCurrentTab() async {
    if (isWorldCup && _activeTabIndex == 1) {
      await ensureKnockoutLoaded(force: true);
      return;
    }
    if (isWorldCup && _activeTabIndex == 3) {
      await ensureSeasonHistoryLoaded(force: true);
      return;
    }
    if (!isWorldCup && _activeTabIndex == 3) {
      await ensurePlayerStatsLoaded(force: true);
      return;
    }
    if (!isWorldCup && _activeTabIndex == 4) {
      await ensureTeamStatsLoaded(force: true);
      return;
    }
    await reload();
  }

  Future<bool> loadMoreWorldCupStandings() async {
    final current = state.value;
    if (!isWorldCup ||
        current.isLoading ||
        current.isStandingsLoadingMore ||
        current.standingsPage >= current.standingsTotalPages) {
      return false;
    }

    final league = current.league ?? initialLeague;
    final leagueId = int.tryParse(league?.leagueId ?? '');
    if (leagueId == null) {
      return false;
    }

    final seasonYear = _selectedSeasonYear(current.selectedSeason, league?.season);
    final nextPage = current.standingsPage + 1;
    state.value = current.copyWith(isStandingsLoadingMore: true);

    final response = await ApiErrorHandler.handle<LeagueDetailsStandingsDataModel>(
      () => _service.fetchStandingsData(
        leagueId: leagueId,
        season: seasonYear,
        page: nextPage,
        limit: 20,
      ),
      fallbackErrorCode: 'world_cup_standings_more_fetch_failed',
      userMessage: 'Unable to load more standings right now.',
      showUserError: false,
    );

    if (isClosed) {
      return false;
    }

    if (!response.success || response.data == null) {
      state.value = state.value.copyWith(isStandingsLoadingMore: false);
      return false;
    }

    final data = response.data!;
    state.value = state.value.copyWith(
      isStandingsLoadingMore: false,
      standingsRows: <LeagueDetailsStandingsRowUiModel>[
        ...state.value.standingsRows,
        ...data.rows,
      ],
      worldCupGroups: mergeWorldCupGroups(state.value.worldCupGroups, data.worldCupGroups),
      standingsPage: data.page,
      standingsTotalPages: data.totalPages,
    );
    return data.rows.isNotEmpty || data.worldCupGroups.isNotEmpty;
  }

  void onLeagueDetailsTabChanged(int index) {
    _activeTabIndex = index;
    if (isWorldCup && index == 1) {
      ensureKnockoutLoaded();
    } else if (isWorldCup && index == 3) {
      ensureSeasonHistoryLoaded();
    } else if (!isWorldCup && index == 3) {
      ensurePlayerStatsLoaded();
    } else if (!isWorldCup && index == 4) {
      ensureTeamStatsLoaded();
    }
  }

  void _resetStatsPagination() {
    _playerStatsCategoryPages.clear();
    _playerStatsCategoryHasMore.clear();
    _teamStatsCategoryPages.clear();
    _teamStatsCategoryHasMore.clear();
  }

  Future<void> ensureSeasonHistoryLoaded({bool force = false}) async {
    final current = state.value;
    if (!isWorldCup ||
        (!force &&
            (current.hasLoadedSeasonHistory ||
                current.isSeasonHistoryLoading))) {
      return;
    }

    final league = current.league ?? initialLeague;
    final leagueId = int.tryParse(league?.leagueId ?? '');
    if (leagueId == null) {
      return;
    }

    state.value = current.copyWith(isSeasonHistoryLoading: true);

    final response =
        await ApiErrorHandler.handle<List<LeagueDetailsSeasonHistoryUiModel>>(
      () => _service.fetchWorldCupSeasonHistory(leagueId: leagueId),
      fallbackErrorCode: 'world_cup_season_history_fetch_failed',
      userMessage: 'Unable to load season history right now.',
      showUserError: false,
    );

    if (isClosed) {
      return;
    }

    state.value = state.value.copyWith(
      isSeasonHistoryLoading: false,
      hasLoadedSeasonHistory: true,
      seasonHistory: response.success && response.data != null
          ? response.data!
          : const <LeagueDetailsSeasonHistoryUiModel>[],
    );
  }

  Future<void> ensureKnockoutLoaded({bool force = false}) async {
    final current = state.value;
    if (!isWorldCup || (!force && (current.hasLoadedKnockout || current.isKnockoutLoading))) {
      return;
    }

    final league = current.league ?? initialLeague;
    final leagueId = int.tryParse(league?.leagueId ?? '');
    if (leagueId == null) {
      return;
    }

    final seasonYear = _selectedSeasonYear(current.selectedSeason, league?.season);
    state.value = current.copyWith(isKnockoutLoading: true);

    final response = await ApiErrorHandler.handle<LeagueDetailsKnockoutBracketDataModel>(
      () => _service.fetchKnockoutBracket(
        fixtureId: leagueId,
        leagueId: leagueId,
        season: seasonYear,
      ),
      fallbackErrorCode: 'league_knockout_fetch_failed',
      userMessage: 'Unable to load knockout bracket right now.',
      showUserError: false,
    );

    if (isClosed) {
      return;
    }

    final data = response.success && response.data != null
        ? response.data!
        : const LeagueDetailsKnockoutBracketDataModel();

    state.value = state.value.copyWith(
      isKnockoutLoading: false,
      hasLoadedKnockout: true,
      knockoutRoundOf16: data.roundOf16,
      knockoutQuarterFinals: data.quarterFinals,
      knockoutSemiFinals: data.semiFinals,
      knockoutFinals: data.finals,
    );
  }

  Future<void> ensurePlayerStatsLoaded({bool force = false}) async {
    final current = state.value;
    if (!force &&
        (current.hasLoadedPlayerStats || current.isPlayerStatsLoading)) {
      return;
    }

    final league = current.league ?? initialLeague;
    final leagueId = int.tryParse(league?.leagueId ?? '');
    if (leagueId == null) {
      return;
    }
    final seasonYear = _selectedSeasonYear(
      current.selectedSeason,
      league?.season,
    );

    state.value = current.copyWith(isPlayerStatsLoading: true);

    final response =
        await ApiErrorHandler.handle<
          List<LeagueDetailsPlayerStatSectionUiModel>
        >(
          () async {
            final results =
                await Future.wait<List<LeagueDetailsPlayerStatSectionUiModel>>(
                  const <String>[
                    'minutes',
                    'attack',
                    'defense',
                    'goalkeeping',
                    'discipline',
                  ].map(
                    (category) => _service.fetchPlayerStatsCategory(
                      leagueId: leagueId,
                      season: seasonYear,
                      category: category,
                      page: 1,
                      limit: 10,
                    ),
                  ),
                );
            return results.expand((item) => item).toList(growable: false);
          },
          fallbackErrorCode: 'league_player_stats_fetch_failed',
          userMessage: 'Unable to load player stats right now.',
          showUserError: false,
        );

    if (isClosed) {
      return;
    }

    final sections = response.success && response.data != null
        ? response.data!
        : const <LeagueDetailsPlayerStatSectionUiModel>[];
    _playerStatsCategoryPages
      ..clear()
      ..addEntries(
        const <String>[
          'minutes',
          'attack',
          'defense',
          'goalkeeping',
          'discipline',
        ].map((category) => MapEntry<String, int>(category, 1)),
      );
    _playerStatsCategoryHasMore
      ..clear()
      ..addAll(const <String>[
        'minutes',
        'attack',
        'defense',
        'goalkeeping',
        'discipline',
      ]);

    state.value = state.value.copyWith(
      isPlayerStatsLoading: false,
      hasLoadedPlayerStats: true,
      playerStatsSections: sections,
    );
  }

  Future<void> ensureTeamStatsLoaded({bool force = false}) async {
    final current = state.value;
    if (!force && (current.hasLoadedTeamStats || current.isTeamStatsLoading)) {
      return;
    }

    final league = current.league ?? initialLeague;
    final leagueId = int.tryParse(league?.leagueId ?? '');
    if (leagueId == null) {
      return;
    }
    final seasonYear = _selectedSeasonYear(
      current.selectedSeason,
      league?.season,
    );

    state.value = current.copyWith(isTeamStatsLoading: true);

    final response =
        await ApiErrorHandler.handle<
          List<LeagueDetailsPlayerStatSectionUiModel>
        >(
          () async {
            final results =
                await Future.wait<List<LeagueDetailsPlayerStatSectionUiModel>>(
                  const <String>[
                    'topStats',
                    'attack',
                    'defense',
                    'discipline',
                  ].map(
                    (category) => _service.fetchTeamStatsCategory(
                      leagueId: leagueId,
                      season: seasonYear,
                      category: category,
                      page: 1,
                      limit: 10,
                    ),
                  ),
                );
            return results.expand((item) => item).toList(growable: false);
          },
          fallbackErrorCode: 'league_team_stats_fetch_failed',
          userMessage: 'Unable to load team stats right now.',
          showUserError: false,
        );

    if (isClosed) {
      return;
    }

    final sections = response.success && response.data != null
        ? response.data!
        : const <LeagueDetailsPlayerStatSectionUiModel>[];
    _teamStatsCategoryPages
      ..clear()
      ..addEntries(
        const <String>[
          'topStats',
          'attack',
          'defense',
          'discipline',
        ].map((category) => MapEntry<String, int>(category, 1)),
      );
    _teamStatsCategoryHasMore
      ..clear()
      ..addAll(const <String>['topStats', 'attack', 'defense', 'discipline']);

    state.value = state.value.copyWith(
      isTeamStatsLoading: false,
      hasLoadedTeamStats: true,
      teamStatsSections: sections,
    );
  }

  Future<bool> loadMorePlayerStatsForFilter(String filterLabel) async {
    if (_isLoadingMorePlayerStats) {
      return false;
    }

    final category = _playerStatsCategoryForFilter(filterLabel);
    if (category.isEmpty || !_playerStatsCategoryHasMore.contains(category)) {
      return false;
    }

    final league = state.value.league ?? initialLeague;
    final leagueId = int.tryParse(league?.leagueId ?? '');
    if (leagueId == null) {
      return false;
    }
    final seasonYear = _selectedSeasonYear(
      state.value.selectedSeason,
      league?.season,
    );
    final nextPage = (_playerStatsCategoryPages[category] ?? 1) + 1;

    _isLoadingMorePlayerStats = true;
    final response =
        await ApiErrorHandler.handle<
          List<LeagueDetailsPlayerStatSectionUiModel>
        >(
          () => _service.fetchPlayerStatsCategory(
            leagueId: leagueId,
            season: seasonYear,
            category: category,
            page: nextPage,
            limit: 10,
          ),
          fallbackErrorCode: 'league_player_stats_more_fetch_failed',
          userMessage: 'Unable to load more player stats right now.',
          showUserError: false,
        );
    _isLoadingMorePlayerStats = false;

    if (isClosed || !response.success || response.data == null) {
      return false;
    }

    final incoming = response.data!;
    if (_sectionsHaveNoRows(incoming)) {
      _playerStatsCategoryHasMore.remove(category);
      return false;
    }

    _playerStatsCategoryPages[category] = nextPage;
    state.value = state.value.copyWith(
      playerStatsSections: _mergeStatSections(
        state.value.playerStatsSections,
        incoming,
      ),
    );
    return true;
  }

  Future<bool> loadMoreTeamStatsForFilter(String filterLabel) async {
    if (_isLoadingMoreTeamStats) {
      return false;
    }

    final category = _teamStatsCategoryForFilter(filterLabel);
    if (category.isEmpty || !_teamStatsCategoryHasMore.contains(category)) {
      return false;
    }

    final league = state.value.league ?? initialLeague;
    final leagueId = int.tryParse(league?.leagueId ?? '');
    if (leagueId == null) {
      return false;
    }
    final seasonYear = _selectedSeasonYear(
      state.value.selectedSeason,
      league?.season,
    );
    final nextPage = (_teamStatsCategoryPages[category] ?? 1) + 1;

    _isLoadingMoreTeamStats = true;
    final response =
        await ApiErrorHandler.handle<
          List<LeagueDetailsPlayerStatSectionUiModel>
        >(
          () => _service.fetchTeamStatsCategory(
            leagueId: leagueId,
            season: seasonYear,
            category: category,
            page: nextPage,
            limit: 10,
          ),
          fallbackErrorCode: 'league_team_stats_more_fetch_failed',
          userMessage: 'Unable to load more team stats right now.',
          showUserError: false,
        );
    _isLoadingMoreTeamStats = false;

    if (isClosed || !response.success || response.data == null) {
      return false;
    }

    final incoming = response.data!;
    if (_sectionsHaveNoRows(incoming)) {
      _teamStatsCategoryHasMore.remove(category);
      return false;
    }

    _teamStatsCategoryPages[category] = nextPage;
    state.value = state.value.copyWith(
      teamStatsSections: _mergeStatSections(
        state.value.teamStatsSections,
        incoming,
      ),
    );
    return true;
  }

  bool _sectionsHaveNoRows(
    List<LeagueDetailsPlayerStatSectionUiModel> sections,
  ) {
    return sections.every((section) => section.rows.isEmpty);
  }

  List<LeagueDetailsPlayerStatSectionUiModel> _mergeStatSections(
    List<LeagueDetailsPlayerStatSectionUiModel> existing,
    List<LeagueDetailsPlayerStatSectionUiModel> incoming,
  ) {
    final merged = <LeagueDetailsPlayerStatSectionUiModel>[...existing];
    for (final incomingSection in incoming) {
      final index = merged.indexWhere(
        (section) =>
            _normalizePlayerStatLabel(section.key) ==
                _normalizePlayerStatLabel(incomingSection.key) &&
            section.category == incomingSection.category,
      );
      if (index == -1) {
        merged.add(incomingSection);
        continue;
      }

      final currentSection = merged[index];
      merged[index] = LeagueDetailsPlayerStatSectionUiModel(
        category: currentSection.category,
        key: currentSection.key,
        title: currentSection.title,
        rows: <LeagueDetailsPlayerStatRowUiModel>[
          ...currentSection.rows,
          ...incomingSection.rows,
        ],
      );
    }
    return merged;
  }

  String _playerStatsCategoryForFilter(String filterLabel) {
    final normalized = _normalizePlayerStatLabel(filterLabel);
    for (final section in state.value.playerStatsSections) {
      if (_normalizePlayerStatLabel(section.title) == normalized ||
          _normalizePlayerStatLabel(section.key) == normalized) {
        return section.category;
      }
    }
    return '';
  }

  String _teamStatsCategoryForFilter(String filterLabel) {
    final normalized = _normalizePlayerStatLabel(filterLabel);
    for (final section in state.value.teamStatsSections) {
      if (_normalizePlayerStatLabel(section.title) == normalized ||
          _normalizePlayerStatLabel(section.key) == normalized) {
        return section.category;
      }
    }

    if (_topStatsLabels.map(_normalizePlayerStatLabel).contains(normalized)) {
      return 'topStats';
    }
    if (_attackTeamLabels.map(_normalizePlayerStatLabel).contains(normalized)) {
      return 'attack';
    }
    if (_defenseTeamLabels
        .map(_normalizePlayerStatLabel)
        .contains(normalized)) {
      return 'defense';
    }
    if (_disciplineTeamLabels
        .map(_normalizePlayerStatLabel)
        .contains(normalized)) {
      return 'discipline';
    }
    return '';
  }

  int _selectedSeasonYear(String selectedSeason, int? fallbackSeason) {
    final match = RegExp(r'\d{4}').firstMatch(selectedSeason);
    if (match != null) {
      return int.tryParse(match.group(0)!) ??
          fallbackSeason ??
          DateTime.now().year;
    }
    return fallbackSeason ?? DateTime.now().year;
  }

  Future<void> _loadLeagueDetails() async {
    final league = state.value.league ?? initialLeague;
    if (league == null) {
      state.value = state.value.copyWith(
        isLoading: false,
        errorCode: 'missing_league',
      );
      return;
    }

    state.value = state.value.copyWith(isLoading: true, errorCode: null);

    final response = await ApiErrorHandler.handle<LeagueDetailsRemoteDataModel>(
      () => _service.fetchLeagueDetails(
        league: league,
        season: !_hasUserSelectedSeason || state.value.selectedSeason.isEmpty
            ? ''
            : state.value.selectedSeason,
      ),
      fallbackErrorCode: 'league_details_fetch_failed',
      userMessage: 'Unable to load league details right now.',
    );

    if (isClosed) {
      return;
    }

    if (!response.success || response.data == null) {
      state.value = state.value.copyWith(
        isLoading: false,
        errorCode: response.errorCode,
      );
      return;
    }

    final data = response.data!;
    final resolvedLeague = data.league ?? league;
    final currentSeasonYearMatch = RegExp(
      r'\d{4}',
    ).firstMatch(state.value.selectedSeason);
    final currentSeasonYear = currentSeasonYearMatch == null
        ? null
        : currentSeasonYearMatch.group(0);
    final nextSelectedSeason = data.seasons.contains(data.selectedSeason)
        ? data.selectedSeason
        : (data.seasons.contains(state.value.selectedSeason)
              ? state.value.selectedSeason
              : (currentSeasonYear != null &&
                        data.seasons.contains(currentSeasonYear)
                    ? currentSeasonYear
                    : (resolvedLeague.season != null &&
                              data.seasons.contains('${resolvedLeague.season}')
                          ? '${resolvedLeague.season}'
                          : (data.seasons.isNotEmpty
                                ? data.seasons.first
                                : state.value.selectedSeason))));

    state.value = state.value.copyWith(
      league: resolvedLeague,
      isLoading: false,
      isFollowing: data.isFollowing,
      seasons: data.seasons.isEmpty ? state.value.seasons : data.seasons,
      selectedSeason: nextSelectedSeason,
      standingsRows: data.standingsRows,
      worldCupGroups: data.worldCupGroups,
      standingsPage: data.standingsPage,
      standingsTotalPages: data.standingsTotalPages,
      isStandingsLoadingMore: false,
      fixtures: data.fixtures,
      overview: LeagueDetailsOverviewUiModel(
        topThreeRows: data.standingsRows.take(3).toList(growable: false),
        topScorers: data.topScorers.take(3).toList(growable: false),
        topAssists: data.topAssists.take(3).toList(growable: false),
        teamName: resolvedLeague.leagueName,
        roundLabel: nextSelectedSeason,
      ),
      topScorersRows: data.topScorers,
      topAssistsRows: data.topAssists,
      errorCode: null,
    );

    if (isWorldCup && _activeTabIndex == 1) {
      ensureKnockoutLoaded();
    }
  }

  void cycleFixturesMode() {
    showFixturesModePicker();
  }

  void showFixturesModePicker() {
    Get.bottomSheet<void>(
      SafeArea(
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Get.theme.dividerColor.withAlpha(120)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _pickerTile(
                  title: 'By date',
                  isSelected:
                      state.value.fixtures.mode ==
                      LeagueDetailsFixturesMode.byDate,
                  onTap: () {
                    Get.back<void>();
                    _selectFixturesMode(LeagueDetailsFixturesMode.byDate);
                  },
                ),
                _pickerTile(
                  title: 'By round',
                  isSelected:
                      state.value.fixtures.mode ==
                      LeagueDetailsFixturesMode.byRound,
                  onTap: () {
                    Get.back<void>();
                    _selectFixturesMode(LeagueDetailsFixturesMode.byRound);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _pickerTile({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      title: Text(title),
      trailing: isSelected ? const Icon(Icons.check_rounded) : null,
    );
  }

  Future<void> _selectFixturesMode(LeagueDetailsFixturesMode mode) async {
    final currentFixtures = state.value.fixtures;
    state.value = state.value.copyWith(
      fixtures: currentFixtures.copyWith(mode: mode),
    );

    if (mode == LeagueDetailsFixturesMode.byDate &&
        currentFixtures.byDateSections.isEmpty) {
      if (isWorldCup) {
        await _loadWorldCupInitialFixturesByDateRange();
      } else {
        final range = defaultFixtureDateRange();
        await _loadFixturesByDateRange(fromDate: range.start, toDate: range.end);
      }
      return;
    }

    if (mode == LeagueDetailsFixturesMode.byRound) {
      await _ensureRoundFixturesLoaded();
    }
  }

  Future<void> showFixtureDateRangePicker(BuildContext context) async {
    final currentFixtures = state.value.fixtures;
    final range = _dateRangeFromFixtures(currentFixtures);
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2035, 12, 31),
      initialDateRange: DateTimeRange(start: range.start, end: range.end),
    );

    if (picked == null) {
      return;
    }

    await _loadFixturesByDateRange(
      fromDate: _dateString(picked.start),
      toDate: _dateString(picked.end),
    );
  }

  Future<void> showPreviousFixtureDate() async {
    await _shiftFixtureDateRange(-7);
  }

  Future<void> showNextFixtureDate() async {
    if (state.value.fixtures.isDateNextDisabled) {
      return;
    }
    await _shiftFixtureDateRange(7);
  }

  Future<void> _shiftFixtureDateRange(int dayDelta) async {
    final range = _dateRangeFromFixtures(state.value.fixtures);
    await _loadFixturesByDateRange(
      fromDate: _dateString(range.start.add(Duration(days: dayDelta))),
      toDate: _dateString(range.end.add(Duration(days: dayDelta))),
    );
  }

  Future<void> showRoundPicker() async {
    await _ensureFixtureRoundsLoaded();
    if (isClosed) {
      return;
    }

    final fixtures = state.value.fixtures;
    final rounds = fixtures.roundLabels;
    if (rounds.isEmpty) {
      return;
    }

    Get.bottomSheet<void>(
      SafeArea(
        child: Material(
          color: Colors.transparent,
          child: Container(
            constraints: BoxConstraints(maxHeight: Get.height * 0.62),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Get.theme.dividerColor.withAlpha(120)),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: rounds.length,
              itemBuilder: (context, index) {
                final round = rounds[index];
                return _pickerTile(
                  title: round,
                  isSelected: round == fixtures.selectedRoundLabel,
                  onTap: () {
                    Get.back<void>();
                    _loadFixturesByRound(round: round);
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loadMoreFixtures() async {
    final fixtures = state.value.fixtures;
    if (state.value.isFixturesLoading || state.value.isFixturesLoadingMore) {
      return;
    }

    if (fixtures.mode == LeagueDetailsFixturesMode.byDate &&
        fixtures.datePage < fixtures.dateTotalPages) {
      await _loadFixturesByDateRange(
        fromDate: fixtures.fromDate,
        toDate: fixtures.toDate,
        page: fixtures.datePage + 1,
        append: true,
      );
      return;
    }

    if (fixtures.mode == LeagueDetailsFixturesMode.byRound &&
        fixtures.roundPage < fixtures.roundTotalPages &&
        fixtures.selectedRoundLabel.isNotEmpty) {
      await _loadFixturesByRound(
        round: fixtures.selectedRoundLabel,
        page: fixtures.roundPage + 1,
        append: true,
      );
    }
  }

  Future<void> _ensureRoundFixturesLoaded() async {
    await _ensureFixtureRoundsLoaded();
    if (isClosed) {
      return;
    }

    final fixtures = state.value.fixtures;
    if (fixtures.byRoundSections.isNotEmpty &&
        fixtures.selectedRoundLabel.isNotEmpty) {
      return;
    }

    final firstRound = fixtures.selectedRoundLabel.isNotEmpty
        ? fixtures.selectedRoundLabel
        : (fixtures.roundLabels.isNotEmpty ? fixtures.roundLabels.first : '');
    if (firstRound.isEmpty) {
      return;
    }

    await _loadFixturesByRound(round: firstRound);
  }

  Future<void> _ensureFixtureRoundsLoaded() async {
    final fixtures = state.value.fixtures;
    if (fixtures.roundLabels.isNotEmpty) {
      return;
    }

    final leagueId = _currentLeagueId;
    final seasonYear = _currentSeasonYear;
    if (leagueId == null || seasonYear == null) {
      return;
    }

    state.value = state.value.copyWith(isFixturesLoading: true);
    final response = await ApiErrorHandler.handle<List<String>>(
      () => _service.fetchFixtureRounds(leagueId: leagueId, season: seasonYear),
      fallbackErrorCode: 'fixture_rounds_fetch_failed',
      userMessage: 'Unable to load fixture rounds right now.',
    );

    if (isClosed) {
      return;
    }

    final nextRounds = response.success && response.data != null
        ? response.data!
        : const <String>[];
    final selectedRound = state.value.fixtures.selectedRoundLabel.isNotEmpty
        ? state.value.fixtures.selectedRoundLabel
        : (nextRounds.isNotEmpty ? nextRounds.first : '');

    state.value = state.value.copyWith(
      isFixturesLoading: false,
      fixtures: state.value.fixtures.copyWith(
        roundLabels: nextRounds,
        selectedRoundLabel: selectedRound,
      ),
    );
  }

  Future<void> _loadWorldCupInitialFixturesByDateRange() async {
    final leagueId = _currentLeagueId;
    final seasonYear = _currentSeasonYear;
    if (leagueId == null || seasonYear == null) {
      return;
    }

    state.value = state.value.copyWith(isFixturesLoading: true);
    final response =
        await ApiErrorHandler.handle<LeagueDetailsFixturesViewModel>(
          () => _service.fetchWorldCupInitialFixturesByDateRange(
            leagueId: leagueId,
            season: seasonYear,
          ),
          fallbackErrorCode: 'world_cup_fixture_date_fetch_failed',
          userMessage: 'Unable to load fixtures right now.',
        );

    if (isClosed) {
      return;
    }

    if (!response.success || response.data == null) {
      state.value = state.value.copyWith(isFixturesLoading: false);
      return;
    }

    final currentFixtures = state.value.fixtures;
    final nextFixtures = response.data!.copyWith(
      mode: LeagueDetailsFixturesMode.byDate,
      roundLabels: currentFixtures.roundLabels,
      selectedRoundLabel: currentFixtures.selectedRoundLabel,
      byRoundSections: currentFixtures.byRoundSections,
      roundPage: currentFixtures.roundPage,
      roundTotalPages: currentFixtures.roundTotalPages,
    );

    state.value = state.value.copyWith(
      isFixturesLoading: false,
      fixtures: nextFixtures,
    );
  }

  Future<void> _loadFixturesByDateRange({
    required String fromDate,
    required String toDate,
    int page = 1,
    bool append = false,
  }) async {
    final leagueId = _currentLeagueId;
    final seasonYear = _currentSeasonYear;
    if (leagueId == null || seasonYear == null) {
      return;
    }

    state.value = state.value.copyWith(
      isFixturesLoading: append ? state.value.isFixturesLoading : true,
      isFixturesLoadingMore: append,
    );
    final response =
        await ApiErrorHandler.handle<LeagueDetailsFixturesViewModel>(
          () => _service.fetchLeagueFixturesByDateRange(
            leagueId: leagueId,
            season: seasonYear,
            fromDate: fromDate,
            toDate: toDate,
            page: page,
            existingSections: append
                ? state.value.fixtures.byDateSections
                : const <LeagueDetailsFixtureSectionUiModel>[],
          ),
          fallbackErrorCode: 'league_fixture_date_fetch_failed',
          userMessage: 'Unable to load fixtures right now.',
        );

    if (isClosed) {
      return;
    }

    if (!response.success || response.data == null) {
      state.value = state.value.copyWith(
        isFixturesLoading: false,
        isFixturesLoadingMore: false,
      );
      return;
    }

    final currentFixtures = state.value.fixtures;
    final nextFixtures = response.data!.copyWith(
      mode: LeagueDetailsFixturesMode.byDate,
      roundLabels: currentFixtures.roundLabels,
      selectedRoundLabel: currentFixtures.selectedRoundLabel,
      byRoundSections: currentFixtures.byRoundSections,
      roundPage: currentFixtures.roundPage,
      roundTotalPages: currentFixtures.roundTotalPages,
    );

    state.value = state.value.copyWith(
      isFixturesLoading: false,
      isFixturesLoadingMore: false,
      fixtures: nextFixtures,
    );
  }

  Future<void> _loadFixturesByRound({
    required String round,
    int page = 1,
    bool append = false,
  }) async {
    final leagueId = _currentLeagueId;
    final seasonYear = _currentSeasonYear;
    if (leagueId == null || seasonYear == null) {
      return;
    }

    state.value = state.value.copyWith(
      isFixturesLoading: append ? state.value.isFixturesLoading : true,
      isFixturesLoadingMore: append,
    );
    final currentFixtures = state.value.fixtures;
    final response =
        await ApiErrorHandler.handle<LeagueDetailsFixturesViewModel>(
          () => _service.fetchLeagueFixturesByRound(
            leagueId: leagueId,
            season: seasonYear,
            round: round,
            roundLabels: currentFixtures.roundLabels,
            page: page,
            existingSections: append
                ? currentFixtures.byRoundSections
                : const <LeagueDetailsFixtureSectionUiModel>[],
          ),
          fallbackErrorCode: 'league_fixture_round_fetch_failed',
          userMessage: 'Unable to load round fixtures right now.',
        );

    if (isClosed) {
      return;
    }

    if (!response.success || response.data == null) {
      state.value = state.value.copyWith(
        isFixturesLoading: false,
        isFixturesLoadingMore: false,
      );
      return;
    }

    final nextFixtures = response.data!.copyWith(
      mode: LeagueDetailsFixturesMode.byRound,
      fromDate: currentFixtures.fromDate,
      toDate: currentFixtures.toDate,
      byDateSections: currentFixtures.byDateSections,
      datePage: currentFixtures.datePage,
      dateTotalPages: currentFixtures.dateTotalPages,
    );

    state.value = state.value.copyWith(
      isFixturesLoading: false,
      isFixturesLoadingMore: false,
      fixtures: nextFixtures,
    );
  }

  DateTimeRange _dateRangeFromFixtures(
    LeagueDetailsFixturesViewModel fixtures,
  ) {
    final fallback = defaultFixtureDateRange();
    final start =
        DateTime.tryParse(fixtures.fromDate) ?? DateTime.parse(fallback.start);
    final end =
        DateTime.tryParse(fixtures.toDate) ?? DateTime.parse(fallback.end);
    return DateTimeRange(start: start, end: end);
  }

  String _dateString(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  int? get _currentLeagueId {
    final league = state.value.league ?? initialLeague;
    return int.tryParse(league?.leagueId ?? '');
  }

  int? get _currentSeasonYear {
    final selectedSeason = state.value.selectedSeason;
    final match = RegExp(r'\d{4}').firstMatch(selectedSeason);
    if (match != null) {
      return int.tryParse(match.group(0)!);
    }
    return (state.value.league ?? initialLeague)?.season;
  }

  Future<void> follow() async {
    final league = state.value.league;
    final payload = FollowEntityPayloadModel(
      entityType: FollowEntityType.league,
      entityId: league?.leagueId ?? 'premier-league',
      entityName: league?.leagueName,
      entityLogo: league?.image,
      notificationEnabled: true,
    );

    await ApiErrorHandler.handle<FollowingActionUiModel>(
      () => _followingService.follow(payload),
      fallbackErrorCode: 'league_follow_failed',
      userMessage: 'Could not follow this league right now.',
    );
  }

  Future<void> unfollow() async {
    final payload = UnfollowPayloadModel(
      entityType: FollowEntityType.league,
      entityId: state.value.league?.leagueId ?? 'premier-league',
    );

    await ApiErrorHandler.handle<FollowingActionUiModel>(
      () => _followingService.unfollow(payload),
      fallbackErrorCode: 'league_unfollow_failed',
      userMessage: 'Could not unfollow this league right now.',
    );
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
        'Minutes Played',
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
          title: 'Goals + Assists',
          filterLabel: 'Goals + Assists',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Minutes Played',
          filterLabel: 'Minutes Played',
        ),
      ],
    ),
    LeagueDetailsPlayerStatsCategoryData(
      title: 'Attack',
      availableFilters: <String>[
        'Shot Attempts',
        'Shots on Target',
        'Penalty Scored',
        'Penalty Missed',
        'Big chances created',
        'Chances created',
        'Big chances missed',
        'Penalties awarded',
      ],
      cards: <LeagueDetailsPlayerStatsCardData>[
        LeagueDetailsPlayerStatsCardData(
          title: 'Shot Attempts',
          filterLabel: 'Shot Attempts',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Shots on Target',
          filterLabel: 'Shots on Target',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Penalty Scored',
          filterLabel: 'Penalty Scored',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Penalty Missed',
          filterLabel: 'Penalty Missed',
        ),
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
      title: 'Defense',
      availableFilters: <String>[
        'Tackles',
        'Interceptions',
        'Blocks',
        'Defense contribution',
        'Clearances',
        'Recoveries',
        'Penalties conceded',
      ],
      cards: <LeagueDetailsPlayerStatsCardData>[
        LeagueDetailsPlayerStatsCardData(
          title: 'Tackles',
          filterLabel: 'Tackles',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Interceptions',
          filterLabel: 'Interceptions',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Blocks',
          filterLabel: 'Blocks',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Defense contribution',
          filterLabel: 'Defense contribution',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Clearance',
          filterLabel: 'Clearances',
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
        'Saves',
        'Goals Conceded',
        'Penalty Saved',
        'Goals prevented',
        'Clean sheets',
        'Save percentage',
      ],
      cards: <LeagueDetailsPlayerStatsCardData>[
        LeagueDetailsPlayerStatsCardData(title: 'Saves', filterLabel: 'Saves'),
        LeagueDetailsPlayerStatsCardData(
          title: 'Goals Conceded',
          filterLabel: 'Goals Conceded',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Penalty Saved',
          filterLabel: 'Penalty Saved',
        ),
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
        'Yellow Cards',
        'Red Cards',
        'Fouls Committed',
        'Fouls Drawn',
      ],
      cards: <LeagueDetailsPlayerStatsCardData>[
        LeagueDetailsPlayerStatsCardData(
          title: 'Yellow Cards',
          filterLabel: 'Yellow Cards',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Red Cards',
          filterLabel: 'Red Cards',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Fouls Committed',
          filterLabel: 'Fouls Committed',
        ),
        LeagueDetailsPlayerStatsCardData(
          title: 'Fouls Drawn',
          filterLabel: 'Fouls Drawn',
        ),
      ],
    ),
  ];

  static const List<String> _topStatsLabels = <String>[
    'Goals per Match',
    'Goals Conceded per Match',
    'Clean Sheets',
    'Wins',
    'Failed to Score',
    'Average possession',
    'Attendance',
  ];

  static const List<String> _attackTeamLabels = <String>[
    'Shot Attempts',
    'Shots on Target',
    'Key Passes',
    'Penalty Scored',
    'Penalty Missed',
    'Big chances',
    'Big chances missed',
    'Accurate passes per match',
    'Accurate long balls per match',
    'Accurate crosses per match',
    'Penalties awarded',
    'Touches in opposition box',
    'Corners',
    'Set piece goals',
  ];

  static const List<String> _defenseTeamLabels = <String>[
    'Tackles',
    'Interceptions',
    'Blocks',
    'Saves',
    'Goals Conceded',
    'Interceptions per match',
    'Tackles per match',
    'Clearances per match',
    'Possession won final 3rd per match',
    'Set piece goals conceded',
    'Penalties conceded',
    'Saves per match',
  ];

  static const List<String> _disciplineTeamLabels = <String>[
    'Yellow Cards',
    'Red Cards',
    'Fouls Committed',
    'Fouls Drawn',
    'Fouls per match',
  ];

  static List<LeagueDetailsPlayerStatRowUiModel> teamStatsRowsFor(
    String filterLabel,
  ) {
    if (!Get.isRegistered<LeagueDetailsController>()) {
      return const <LeagueDetailsPlayerStatRowUiModel>[];
    }

    final state = Get.find<LeagueDetailsController>().state.value;
    final normalized = _normalizePlayerStatLabel(filterLabel);

    for (final section in state.teamStatsSections) {
      if (_normalizePlayerStatLabel(section.title) == normalized ||
          _normalizePlayerStatLabel(section.key) == normalized) {
        return section.rows;
      }
    }

    return const <LeagueDetailsPlayerStatRowUiModel>[];
  }

  static List<LeagueDetailsPlayerStatsPreviewRowData> playerStatsPreviewRowsFor(
    String filterLabel,
  ) {
    final rows = _remotePlayerRowsFor(
      filterLabel,
    ).take(3).toList(growable: false);
    if (rows.isNotEmpty) {
      return rows
          .map(
            (row) => LeagueDetailsPlayerStatsPreviewRowData(
              rank: row.rank,
              name: row.name,
              teamName: row.teamName,
              value: row.value,
              playerImageUrl: row.playerImageUrl,
            ),
          )
          .toList(growable: false);
    }

    return const <LeagueDetailsPlayerStatsPreviewRowData>[];
  }

  static List<LeagueDetailsPlayerStatsDetailRowData> playerStatsDetailRowsFor(
    String filterLabel,
  ) {
    final remoteRows = _remotePlayerRowsFor(filterLabel);
    if (remoteRows.isNotEmpty) {
      return remoteRows
          .map(
            (row) => LeagueDetailsPlayerStatsDetailRowData(
              rank: row.rank.replaceAll('.', ''),
              name: row.name,
              value: row.value,
              subtitleValue: row.subtitleValue.isEmpty
                  ? '-'
                  : row.subtitleValue,
              playerImageUrl: row.playerImageUrl,
              teamLogoUrl: row.teamLogoUrl,
            ),
          )
          .toList(growable: false);
    }

    return const <LeagueDetailsPlayerStatsDetailRowData>[];
  }

  static String get _currentLeagueLogoUrl {
    if (!Get.isRegistered<LeagueDetailsController>()) {
      return '';
    }
    return Get.find<LeagueDetailsController>().state.value.league?.image ?? '';
  }

  static List<LeagueDetailsPlayerStatRowUiModel> _remotePlayerRowsFor(
    String filterLabel,
  ) {
    if (!Get.isRegistered<LeagueDetailsController>()) {
      return const <LeagueDetailsPlayerStatRowUiModel>[];
    }

    final state = Get.find<LeagueDetailsController>().state.value;
    final normalized = _normalizePlayerStatLabel(filterLabel);

    for (final section in state.playerStatsSections) {
      if (_normalizePlayerStatLabel(section.title) == normalized ||
          _normalizePlayerStatLabel(section.key) == normalized) {
        return section.rows;
      }
    }

    if (normalized == _normalizePlayerStatLabel('Assists')) {
      return state.topAssistsRows;
    }

    if (normalized == _normalizePlayerStatLabel('Top scorer')) {
      return state.topScorersRows;
    }

    if (normalized == _normalizePlayerStatLabel('Goals + Assists')) {
      final combined = <LeagueDetailsPlayerStatRowUiModel>[];
      for (final row in state.topScorersRows) {
        final goals = int.tryParse(row.value) ?? 0;
        final assists = int.tryParse(row.subtitleValue) ?? 0;
        combined.add(
          LeagueDetailsPlayerStatRowUiModel(
            rank: row.rank,
            name: row.name,
            teamId: row.teamId,
            teamName: row.teamName,
            value: '${goals + assists}',
            subtitleValue: assists.toString(),
            playerImageUrl: row.playerImageUrl,
            teamLogoUrl: row.teamLogoUrl,
          ),
        );
      }
      combined.sort(
        (left, right) => (int.tryParse(right.value) ?? 0).compareTo(
          int.tryParse(left.value) ?? 0,
        ),
      );
      return List<LeagueDetailsPlayerStatRowUiModel>.generate(combined.length, (
        index,
      ) {
        final row = combined[index];
        return LeagueDetailsPlayerStatRowUiModel(
          rank: '${index + 1}.',
          name: row.name,
          teamId: row.teamId,
          teamName: row.teamName,
          value: row.value,
          subtitleValue: row.subtitleValue,
          playerImageUrl: row.playerImageUrl,
          teamLogoUrl: row.teamLogoUrl,
        );
      }, growable: false);
    }

    return const <LeagueDetailsPlayerStatRowUiModel>[];
  }

  static String _normalizePlayerStatLabel(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll('&', 'and')
        .replaceAll(RegExp(r'[^a-z0-9]+'), '');
  }

  static String playerStatsSubtitleLabelFor(String filterLabel) {
    final normalized = filterLabel.toLowerCase();
    final normalizedCompact = _normalizePlayerStatLabel(filterLabel);
    if (Get.isRegistered<LeagueDetailsController>()) {
      final sections =
          Get.find<LeagueDetailsController>().state.value.playerStatsSections;
      final isApiSection = sections.any(
        (section) =>
            _normalizePlayerStatLabel(section.title) == normalizedCompact ||
            _normalizePlayerStatLabel(section.key) == normalizedCompact,
      );
      if (isApiSection) {
        return 'Team';
      }
    }

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
      Get.lazyPut<FollowingService>(
        () => FollowingService(
          apiClient: Get.find<ApiClient>(),
          storageService: Get.find<StorageService>(),
        ),
        fenix: true,
      );
    }

    if (!Get.isRegistered<LeagueDetailsService>()) {
      Get.lazyPut<LeagueDetailsService>(
        () => LeagueDetailsService(apiClient: Get.find<ApiClient>()),
        fenix: true,
      );
    }

    Get.lazyPut<LeagueDetailsController>(
      () => LeagueDetailsController(
        initialLeague: league,
        service: Get.find<LeagueDetailsService>(),
      ),
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
  final String playerImageUrl;

  const LeagueDetailsPlayerStatsPreviewRowData({
    required this.rank,
    required this.name,
    required this.teamName,
    required this.value,
    this.playerImageUrl = '',
  });
}

class LeagueDetailsPlayerStatsDetailRowData {
  final String rank;
  final String name;
  final String value;
  final String subtitleValue;
  final String playerImageUrl;
  final String teamLogoUrl;

  const LeagueDetailsPlayerStatsDetailRowData({
    required this.rank,
    required this.name,
    required this.value,
    required this.subtitleValue,
    this.playerImageUrl = '',
    this.teamLogoUrl = '',
  });
}
