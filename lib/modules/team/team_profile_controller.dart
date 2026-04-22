import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/following_service.dart';
import 'team_profile_model.dart';

class TeamProfileBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<FollowingService>()) {
      Get.lazyPut<FollowingService>(() => FollowingService(), fenix: true);
    }
    Get.lazyPut<TeamProfileController>(() => TeamProfileController());
  }
}

class TeamProfileController extends GetxController {
  TeamProfileController() : _followingService = Get.find<FollowingService>();

  final FollowingService _followingService;
  final Rx<TeamProfileViewModel> state = _initialState.obs;

  Worker? _worker;
  int initialTabIndex = 0;
  String _teamId = 'arsenal';

  @override
  void onInit() {
    super.onInit();

    final argument = Get.arguments;
    if (argument is String) {
      initialTabIndex = _tabIndexFrom(argument);
    } else if (argument is Map<String, dynamic>) {
      initialTabIndex = _tabIndexFrom(argument['tab']?.toString() ?? '');
      final teamId = argument['teamId']?.toString();
      if (teamId != null && teamId.isNotEmpty) {
        _applyTeamId(teamId);
      }
    }

    _syncFollowingState();
    _worker = ever<int>(_followingService.revision, (_) => _syncFollowingState());
  }

  @override
  void onClose() {
    _worker?.dispose();
    super.onClose();
  }

  void follow() {
    _followingService.follow(FollowEntityType.team, _teamId);
  }

  void unfollow() {
    _followingService.unfollow(FollowEntityType.team, _teamId);
  }

  void _syncFollowingState() {
    state.value = state.value.copyWith(
      isFollowing: _followingService.isFollowing(FollowEntityType.team, _teamId),
    );
  }

  void _applyTeamId(String id) {
    _teamId = id;
    switch (id) {
      case 'bangladesh':
        state.value = state.value.copyWith(
          team: const TeamProfileTeamUiModel(
            name: 'Bangladesh',
            country: 'Bangladesh',
            badgeSeed: 'BD',
            badgeColor: Color(0xFF0E8B67),
          ),
          coach: const TeamProfileSquadPersonUiModel(
            name: 'Coach',
            countryFlag: 'BD',
            countryName: 'Bangladesh',
            shirtNumber: '',
            age: '46',
            badgeSeed: 'BD',
            badgeColor: Color(0xFF0E8B67),
          ),
        );
        break;
      case 'al-nassr':
        state.value = state.value.copyWith(
          team: const TeamProfileTeamUiModel(
            name: 'Al Nassar FC',
            country: 'Saudi Arabia',
            badgeSeed: 'AN',
            badgeColor: Color(0xFFF6C23E),
          ),
        );
        break;
      case 'barcelona':
        state.value = state.value.copyWith(
          team: const TeamProfileTeamUiModel(
            name: 'Barcelona',
            country: 'Spain',
            badgeSeed: 'BAR',
            badgeColor: Color(0xFF8B1D2C),
          ),
        );
        break;
      case 'atletico-madrid':
        state.value = state.value.copyWith(
          team: const TeamProfileTeamUiModel(
            name: 'Atletico Madrid',
            country: 'Spain',
            badgeSeed: 'ATM',
            badgeColor: Color(0xFF274C93),
          ),
        );
        break;
      default:
        _teamId = 'arsenal';
        state.value = state.value.copyWith(team: _arsenal);
        break;
    }
  }

  void toggleAboutExpanded() {
    state.value = state.value.copyWith(
      isAboutExpanded: !state.value.isAboutExpanded,
    );
  }

  void selectSeason(String season) {
    state.value = state.value.copyWith(selectedSeason: season);
  }

  void loadMorePreviousMatches() {
    final current = state.value;
    if (!current.canLoadMorePreviousMatches) {
      return;
    }

    state.value = current.copyWith(
      visiblePreviousMatches: current.visiblePreviousMatches + 2,
    );
  }

  void loadMoreUpcomingMatches() {
    final current = state.value;
    if (!current.canLoadMoreUpcomingMatches) {
      return;
    }

    state.value = current.copyWith(
      visibleUpcomingMatches: current.visibleUpcomingMatches + 2,
    );
  }

  void loadMoreTrophies() {
    final current = state.value;
    if (!current.canLoadMoreTrophies) {
      return;
    }

    state.value = current.copyWith(
      visibleTrophies: current.visibleTrophies + 2,
    );
  }

  int _tabIndexFrom(String value) {
    switch (value.toLowerCase()) {
      case 'table':
        return 1;
      case 'matches':
        return 2;
      case 'squad':
      case 'squads':
        return 3;
      case 'trophies':
        return 4;
      default:
        return 0;
    }
  }

  static const TeamProfileTeamUiModel _arsenal = TeamProfileTeamUiModel(
    name: 'Arsenal',
    country: 'England',
    badgeSeed: 'ARS',
    badgeColor: Color(0xFFC13329),
  );

  static const TeamProfileTeamUiModel _chelsea = TeamProfileTeamUiModel(
    name: 'Chelsea',
    country: 'England',
    badgeSeed: 'CHE',
    badgeColor: Color(0xFF2F6FE4),
  );

  static const List<String> _seasons = <String>[
    '2025/2026',
    '2024/2025',
    '2023/2024',
  ];

  static const TeamProfileOverviewUiModel _overview = TeamProfileOverviewUiModel(
    nextMatches: <TeamProfileNextMatchUiModel>[
      TeamProfileNextMatchUiModel(
        competitionLabel: 'Champions League Final Stage',
        timeLabel: '01:00',
        statusLabel: 'Tomorrow',
        homeTeam: _arsenal,
        awayTeam: _chelsea,
      ),
      TeamProfileNextMatchUiModel(
        competitionLabel: 'Champions League Final Stage',
        timeLabel: '21:00',
        statusLabel: 'Sun, 20 Apr',
        homeTeam: _arsenal,
        awayTeam: TeamProfileTeamUiModel(
          name: 'Barcelona',
          country: 'Spain',
          badgeSeed: 'BAR',
          badgeColor: Color(0xFF8B1D2C),
        ),
      ),
    ],
    leftResults: <TeamProfileFormResultUiModel>[
      TeamProfileFormResultUiModel(scoreLabel: '1 - 0', isPositive: true),
      TeamProfileFormResultUiModel(scoreLabel: '1 - 0', isPositive: true),
      TeamProfileFormResultUiModel(scoreLabel: '7 - 2', isPositive: true),
    ],
    rightResults: <TeamProfileFormResultUiModel>[
      TeamProfileFormResultUiModel(scoreLabel: '1 - 2', isPositive: false),
      TeamProfileFormResultUiModel(scoreLabel: '3 - 2', isPositive: false),
      TeamProfileFormResultUiModel(scoreLabel: '3 - 2', isPositive: false),
    ],
    topPlayers: <TeamProfileTopPlayerUiModel>[
      TeamProfileTopPlayerUiModel(
        name: 'Viktor',
        subtitle: 'Top Scorer',
        value: '12',
        badgeSeed: 'V',
        badgeColor: Color(0xFF2A323A),
      ),
      TeamProfileTopPlayerUiModel(
        name: 'Declan Rice',
        subtitle: 'Assists',
        value: '5',
        badgeSeed: 'DR',
        badgeColor: Color(0xFF2A323A),
      ),
      TeamProfileTopPlayerUiModel(
        name: 'Jurrien Timber',
        subtitle: 'Yellow Cards',
        value: '5',
        badgeSeed: 'JT',
        badgeColor: Color(0xFF2A323A),
      ),
    ],
    leagues: <TeamProfileLeagueItemUiModel>[
      TeamProfileLeagueItemUiModel(
        title: 'Premiere League',
        seasonLabel: '2025/2026',
        badgeSeed: 'PL',
        badgeColor: Color(0xFF6B1CC2),
      ),
      TeamProfileLeagueItemUiModel(
        title: 'Champions League',
        seasonLabel: '2025/2026',
        badgeSeed: 'CL',
        badgeColor: Color(0xFF274C93),
      ),
      TeamProfileLeagueItemUiModel(
        title: 'EFL Cup',
        seasonLabel: '2025/2026',
        badgeSeed: 'EFL',
        badgeColor: Color(0xFFD22B2B),
      ),
      TeamProfileLeagueItemUiModel(
        title: 'FA Cup',
        seasonLabel: '2025/2026',
        badgeSeed: 'FA',
        badgeColor: Color(0xFF3A6BD9),
      ),
    ],
    rankings: <TeamProfileRankingItemUiModel>[
      TeamProfileRankingItemUiModel(
        title: 'Premiere League',
        value: '13',
        badgeSeed: 'PL',
        badgeColor: Color(0xFF6B1CC2),
      ),
      TeamProfileRankingItemUiModel(
        title: 'Community Shield',
        value: '17',
        badgeSeed: 'CS',
        badgeColor: Color(0xFF1A8D70),
      ),
    ],
    venue: TeamProfileVenueUiModel(
      stadiumName: 'Emirates Stadium',
      city: 'London, England',
      capacity: '99,787',
      surface: 'Grass',
      opened: '2006',
    ),
    aboutText:
        'Arsenal is a football club based in London, England, playing their home matches at Emirates Stadium. '
        'Follow Arsenal on FotMob for live match updates, detailed statistics, squad information, transfer news, '
        'and comprehensive performance analytics. Declan Rice has been the standout performer for Arsenal in league '
        'play this season with a rating of 7.62. Bukayo Saka and Gabriel have also impressed with ratings of 7.49 '
        'and 7.40 respectively. Viktor Gyökeres leads Arsenal’s scoring in league play with 12 goals this season. '
        'Eberechi Eze has contributed 6, while Bukayo Saka has added 6. Declan Rice is the chief creator for Arsenal '
        'in league play with 5 assists added. Martin Ødegaard and Leandro Trossard have also been key playmakers '
        'with 5 and 5 assists respectively.',
  );

  static const List<TeamProfileStandingsRowUiModel> _standings =
      <TeamProfileStandingsRowUiModel>[
        TeamProfileStandingsRowUiModel(
          rank: '1',
          teamName: 'Arsenal',
          badgeSeed: 'ARS',
          badgeColor: Color(0xFFC13329),
          played: '32',
          plusMinus: '62-24',
          goalDifference: '+38',
          points: '70',
        ),
        TeamProfileStandingsRowUiModel(
          rank: '2',
          teamName: 'Man City',
          badgeSeed: 'MCI',
          badgeColor: Color(0xFF5CB9FF),
          played: '30',
          plusMinus: '60-28',
          goalDifference: '+32',
          points: '61',
        ),
        TeamProfileStandingsRowUiModel(
          rank: '3',
          teamName: 'Man United',
          badgeSeed: 'MUN',
          badgeColor: Color(0xFFC13329),
          played: '31',
          plusMinus: '56-43',
          goalDifference: '+13',
          points: '55',
        ),
        TeamProfileStandingsRowUiModel(
          rank: '4',
          teamName: 'Aston Villa',
          badgeSeed: 'AVL',
          badgeColor: Color(0xFF89C1F5),
          played: '31',
          plusMinus: '57-52',
          goalDifference: '+5',
          points: '54',
        ),
        TeamProfileStandingsRowUiModel(
          rank: '5',
          teamName: 'Liverpool',
          badgeSeed: 'LIV',
          badgeColor: Color(0xFFAA1F25),
          played: '32',
          plusMinus: '58-48',
          goalDifference: '+10',
          points: '52',
        ),
        TeamProfileStandingsRowUiModel(
          rank: '6',
          teamName: 'Chelsea',
          badgeSeed: 'CHE',
          badgeColor: Color(0xFF2F6FE4),
          played: '31',
          plusMinus: '54-39',
          goalDifference: '+15',
          points: '48',
        ),
        TeamProfileStandingsRowUiModel(
          rank: '7',
          teamName: 'Brentford',
          badgeSeed: 'BRE',
          badgeColor: Color(0xFFD22B2B),
          played: '32',
          plusMinus: '53-49',
          goalDifference: '+4',
          points: '47',
        ),
        TeamProfileStandingsRowUiModel(
          rank: '8',
          teamName: 'Everton',
          badgeSeed: 'EVE',
          badgeColor: Color(0xFF244A95),
          played: '32',
          plusMinus: '49-47',
          goalDifference: '+2',
          points: '47',
        ),
        TeamProfileStandingsRowUiModel(
          rank: '9',
          teamName: 'Brighton',
          badgeSeed: 'BHA',
          badgeColor: Color(0xFF1F7FDB),
          played: '32',
          plusMinus: '56-50',
          goalDifference: '+6',
          points: '46',
        ),
        TeamProfileStandingsRowUiModel(
          rank: '10',
          teamName: 'Bournemouth',
          badgeSeed: 'BOU',
          badgeColor: Color(0xFF7F1D1D),
          played: '32',
          plusMinus: '42-43',
          goalDifference: '-1',
          points: '45',
        ),
        TeamProfileStandingsRowUiModel(
          rank: '11',
          teamName: 'Fulham',
          badgeSeed: 'FUL',
          badgeColor: Color(0xFF101010),
          played: '32',
          plusMinus: '41-44',
          goalDifference: '-3',
          points: '44',
        ),
        TeamProfileStandingsRowUiModel(
          rank: '12',
          teamName: 'Sunderland',
          badgeSeed: 'SUN',
          badgeColor: Color(0xFFE11D48),
          played: '31',
          plusMinus: '40-44',
          goalDifference: '-4',
          points: '43',
        ),
        TeamProfileStandingsRowUiModel(
          rank: '13',
          teamName: 'Newcastle',
          badgeSeed: 'NEW',
          badgeColor: Color(0xFF26323B),
          played: '31',
          plusMinus: '41-42',
          goalDifference: '-1',
          points: '42',
        ),
        TeamProfileStandingsRowUiModel(
          rank: '14',
          teamName: 'Wolves',
          badgeSeed: 'WOL',
          badgeColor: Color(0xFFE4A11E),
          played: '32',
          plusMinus: '40-48',
          goalDifference: '-8',
          points: '40',
        ),
        TeamProfileStandingsRowUiModel(
          rank: '15',
          teamName: 'West Ham',
          badgeSeed: 'WHU',
          badgeColor: Color(0xFF7C1F3A),
          played: '32',
          plusMinus: '35-46',
          goalDifference: '-11',
          points: '38',
        ),
        TeamProfileStandingsRowUiModel(
          rank: '16',
          teamName: 'Crystal Palace',
          badgeSeed: 'CRY',
          badgeColor: Color(0xFF245BC5),
          played: '32',
          plusMinus: '35-47',
          goalDifference: '-12',
          points: '35',
        ),
        TeamProfileStandingsRowUiModel(
          rank: '17',
          teamName: 'Leicester',
          badgeSeed: 'LEI',
          badgeColor: Color(0xFF2563EB),
          played: '32',
          plusMinus: '33-49',
          goalDifference: '-16',
          points: '32',
        ),
        TeamProfileStandingsRowUiModel(
          rank: '18',
          teamName: 'Luton Town',
          badgeSeed: 'LUT',
          badgeColor: Color(0xFF1D4ED8),
          played: '32',
          plusMinus: '29-56',
          goalDifference: '-27',
          points: '25',
        ),
        TeamProfileStandingsRowUiModel(
          rank: '19',
          teamName: 'Burnley',
          badgeSeed: 'BUR',
          badgeColor: Color(0xFF8B2F2F),
          played: '32',
          plusMinus: '26-62',
          goalDifference: '-36',
          points: '21',
        ),
        TeamProfileStandingsRowUiModel(
          rank: '20',
          teamName: 'Sheffield Utd',
          badgeSeed: 'SHU',
          badgeColor: Color(0xFFDC2626),
          played: '32',
          plusMinus: '23-71',
          goalDifference: '-48',
          points: '16',
        ),
      ];

  static const List<TeamProfileMatchRowUiModel> _previousMatches =
      <TeamProfileMatchRowUiModel>[
        TeamProfileMatchRowUiModel(
          dateLabel: '4 March',
          competitionLabel: 'Copa del Rey',
          homeTeam: _arsenal,
          awayTeam: TeamProfileTeamUiModel(
            name: 'Man city',
            country: 'England',
            badgeSeed: 'MCI',
            badgeColor: Color(0xFF5CB9FF),
          ),
          centerLabel: '3 - 0',
        ),
        TeamProfileMatchRowUiModel(
          dateLabel: '5 April',
          competitionLabel: 'LaLiga',
          homeTeam: TeamProfileTeamUiModel(
            name: 'Everton',
            country: 'England',
            badgeSeed: 'EVE',
            badgeColor: Color(0xFF244A95),
          ),
          awayTeam: _arsenal,
          centerLabel: '1 - 2',
        ),
        TeamProfileMatchRowUiModel(
          dateLabel: '9 April',
          competitionLabel: 'Premier League',
          homeTeam: _arsenal,
          awayTeam: TeamProfileTeamUiModel(
            name: 'Liverpool',
            country: 'England',
            badgeSeed: 'LIV',
            badgeColor: Color(0xFFAA1F25),
          ),
          centerLabel: '2 - 1',
        ),
        TeamProfileMatchRowUiModel(
          dateLabel: '12 April',
          competitionLabel: 'Premier League',
          homeTeam: TeamProfileTeamUiModel(
            name: 'Aston Villa',
            country: 'England',
            badgeSeed: 'AVL',
            badgeColor: Color(0xFF89C1F5),
          ),
          awayTeam: _arsenal,
          centerLabel: '0 - 1',
        ),
      ];

  static const List<TeamProfileMatchRowUiModel> _upcomingMatches =
      <TeamProfileMatchRowUiModel>[
        TeamProfileMatchRowUiModel(
          dateLabel: 'Tomorrow',
          competitionLabel: 'Champions League',
          homeTeam: _arsenal,
          awayTeam: _chelsea,
          centerLabel: '01:00',
          isUpcoming: true,
        ),
        TeamProfileMatchRowUiModel(
          dateLabel: '23 April',
          competitionLabel: 'Premier League',
          homeTeam: _arsenal,
          awayTeam: TeamProfileTeamUiModel(
            name: 'Brentford',
            country: 'England',
            badgeSeed: 'BRE',
            badgeColor: Color(0xFFD22B2B),
          ),
          centerLabel: '18:30',
          isUpcoming: true,
        ),
        TeamProfileMatchRowUiModel(
          dateLabel: '27 April',
          competitionLabel: 'FA Cup',
          homeTeam: TeamProfileTeamUiModel(
            name: 'Man United',
            country: 'England',
            badgeSeed: 'MUN',
            badgeColor: Color(0xFFC13329),
          ),
          awayTeam: _arsenal,
          centerLabel: '20:00',
          isUpcoming: true,
        ),
      ];

  static const TeamProfileSquadPersonUiModel _coach =
      TeamProfileSquadPersonUiModel(
        name: 'Mikel Arteta',
        countryFlag: '🇪🇸',
        countryName: 'Country',
        shirtNumber: '',
        age: '31',
        badgeSeed: 'MA',
        badgeColor: Color(0xFF2A323A),
      );

  static const List<TeamProfileSquadSectionUiModel> _squadSections =
      <TeamProfileSquadSectionUiModel>[
        TeamProfileSquadSectionUiModel(
          title: 'Keepers',
          players: <TeamProfileSquadPersonUiModel>[
            TeamProfileSquadPersonUiModel(
              name: 'David Raya',
              countryFlag: '🇪🇸',
              countryName: 'Country',
              shirtNumber: '13',
              age: '31',
              badgeSeed: 'DR',
              badgeColor: Color(0xFF2A323A),
            ),
            TeamProfileSquadPersonUiModel(
              name: 'Neto',
              countryFlag: '🇧🇷',
              countryName: 'Country',
              shirtNumber: '13',
              age: '31',
              badgeSeed: 'N',
              badgeColor: Color(0xFF2A323A),
            ),
          ],
        ),
        TeamProfileSquadSectionUiModel(
          title: 'Defenders',
          players: <TeamProfileSquadPersonUiModel>[
            TeamProfileSquadPersonUiModel(
              name: 'William Saliba',
              countryFlag: '🇫🇷',
              countryName: 'Country',
              shirtNumber: '13',
              age: '31',
              badgeSeed: 'WS',
              badgeColor: Color(0xFF2A323A),
            ),
            TeamProfileSquadPersonUiModel(
              name: 'Gabriel',
              countryFlag: '🇧🇷',
              countryName: 'Country',
              shirtNumber: '13',
              age: '31',
              badgeSeed: 'G',
              badgeColor: Color(0xFF2A323A),
            ),
          ],
        ),
        TeamProfileSquadSectionUiModel(
          title: 'Midfielders',
          players: <TeamProfileSquadPersonUiModel>[
            TeamProfileSquadPersonUiModel(
              name: 'Declan Rice',
              countryFlag: '🇬🇧',
              countryName: 'Country',
              shirtNumber: '13',
              age: '31',
              badgeSeed: 'DR',
              badgeColor: Color(0xFF2A323A),
            ),
            TeamProfileSquadPersonUiModel(
              name: 'Martin Ødegaard',
              countryFlag: '🇳🇴',
              countryName: 'Country',
              shirtNumber: '13',
              age: '31',
              badgeSeed: 'MØ',
              badgeColor: Color(0xFF2A323A),
            ),
          ],
        ),
        TeamProfileSquadSectionUiModel(
          title: 'Forwards',
          players: <TeamProfileSquadPersonUiModel>[
            TeamProfileSquadPersonUiModel(
              name: 'Bukayo Saka',
              countryFlag: '🇬🇧',
              countryName: 'Country',
              shirtNumber: '13',
              age: '31',
              badgeSeed: 'BS',
              badgeColor: Color(0xFF2A323A),
            ),
            TeamProfileSquadPersonUiModel(
              name: 'Kai Havertz',
              countryFlag: '🇩🇪',
              countryName: 'Country',
              shirtNumber: '13',
              age: '31',
              badgeSeed: 'KH',
              badgeColor: Color(0xFF2A323A),
            ),
          ],
        ),
      ];

  static const List<TeamProfileTrophySectionUiModel> _trophies =
      <TeamProfileTrophySectionUiModel>[
        TeamProfileTrophySectionUiModel(
          title: 'Premiere League',
          badgeSeed: 'PL',
          badgeColor: Color(0xFF6B1CC2),
          entries: <TeamProfileTrophyEntryUiModel>[
            TeamProfileTrophyEntryUiModel(
              count: '13',
              label: 'Winner',
              years:
                  '2003/04, 2001/02, Year3, Year4, Year5, Year6\nYear7, Year8, Year9, Year10, Year11, Year12, Year13',
            ),
            TeamProfileTrophyEntryUiModel(
              count: '12',
              label: 'Runner-Up',
              years:
                  '2003/04, 2001/02, Year3, Year4, Year5, Year6\nYear7, Year8, Year9, Year10, Year11, Year12, Year13',
            ),
          ],
        ),
        TeamProfileTrophySectionUiModel(
          title: 'Championship',
          badgeSeed: 'CH',
          badgeColor: Color(0xFF2F6FE4),
          entries: <TeamProfileTrophyEntryUiModel>[
            TeamProfileTrophyEntryUiModel(
              count: '12',
              label: 'Runner-Up',
              years:
                  '2003/04, 2001/02, Year3, Year4, Year5, Year6\nYear7, Year8, Year9, Year10, Year11, Year12, Year13',
            ),
          ],
        ),
        TeamProfileTrophySectionUiModel(
          title: 'Champions League',
          badgeSeed: 'CL',
          badgeColor: Color(0xFF274C93),
          entries: <TeamProfileTrophyEntryUiModel>[
            TeamProfileTrophyEntryUiModel(
              count: '13',
              label: 'Winner',
              years:
                  '2003/04, 2001/02, Year3, Year4, Year5, Year6\nYear7, Year8, Year9, Year10, Year11, Year12, Year13',
            ),
            TeamProfileTrophyEntryUiModel(
              count: '12',
              label: 'Runner-Up',
              years:
                  '2003/04, 2001/02, Year3, Year4, Year5, Year6\nYear7, Year8, Year9, Year10, Year11, Year12, Year13',
            ),
          ],
        ),
        TeamProfileTrophySectionUiModel(
          title: 'Europa League',
          badgeSeed: 'EL',
          badgeColor: Color(0xFF0F8A70),
          entries: <TeamProfileTrophyEntryUiModel>[
            TeamProfileTrophyEntryUiModel(
              count: '13',
              label: 'Winner',
              years:
                  '2003/04, 2001/02, Year3, Year4, Year5, Year6\nYear7, Year8, Year9, Year10, Year11, Year12, Year13',
            ),
            TeamProfileTrophyEntryUiModel(
              count: '12',
              label: 'Runner-Up',
              years:
                  '2003/04, 2001/02, Year3, Year4, Year5, Year6\nYear7, Year8, Year9, Year10, Year11, Year12, Year13',
            ),
          ],
        ),
        TeamProfileTrophySectionUiModel(
          title: 'FA Cup',
          badgeSeed: 'FA',
          badgeColor: Color(0xFFD22B2B),
          entries: <TeamProfileTrophyEntryUiModel>[
            TeamProfileTrophyEntryUiModel(
              count: '14',
              label: 'Winner',
              years:
                  '2005, 2003, 2002, 1998, 1993, 1979\n1971, 1950, 1936, 1930, 1929, 1910',
            ),
          ],
        ),
        TeamProfileTrophySectionUiModel(
          title: 'Community Shield',
          badgeSeed: 'CS',
          badgeColor: Color(0xFF1A8D70),
          entries: <TeamProfileTrophyEntryUiModel>[
            TeamProfileTrophyEntryUiModel(
              count: '17',
              label: 'Winner',
              years:
                  '2023, 2020, 2017, 2015, 2014, 2004\n2002, 1999, 1998, 1991, 1979, 1953',
            ),
          ],
        ),
      ];

  static const TeamProfileViewModel _initialState = TeamProfileViewModel(
    team: _arsenal,
    isFollowing: true,
    isAboutExpanded: false,
    seasons: _seasons,
    selectedSeason: '2025/2026',
    overview: _overview,
    standings: _standings,
    previousMatches: _previousMatches,
    upcomingMatches: _upcomingMatches,
    visiblePreviousMatches: 2,
    visibleUpcomingMatches: 1,
    coach: _coach,
    squadSections: _squadSections,
    trophies: _trophies,
    visibleTrophies: 4,
  );
}
