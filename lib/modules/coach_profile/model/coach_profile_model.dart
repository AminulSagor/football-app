import 'package:flutter/material.dart';

class CoachProfileApiBundleModel {
  final CoachProfileApiModel profile;
  final CoachRecordApiModel? record;
  final CoachTrophiesApiModel trophies;
  final bool isFollowing;

  const CoachProfileApiBundleModel({
    required this.profile,
    required this.record,
    required this.trophies,
    required this.isFollowing,
  });
}

class CoachProfileApiModel {
  final String id;
  final String name;
  final String firstName;
  final String lastName;
  final String age;
  final String birthDate;
  final String birthPlace;
  final String birthCountry;
  final String nationality;
  final String height;
  final String weight;
  final String photo;
  final String teamId;
  final String teamName;
  final String teamLogo;
  final List<CoachCareerApiModel> career;

  const CoachProfileApiModel({
    required this.id,
    required this.name,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.birthDate,
    required this.birthPlace,
    required this.birthCountry,
    required this.nationality,
    required this.height,
    required this.weight,
    required this.photo,
    required this.teamId,
    required this.teamName,
    required this.teamLogo,
    required this.career,
  });

  factory CoachProfileApiModel.fromCoachResponse(Map<String, dynamic> json) {
    final data = _readMap(json['data']) ?? json;
    final response = _readList(data['response']);

    final item = response.isNotEmpty
        ? _readMap(response.first) ?? <String, dynamic>{}
        : _readMap(data['coach']) ??
              _readMap(data['profile']) ??
              _readMap(data) ??
              <String, dynamic>{};

    final team = _readMap(item['team']) ?? <String, dynamic>{};
    final birth = _readMap(item['birth']) ?? <String, dynamic>{};
    final careerItems = _readList(item['career']);

    final firstName = _stringValue(item['firstname']);
    final lastName = _stringValue(item['lastname']);

    return CoachProfileApiModel(
      id: _stringValue(item['id']),
      name: _firstNonEmpty(<String>[
        _stringValue(item['name']),
        '$firstName $lastName'.trim(),
      ]),
      firstName: firstName,
      lastName: lastName,
      age: _stringValue(item['age']),
      birthDate: _stringValue(birth['date']),
      birthPlace: _stringValue(birth['place']),
      birthCountry: _firstNonEmpty(<String>[
        _stringValue(birth['country']),
        _stringValue(item['nationality']),
      ]),
      nationality: _stringValue(item['nationality']),
      height: _stringValue(item['height']),
      weight: _stringValue(item['weight']),
      photo: _stringValue(item['photo']),
      teamId: _stringValue(team['id']),
      teamName: _stringValue(team['name']),
      teamLogo: _stringValue(team['logo']),
      career: careerItems
          .map((item) => CoachCareerApiModel.fromJson(_readMap(item) ?? {}))
          .where((item) => item.teamName.trim().isNotEmpty)
          .toList(growable: false),
    );
  }
}

class CoachCareerApiModel {
  final String teamId;
  final String teamName;
  final String teamLogo;
  final String start;
  final String end;

  const CoachCareerApiModel({
    required this.teamId,
    required this.teamName,
    required this.teamLogo,
    required this.start,
    required this.end,
  });

  factory CoachCareerApiModel.fromJson(Map<String, dynamic> json) {
    final team = _readMap(json['team']) ?? <String, dynamic>{};

    return CoachCareerApiModel(
      teamId: _stringValue(team['id']),
      teamName: _stringValue(team['name']),
      teamLogo: _stringValue(team['logo']),
      start: _stringValue(json['start']),
      end: _stringValue(json['end']),
    );
  }
}

class CoachRecordApiModel {
  final int matches;
  final int wins;
  final int draws;
  final int losses;

  const CoachRecordApiModel({
    required this.matches,
    required this.wins,
    required this.draws,
    required this.losses,
  });

  factory CoachRecordApiModel.fromJson(Map<String, dynamic> json) {
    final data = _readMap(json['data']) ?? json;
    final record =
        _readMap(data['record']) ??
        _readMap(data['currentRecord']) ??
        _readMap(data['current_record']) ??
        data;

    final wins = _intValue(_firstExisting(record, const ['wins', 'win', 'w']));
    final draws = _intValue(
      _firstExisting(record, const ['draws', 'draw', 'd']),
    );
    final losses = _intValue(
      _firstExisting(record, const ['losses', 'loses', 'loss', 'l']),
    );

    final explicitMatchesSource = _firstExisting(record, const [
      'matches',
      'played',
      'total',
      'totalMatches',
      'total_matches',
    ]);

    final explicitMatches = _intValue(explicitMatchesSource);
    final calculatedMatches = wins + draws + losses;

    return CoachRecordApiModel(
      matches: explicitMatchesSource == null
          ? calculatedMatches
          : explicitMatches,
      wins: wins,
      draws: draws,
      losses: losses,
    );
  }
}

class CoachTrophiesApiModel {
  final List<CoachTrophyApiModel> items;

  const CoachTrophiesApiModel({this.items = const <CoachTrophyApiModel>[]});

  factory CoachTrophiesApiModel.fromJson(Map<String, dynamic> json) {
    final data = _readMap(json['data']) ?? json;

    final groups = _firstList(data, const [
      'items',
      'groups',
      'grouped',
      'response',
      'trophies',
      'data',
    ]);

    final flattened = <Map<String, dynamic>>[];

    for (final groupItem in groups) {
      final groupMap = _readMap(groupItem);
      if (groupMap == null) {
        continue;
      }

      final groupTitle = _stringValue(groupMap['group']);
      final trophies = _firstList(groupMap, const [
        'trophies',
        'items',
        'results',
        'seasons',
      ]);

      if (trophies.isEmpty) {
        flattened.add(groupMap);
        continue;
      }

      for (final trophyItem in trophies) {
        final trophyMap = _readMap(trophyItem);
        if (trophyMap == null) {
          continue;
        }

        flattened.add(<String, dynamic>{'group': groupTitle, ...trophyMap});
      }
    }

    return CoachTrophiesApiModel(
      items: flattened
          .map(CoachTrophyApiModel.fromJson)
          .where((item) => item.title.trim().isNotEmpty)
          .toList(growable: false),
    );
  }
}

class CoachTrophyApiModel {
  final String title;
  final String country;
  final String season;
  final String result;
  final String logo;

  const CoachTrophyApiModel({
    required this.title,
    required this.country,
    required this.season,
    required this.result,
    required this.logo,
  });

  factory CoachTrophyApiModel.fromJson(Map<String, dynamic> json) {
    final league =
        _readMap(json['leagueData']) ??
        _readMap(json['leagueInfo']) ??
        _readMap(json['league']) ??
        <String, dynamic>{};

    return CoachTrophyApiModel(
      title: _firstNonEmpty(<String>[
        _stringValue(json['league']),
        _stringValue(json['group']),
        _stringValue(json['title']),
        _stringValue(json['name']),
        _stringValue(league['name']),
      ]),
      country: _firstNonEmpty(<String>[
        _stringValue(json['country']),
        _stringValue(league['country']),
      ]),
      season: _stringValue(json['season']),
      result: _firstNonEmpty(<String>[
        _stringValue(json['place']),
        _stringValue(json['result']),
        _stringValue(json['position']),
      ]),
      logo: _firstNonEmpty(<String>[
        _stringValue(json['logo']),
        _stringValue(json['leagueLogo']),
        _stringValue(json['league_logo']),
        _stringValue(league['logo']),
      ]),
    );
  }
}

class CoachProfileFactUiModel {
  final String value;
  final String label;
  final bool highlighted;

  const CoachProfileFactUiModel({
    required this.value,
    required this.label,
    this.highlighted = false,
  });
}

class CoachProfileRecordUiModel {
  final String title;
  final String value;
  final double progress;
  final Color color;

  const CoachProfileRecordUiModel({
    required this.title,
    required this.value,
    required this.progress,
    required this.color,
  });
}

class CoachCareerItemUiModel {
  final String title;
  final String rangeLabel;
  final String seed;
  final String logo;

  const CoachCareerItemUiModel({
    required this.title,
    required this.rangeLabel,
    required this.seed,
    this.logo = '',
  });
}

class CoachProfileTrophyUiModel {
  final String title;
  final String country;
  final String season;
  final String result;
  final String seed;
  final String logo;

  const CoachProfileTrophyUiModel({
    required this.title,
    required this.country,
    required this.season,
    required this.result,
    required this.seed,
    this.logo = '',
  });
}

class CoachProfileViewModel {
  final String id;
  final String coachName;
  final String teamId;
  final String teamName;
  final String teamLogo;
  final String avatarSeed;
  final String photo;
  final bool isFollowing;
  final bool isLoading;
  final String? errorCode;
  final List<CoachProfileFactUiModel> facts;
  final String matches;
  final String currentClub;
  final String currentClubSeed;
  final List<CoachProfileRecordUiModel> records;
  final List<CoachProfileTrophyUiModel> trophies;
  final List<CoachCareerItemUiModel> careerItems;

  const CoachProfileViewModel({
    required this.id,
    required this.coachName,
    required this.teamName,
    required this.avatarSeed,
    this.teamId = '',
    this.teamLogo = '',
    this.photo = '',
    this.isFollowing = false,
    this.isLoading = false,
    this.errorCode,
    this.facts = const <CoachProfileFactUiModel>[
      CoachProfileFactUiModel(value: '-', label: 'Country', highlighted: true),
      CoachProfileFactUiModel(value: '-', label: 'Birth date'),
    ],
    this.matches = '0',
    this.currentClub = '-',
    this.currentClubSeed = '-',
    this.records = const <CoachProfileRecordUiModel>[
      CoachProfileRecordUiModel(
        title: 'Wins',
        value: '0',
        progress: 0,
        color: Color(0xFF39E0B3),
      ),
      CoachProfileRecordUiModel(
        title: 'Draw',
        value: '0',
        progress: 0,
        color: Color(0xFF39E0B3),
      ),
      CoachProfileRecordUiModel(
        title: 'Losses',
        value: '0',
        progress: 0,
        color: Color(0xFFFF6B6B),
      ),
    ],
    this.trophies = const <CoachProfileTrophyUiModel>[],
    this.careerItems = const <CoachCareerItemUiModel>[],
  });

  factory CoachProfileViewModel.initial() {
    return const CoachProfileViewModel(
      id: '',
      coachName: 'Coach',
      teamName: '-',
      avatarSeed: 'CO',
      currentClub: '-',
      currentClubSeed: '-',
      isLoading: true,
    );
  }

  factory CoachProfileViewModel.fromApiBundle(
    CoachProfileApiBundleModel bundle,
  ) {
    final profile = bundle.profile;
    final record = bundle.record;

    final matches = record?.matches ?? 0;
    final wins = record?.wins ?? 0;
    final draws = record?.draws ?? 0;
    final losses = record?.losses ?? 0;

    final currentClub = profile.teamName.isNotEmpty ? profile.teamName : '-';

    return CoachProfileViewModel(
      id: profile.id,
      coachName: profile.name.isNotEmpty ? profile.name : 'Coach',
      teamId: profile.teamId,
      teamName: profile.teamName.isNotEmpty ? profile.teamName : '-',
      teamLogo: profile.teamLogo,
      avatarSeed: _seedFrom(profile.name),
      photo: profile.photo,
      isFollowing: bundle.isFollowing,
      facts: <CoachProfileFactUiModel>[
        CoachProfileFactUiModel(
          value: _firstNonEmpty(<String>[
            profile.nationality,
            profile.birthCountry,
            '-',
          ]),
          label: 'Country',
          highlighted: true,
        ),
        CoachProfileFactUiModel(
          value: profile.age.isNotEmpty ? '${profile.age} years' : '-',
          label: profile.birthDate.isNotEmpty
              ? _formatDateLabel(profile.birthDate)
              : 'Birth date',
        ),
      ],
      matches: matches.toString(),
      currentClub: currentClub,
      currentClubSeed: _seedFrom(currentClub),
      records: <CoachProfileRecordUiModel>[
        CoachProfileRecordUiModel(
          title: 'Wins',
          value: wins.toString(),
          progress: _progress(wins, matches),
          color: const Color(0xFF39E0B3),
        ),
        CoachProfileRecordUiModel(
          title: 'Draw',
          value: draws.toString(),
          progress: _progress(draws, matches),
          color: const Color(0xFF39E0B3),
        ),
        CoachProfileRecordUiModel(
          title: 'Losses',
          value: losses.toString(),
          progress: _progress(losses, matches),
          color: const Color(0xFFFF6B6B),
        ),
      ],
      trophies: bundle.trophies.items
          .map(
            (item) => CoachProfileTrophyUiModel(
              title: item.title,
              country: item.country.isNotEmpty ? item.country : '-',
              season: item.season.isNotEmpty ? item.season : '-',
              result: item.result.isNotEmpty ? item.result : '-',
              seed: _seedFrom(item.title),
              logo: item.logo,
            ),
          )
          .toList(growable: false),
      careerItems: profile.career
          .map(
            (item) => CoachCareerItemUiModel(
              title: item.teamName,
              rangeLabel: _formatCareerRange(item.start, item.end),
              seed: _seedFrom(item.teamName),
              logo: item.teamLogo,
            ),
          )
          .toList(growable: false),
    );
  }

  CoachProfileViewModel copyWith({
    String? id,
    String? coachName,
    String? teamId,
    String? teamName,
    String? teamLogo,
    String? avatarSeed,
    String? photo,
    bool? isFollowing,
    bool? isLoading,
    Object? errorCode = _unset,
    List<CoachProfileFactUiModel>? facts,
    String? matches,
    String? currentClub,
    String? currentClubSeed,
    List<CoachProfileRecordUiModel>? records,
    List<CoachProfileTrophyUiModel>? trophies,
    List<CoachCareerItemUiModel>? careerItems,
  }) {
    return CoachProfileViewModel(
      id: id ?? this.id,
      coachName: coachName ?? this.coachName,
      teamId: teamId ?? this.teamId,
      teamName: teamName ?? this.teamName,
      teamLogo: teamLogo ?? this.teamLogo,
      avatarSeed: avatarSeed ?? this.avatarSeed,
      photo: photo ?? this.photo,
      isFollowing: isFollowing ?? this.isFollowing,
      isLoading: isLoading ?? this.isLoading,
      errorCode: identical(errorCode, _unset)
          ? this.errorCode
          : errorCode as String?,
      facts: facts ?? this.facts,
      matches: matches ?? this.matches,
      currentClub: currentClub ?? this.currentClub,
      currentClubSeed: currentClubSeed ?? this.currentClubSeed,
      records: records ?? this.records,
      trophies: trophies ?? this.trophies,
      careerItems: careerItems ?? this.careerItems,
    );
  }

  static const Object _unset = Object();
}

double _progress(int value, int total) {
  if (value <= 0 || total <= 0) {
    return 0;
  }

  final result = value / total;

  if (result < 0) {
    return 0;
  }

  if (result > 1) {
    return 1;
  }

  return result;
}

String _formatCareerRange(String start, String end) {
  final startLabel = _formatMonthYear(start);
  final endLabel = end.trim().isEmpty ? 'NOW' : _formatMonthYear(end);
  return '$startLabel - $endLabel';
}

String _formatDateLabel(String value) {
  final parts = value.split('-');
  if (parts.length != 3) {
    return value;
  }

  final year = parts[0];
  final month = int.tryParse(parts[1]) ?? 0;
  final day = int.tryParse(parts[2]) ?? 0;

  if (month < 1 || month > 12 || day < 1) {
    return value;
  }

  return '${_monthNames[month - 1]} $day, $year';
}

String _formatMonthYear(String value) {
  final parts = value.split('-');
  if (parts.length < 2) {
    return value.trim().isEmpty ? '-' : value.toUpperCase();
  }

  final year = parts[0];
  final month = int.tryParse(parts[1]) ?? 0;

  if (month < 1 || month > 12) {
    return value.toUpperCase();
  }

  return '${_monthNames[month - 1].toUpperCase()} $year';
}

String _seedFrom(String value) {
  final words = value
      .trim()
      .split(RegExp(r'\s+'))
      .where((item) => item.trim().isNotEmpty)
      .toList();

  if (words.isEmpty) {
    return '-';
  }

  if (words.length == 1) {
    final word = words.first;
    return word.substring(0, word.length >= 2 ? 2 : 1).toUpperCase();
  }

  return '${words.first[0]}${words.last[0]}'.toUpperCase();
}

Object? _firstExisting(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    if (json.containsKey(key)) {
      return json[key];
    }
  }

  return null;
}

List<dynamic> _firstList(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    final list = _readList(value);
    if (list.isNotEmpty) {
      return list;
    }
  }

  return const <dynamic>[];
}

String _firstNonEmpty(List<String> values) {
  for (final value in values) {
    final clean = value.trim();
    if (clean.isNotEmpty) {
      return clean;
    }
  }

  return '';
}

String _stringValue(Object? value) {
  if (value == null) {
    return '';
  }

  return value.toString().trim();
}

int _intValue(Object? value) {
  if (value is int) {
    return value;
  }

  if (value is double) {
    return value.round();
  }

  if (value is String) {
    return int.tryParse(value.trim()) ?? 0;
  }

  return 0;
}

Map<String, dynamic>? _readMap(Object? value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }

  return null;
}

List<dynamic> _readList(Object? value) {
  if (value is List) {
    return value;
  }

  return const <dynamic>[];
}

const List<String> _monthNames = <String>[
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];
