import 'leagues_models.dart';

class LeaguesService {
  Future<LeaguesFeedUiModel> fetchLeagues(
    LeaguesFeedPayloadModel payload,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 260));

    final payloadJson = payload.toJson();
    final sportCode = payloadJson['sport_code'] as String? ?? '';

    if (sportCode != LeaguesSportCodes.football) {
      return LeaguesFeedUiModel.fromJson(<String, dynamic>{
        'sport_code': sportCode,
        'top_leagues': <Map<String, dynamic>>[],
        'countries': <Map<String, dynamic>>[],
      });
    }

    return LeaguesFeedUiModel.fromJson(_footballLeaguesResponseJson());
  }

  Map<String, dynamic> _footballLeaguesResponseJson() {
    return <String, dynamic>{
      'sport_code': LeaguesSportCodes.football,
      'top_leagues': <Map<String, dynamic>>[
        <String, dynamic>{
          'league_id': 'premier-league',
          'league_name': 'Premier League',
          'badge_seed': 'EPL',
          'badge_hex': '#293F80',
        },
        <String, dynamic>{
          'league_id': 'laliga',
          'league_name': 'LaLiga',
          'badge_seed': 'LL',
          'badge_hex': '#C83A2E',
        },
        <String, dynamic>{
          'league_id': 'serie-a',
          'league_name': 'Serie A',
          'badge_seed': 'SA',
          'badge_hex': '#1D4F9B',
        },
        <String, dynamic>{
          'league_id': 'champions-league',
          'league_name': 'Champions League',
          'badge_seed': 'UCL',
          'badge_hex': '#1C2A5F',
        },
        <String, dynamic>{
          'league_id': 'bundesliga',
          'league_name': 'Bundesliga',
          'badge_seed': 'BL',
          'badge_hex': '#A52222',
        },
      ],
      'countries': <Map<String, dynamic>>[
        <String, dynamic>{
          'country_id': 'international',
          'country_name': 'International',
          'flag_seed': 'GLB',
          'flag_hex': '#0D8662',
          'is_expanded_by_default': true,
          'competitions': <Map<String, dynamic>>[
            <String, dynamic>{
              'competition_id': 'world-cup',
              'title': 'World Cup',
              'badge_seed': 'W',
              'badge_hex': '#4C565D',
            },
            <String, dynamic>{
              'competition_id': 'euro-championship',
              'title': 'European Championship',
              'badge_seed': 'EC',
              'badge_hex': '#4C565D',
            },
          ],
        },
        <String, dynamic>{
          'country_id': 'albania',
          'country_name': 'Albania',
          'flag_seed': 'AL',
          'flag_hex': '#D32C36',
          'is_expanded_by_default': false,
          'competitions': <Map<String, dynamic>>[
            <String, dynamic>{
              'competition_id': 'kategoria-superiore',
              'title': 'Kategoria Superiore',
              'badge_seed': 'KS',
              'badge_hex': '#A72027',
            },
          ],
        },
        <String, dynamic>{
          'country_id': 'algeria',
          'country_name': 'Algeria',
          'flag_seed': 'DZ',
          'flag_hex': '#2EA760',
          'is_expanded_by_default': false,
          'competitions': <Map<String, dynamic>>[
            <String, dynamic>{
              'competition_id': 'ligue-1-algeria',
              'title': 'Ligue 1',
              'badge_seed': 'L1',
              'badge_hex': '#267A4A',
            },
          ],
        },
        <String, dynamic>{
          'country_id': 'argentina',
          'country_name': 'Argentina',
          'flag_seed': 'AR',
          'flag_hex': '#4EA6E8',
          'is_expanded_by_default': false,
          'competitions': <Map<String, dynamic>>[
            <String, dynamic>{
              'competition_id': 'primera-division',
              'title': 'Primera Division',
              'badge_seed': 'PD',
              'badge_hex': '#357BB4',
            },
          ],
        },
        <String, dynamic>{
          'country_id': 'australia',
          'country_name': 'Australia',
          'flag_seed': 'AU',
          'flag_hex': '#284FA2',
          'is_expanded_by_default': false,
          'competitions': <Map<String, dynamic>>[
            <String, dynamic>{
              'competition_id': 'a-league-men',
              'title': 'A-League Men',
              'badge_seed': 'AL',
              'badge_hex': '#1F4189',
            },
          ],
        },
        <String, dynamic>{
          'country_id': 'austria',
          'country_name': 'Austria',
          'flag_seed': 'AT',
          'flag_hex': '#CF3835',
          'is_expanded_by_default': false,
          'competitions': <Map<String, dynamic>>[
            <String, dynamic>{
              'competition_id': 'austrian-bundesliga',
              'title': 'Bundesliga',
              'badge_seed': 'BL',
              'badge_hex': '#AC2C2B',
            },
          ],
        },
        <String, dynamic>{
          'country_id': 'belgium',
          'country_name': 'Belgium',
          'flag_seed': 'BE',
          'flag_hex': '#222222',
          'is_expanded_by_default': false,
          'competitions': <Map<String, dynamic>>[
            <String, dynamic>{
              'competition_id': 'pro-league',
              'title': 'Pro League',
              'badge_seed': 'PL',
              'badge_hex': '#4D4D4D',
            },
          ],
        },
        <String, dynamic>{
          'country_id': 'brazil',
          'country_name': 'Brazil',
          'flag_seed': 'BR',
          'flag_hex': '#2F9F44',
          'is_expanded_by_default': false,
          'competitions': <Map<String, dynamic>>[
            <String, dynamic>{
              'competition_id': 'serie-a-brazil',
              'title': 'Serie A',
              'badge_seed': 'SA',
              'badge_hex': '#2B7F3A',
            },
          ],
        },
      ],
    };
  }
}
