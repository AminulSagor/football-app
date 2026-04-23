import '../model/matches_models.dart';

class MatchesService {
  Future<MatchesSportScheduleUiModel> fetchSchedule(
    MatchesSchedulePayloadModel payload,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 260));

    final payloadJson = payload.toJson();
    final sportCode = payloadJson['sport_code'] as String? ?? '';

    if (sportCode != MatchesSportCodes.football) {
      final emptyResponse = <String, dynamic>{
        'sport_code': sportCode,
        'days': <Map<String, dynamic>>[],
      };
      return MatchesSportScheduleUiModel.fromJson(emptyResponse);
    }

    final responseJson = _footballResponseJson();
    return MatchesSportScheduleUiModel.fromJson(responseJson);
  }

  Map<String, dynamic> _footballResponseJson() {
    return <String, dynamic>{
      'sport_code': MatchesSportCodes.football,
      'days': <Map<String, dynamic>>[
        <String, dynamic>{
          'day_id': '2026-04-05',
          'day_label_code': MatchesDayLabelCodes.old,
          'display_date': 'Apr 05, 2026',
          'leagues': <Map<String, dynamic>>[
            <String, dynamic>{
              'league_id': 'champions-league',
              'league_name': 'CHAMPIONS LEAGUE',
              'stage_name': 'Knockout Stage',
              'badge_seed': 'UCL',
              'fixture_count': 2,
              'fixtures': <Map<String, dynamic>>[
                <String, dynamic>{
                  'fixture_id': 'old-ucl-1',
                  'home_team': <String, dynamic>{
                    'team_id': 'psg',
                    'team_name': 'Paris SG',
                    'short_name': 'PSG',
                    'badge_hex': '#2A3B86',
                  },
                  'away_team': <String, dynamic>{
                    'team_id': 'dortmund',
                    'team_name': 'Dortmund',
                    'short_name': 'BVB',
                    'badge_hex': '#C7A600',
                  },
                  'home_score': 0,
                  'away_score': 1,
                  'status_code': MatchesFixtureStatusCodes.finished,
                  'status_label': 'FT',
                  'status_detail': '',
                  'kickoff_order': 1900,
                  'visible_in_ongoing': false,
                },
                <String, dynamic>{
                  'fixture_id': 'old-ucl-2',
                  'home_team': <String, dynamic>{
                    'team_id': 'psg-2',
                    'team_name': 'Paris SG',
                    'short_name': 'PSG',
                    'badge_hex': '#2A3B86',
                  },
                  'away_team': <String, dynamic>{
                    'team_id': 'dortmund-2',
                    'team_name': 'Dortmund',
                    'short_name': 'BVB',
                    'badge_hex': '#C7A600',
                  },
                  'home_score': 0,
                  'away_score': 1,
                  'status_code': MatchesFixtureStatusCodes.finished,
                  'status_label': 'FT',
                  'status_detail': '',
                  'kickoff_order': 2100,
                  'visible_in_ongoing': false,
                },
              ],
            },
            <String, dynamic>{
              'league_id': 'europa-league',
              'league_name': 'EUROPA LEAGUE',
              'stage_name': 'Semi-Finals',
              'badge_seed': 'UEL',
              'fixture_count': 2,
              'fixtures': <Map<String, dynamic>>[
                <String, dynamic>{
                  'fixture_id': 'old-uel-1',
                  'home_team': <String, dynamic>{
                    'team_id': 'psg-3',
                    'team_name': 'Paris SG',
                    'short_name': 'PSG',
                    'badge_hex': '#2A3B86',
                  },
                  'away_team': <String, dynamic>{
                    'team_id': 'dortmund-3',
                    'team_name': 'Dortmund',
                    'short_name': 'BVB',
                    'badge_hex': '#C7A600',
                  },
                  'home_score': 0,
                  'away_score': 1,
                  'status_code': MatchesFixtureStatusCodes.finished,
                  'status_label': 'FT',
                  'status_detail': '',
                  'kickoff_order': 2000,
                  'visible_in_ongoing': false,
                },
                <String, dynamic>{
                  'fixture_id': 'old-uel-2',
                  'home_team': <String, dynamic>{
                    'team_id': 'psg-4',
                    'team_name': 'Paris SG',
                    'short_name': 'PSG',
                    'badge_hex': '#2A3B86',
                  },
                  'away_team': <String, dynamic>{
                    'team_id': 'dortmund-4',
                    'team_name': 'Dortmund',
                    'short_name': 'BVB',
                    'badge_hex': '#C7A600',
                  },
                  'home_score': 0,
                  'away_score': 1,
                  'status_code': MatchesFixtureStatusCodes.finished,
                  'status_label': 'FT',
                  'status_detail': '',
                  'kickoff_order': 2200,
                  'visible_in_ongoing': false,
                },
              ],
            },
          ],
        },
        <String, dynamic>{
          'day_id': '2026-04-18',
          'day_label_code': MatchesDayLabelCodes.today,
          'display_date': 'Apr 18, 2026',
          'leagues': <Map<String, dynamic>>[
            <String, dynamic>{
              'league_id': 'champions-league',
              'league_name': 'CHAMPIONS LEAGUE',
              'stage_name': 'Knockout Stage',
              'badge_seed': 'UCL',
              'fixture_count': 2,
              'fixtures': <Map<String, dynamic>>[
                <String, dynamic>{
                  'fixture_id': 'today-ucl-1',
                  'home_team': <String, dynamic>{
                    'team_id': 'real-madrid',
                    'team_name': 'Real Madrid',
                    'short_name': 'RMA',
                    'badge_hex': '#B89A4C',
                  },
                  'away_team': <String, dynamic>{
                    'team_id': 'bayern-munich',
                    'team_name': 'Bayern Munich',
                    'short_name': 'FCB',
                    'badge_hex': '#2E4CA0',
                  },
                  'home_score': 2,
                  'away_score': 1,
                  'status_code': MatchesFixtureStatusCodes.live,
                  'status_label': 'LIVE',
                  'status_detail': "78'",
                  'kickoff_order': 1900,
                  'visible_in_ongoing': true,
                },
                <String, dynamic>{
                  'fixture_id': 'today-ucl-2',
                  'home_team': <String, dynamic>{
                    'team_id': 'psg',
                    'team_name': 'Paris SG',
                    'short_name': 'PSG',
                    'badge_hex': '#2A3B86',
                  },
                  'away_team': <String, dynamic>{
                    'team_id': 'dortmund',
                    'team_name': 'Dortmund',
                    'short_name': 'BVB',
                    'badge_hex': '#C7A600',
                  },
                  'home_score': 0,
                  'away_score': 1,
                  'status_code': MatchesFixtureStatusCodes.finished,
                  'status_label': 'FT',
                  'status_detail': '',
                  'kickoff_order': 2100,
                  'visible_in_ongoing': true,
                },
              ],
            },
            <String, dynamic>{
              'league_id': 'europa-league',
              'league_name': 'EUROPA LEAGUE',
              'stage_name': 'Semi-Finals',
              'badge_seed': 'UEL',
              'fixture_count': 2,
              'fixtures': <Map<String, dynamic>>[
                <String, dynamic>{
                  'fixture_id': 'today-uel-1',
                  'home_team': <String, dynamic>{
                    'team_id': 'atalanta',
                    'team_name': 'Atalanta',
                    'short_name': 'ATA',
                    'badge_hex': '#294D93',
                  },
                  'away_team': <String, dynamic>{
                    'team_id': 'marseille',
                    'team_name': 'Marseille',
                    'short_name': 'OM',
                    'badge_hex': '#2C8ED3',
                  },
                  'home_score': 3,
                  'away_score': 0,
                  'status_code': MatchesFixtureStatusCodes.live,
                  'status_label': 'LIVE',
                  'status_detail': "85'",
                  'kickoff_order': 2000,
                  'visible_in_ongoing': true,
                },
                <String, dynamic>{
                  'fixture_id': 'today-uel-2',
                  'home_team': <String, dynamic>{
                    'team_id': 'leverkusen',
                    'team_name': 'B. Leverkusen',
                    'short_name': 'B04',
                    'badge_hex': '#8AB2C4',
                  },
                  'away_team': <String, dynamic>{
                    'team_id': 'roma',
                    'team_name': 'AS Roma',
                    'short_name': 'ROM',
                    'badge_hex': '#8C3D2D',
                  },
                  'home_score': null,
                  'away_score': null,
                  'status_code': MatchesFixtureStatusCodes.upcoming,
                  'status_label': '21:00',
                  'status_detail': '',
                  'kickoff_order': 2100,
                  'visible_in_ongoing': true,
                },
              ],
            },
            <String, dynamic>{
              'league_id': 'premier-league',
              'league_name': 'PREMIER LEAGUE',
              'stage_name': 'Matchday 38',
              'badge_seed': 'EPL',
              'fixture_count': 2,
              'fixtures': <Map<String, dynamic>>[
                <String, dynamic>{
                  'fixture_id': 'today-epl-1',
                  'home_team': <String, dynamic>{
                    'team_id': 'arsenal',
                    'team_name': 'Arsenal',
                    'short_name': 'ARS',
                    'badge_hex': '#AC3A3A',
                  },
                  'away_team': <String, dynamic>{
                    'team_id': 'liverpool',
                    'team_name': 'Liverpool',
                    'short_name': 'LIV',
                    'badge_hex': '#8D2F2F',
                  },
                  'home_score': null,
                  'away_score': null,
                  'status_code': MatchesFixtureStatusCodes.upcoming,
                  'status_label': '22:00',
                  'status_detail': '',
                  'kickoff_order': 2200,
                  'visible_in_ongoing': true,
                },
                <String, dynamic>{
                  'fixture_id': 'today-epl-2',
                  'home_team': <String, dynamic>{
                    'team_id': 'chelsea',
                    'team_name': 'Chelsea',
                    'short_name': 'CHE',
                    'badge_hex': '#2A4FB4',
                  },
                  'away_team': <String, dynamic>{
                    'team_id': 'tottenham',
                    'team_name': 'Tottenham',
                    'short_name': 'TOT',
                    'badge_hex': '#AAB7C2',
                  },
                  'home_score': null,
                  'away_score': null,
                  'status_code': MatchesFixtureStatusCodes.upcoming,
                  'status_label': '23:00',
                  'status_detail': '',
                  'kickoff_order': 2300,
                  'visible_in_ongoing': false,
                },
              ],
            },
          ],
        },
        <String, dynamic>{
          'day_id': '2026-04-19',
          'day_label_code': MatchesDayLabelCodes.tomorrow,
          'display_date': 'Apr 19, 2026',
          'leagues': <Map<String, dynamic>>[
            <String, dynamic>{
              'league_id': 'champions-league',
              'league_name': 'CHAMPIONS LEAGUE',
              'stage_name': 'Knockout Stage',
              'badge_seed': 'UCL',
              'fixture_count': 2,
              'fixtures': <Map<String, dynamic>>[
                <String, dynamic>{
                  'fixture_id': 'tomorrow-ucl-1',
                  'home_team': <String, dynamic>{
                    'team_id': 'inter',
                    'team_name': 'Inter Milan',
                    'short_name': 'INT',
                    'badge_hex': '#2E5A96',
                  },
                  'away_team': <String, dynamic>{
                    'team_id': 'city',
                    'team_name': 'Manchester City',
                    'short_name': 'MCI',
                    'badge_hex': '#69A9D8',
                  },
                  'home_score': null,
                  'away_score': null,
                  'status_code': MatchesFixtureStatusCodes.upcoming,
                  'status_label': '20:00',
                  'status_detail': '',
                  'kickoff_order': 2000,
                  'visible_in_ongoing': false,
                },
                <String, dynamic>{
                  'fixture_id': 'tomorrow-ucl-2',
                  'home_team': <String, dynamic>{
                    'team_id': 'barca',
                    'team_name': 'Barcelona',
                    'short_name': 'BAR',
                    'badge_hex': '#A23C4A',
                  },
                  'away_team': <String, dynamic>{
                    'team_id': 'juventus',
                    'team_name': 'Juventus',
                    'short_name': 'JUV',
                    'badge_hex': '#4A4A4A',
                  },
                  'home_score': null,
                  'away_score': null,
                  'status_code': MatchesFixtureStatusCodes.upcoming,
                  'status_label': '22:00',
                  'status_detail': '',
                  'kickoff_order': 2200,
                  'visible_in_ongoing': false,
                },
              ],
            },
            <String, dynamic>{
              'league_id': 'europa-league',
              'league_name': 'EUROPA LEAGUE',
              'stage_name': 'Semi-Finals',
              'badge_seed': 'UEL',
              'fixture_count': 2,
              'fixtures': <Map<String, dynamic>>[
                <String, dynamic>{
                  'fixture_id': 'tomorrow-uel-1',
                  'home_team': <String, dynamic>{
                    'team_id': 'sevilla',
                    'team_name': 'Sevilla',
                    'short_name': 'SEV',
                    'badge_hex': '#B24A4A',
                  },
                  'away_team': <String, dynamic>{
                    'team_id': 'porto',
                    'team_name': 'FC Porto',
                    'short_name': 'POR',
                    'badge_hex': '#2E5A9B',
                  },
                  'home_score': null,
                  'away_score': null,
                  'status_code': MatchesFixtureStatusCodes.upcoming,
                  'status_label': '18:30',
                  'status_detail': '',
                  'kickoff_order': 1830,
                  'visible_in_ongoing': false,
                },
                <String, dynamic>{
                  'fixture_id': 'tomorrow-uel-2',
                  'home_team': <String, dynamic>{
                    'team_id': 'villarreal',
                    'team_name': 'Villarreal',
                    'short_name': 'VIL',
                    'badge_hex': '#CBAA3D',
                  },
                  'away_team': <String, dynamic>{
                    'team_id': 'benfica',
                    'team_name': 'Benfica',
                    'short_name': 'BEN',
                    'badge_hex': '#9B2E2E',
                  },
                  'home_score': null,
                  'away_score': null,
                  'status_code': MatchesFixtureStatusCodes.upcoming,
                  'status_label': '20:45',
                  'status_detail': '',
                  'kickoff_order': 2045,
                  'visible_in_ongoing': false,
                },
              ],
            },
            <String, dynamic>{
              'league_id': 'premier-league',
              'league_name': 'PREMIER LEAGUE',
              'stage_name': 'Matchday 38',
              'badge_seed': 'EPL',
              'fixture_count': 2,
              'fixtures': <Map<String, dynamic>>[
                <String, dynamic>{
                  'fixture_id': 'tomorrow-epl-1',
                  'home_team': <String, dynamic>{
                    'team_id': 'newcastle',
                    'team_name': 'Newcastle',
                    'short_name': 'NEW',
                    'badge_hex': '#6A7C8A',
                  },
                  'away_team': <String, dynamic>{
                    'team_id': 'westham',
                    'team_name': 'West Ham',
                    'short_name': 'WHU',
                    'badge_hex': '#6A3F5C',
                  },
                  'home_score': null,
                  'away_score': null,
                  'status_code': MatchesFixtureStatusCodes.upcoming,
                  'status_label': '17:00',
                  'status_detail': '',
                  'kickoff_order': 1700,
                  'visible_in_ongoing': false,
                },
                <String, dynamic>{
                  'fixture_id': 'tomorrow-epl-2',
                  'home_team': <String, dynamic>{
                    'team_id': 'brighton',
                    'team_name': 'Brighton',
                    'short_name': 'BHA',
                    'badge_hex': '#3A74BC',
                  },
                  'away_team': <String, dynamic>{
                    'team_id': 'aston-villa',
                    'team_name': 'Aston Villa',
                    'short_name': 'AVL',
                    'badge_hex': '#6A6ABC',
                  },
                  'home_score': null,
                  'away_score': null,
                  'status_code': MatchesFixtureStatusCodes.upcoming,
                  'status_label': '19:30',
                  'status_detail': '',
                  'kickoff_order': 1930,
                  'visible_in_ongoing': false,
                },
              ],
            },
          ],
        },
      ],
    };
  }
}
