import 'package:dio/dio.dart' as dio;

import '../../../core/services/api_client.dart';
import '../model/coach_profile_model.dart';

class CoachServices {
  final ApiClient _apiClient;

  CoachServices({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<CoachProfileApiBundleModel> fetchCoachProfile({
    required String coachId,
    String? teamId,
    String? fromDate,
    String? toDate,
    int trophiesPage = 1,
    int trophiesLimit = 20,
  }) async {
    final coachResponse = await _apiClient.get<Map<String, dynamic>>(
      '/football/coaches',
      queryParameters: <String, dynamic>{'id': coachId},
      options: dio.Options(
        headers: const <String, dynamic>{'Content-Type': 'application/json'},
      ),
    );

    final coachData = _requireSuccess(
      coachResponse.data,
      fallbackErrorCode: 'coach_profile_fetch_failed',
    );

    final profile = CoachProfileApiModel.fromCoachResponse(coachData);

    final resolvedCoachId = profile.id.isNotEmpty ? profile.id : coachId;
    final resolvedTeamId = _resolveTeamId(teamId, profile.teamId);

    final resolvedFromDate = _resolveCareerDate(
      preferredDate: fromDate,
      profile: profile,
      teamId: resolvedTeamId,
      useStartDate: true,
    );

    final resolvedToDate = _resolveCareerDate(
      preferredDate: toDate,
      profile: profile,
      teamId: resolvedTeamId,
      useStartDate: false,
    );

    final record = await _safeFetchCurrentRecord(
      coachId: resolvedCoachId,
      teamId: resolvedTeamId,
      fromDate: resolvedFromDate,
      toDate: resolvedToDate,
    );

    final trophies = await _safeFetchGroupedTrophies(
      coachId: resolvedCoachId,
      page: trophiesPage,
      limit: trophiesLimit,
    );

    return CoachProfileApiBundleModel(
      profile: profile,
      record: record,
      trophies: trophies,
      isFollowing: _readFollowStatus(coachData) ?? false,
    );
  }

  Future<CoachProfileApiBundleModel> fetchCoachByTeam({
    required String teamId,
    String? fromDate,
    String? toDate,
    int trophiesPage = 1,
    int trophiesLimit = 20,
  }) async {
    final coachResponse = await _apiClient.get<Map<String, dynamic>>(
      '/football/coaches',
      queryParameters: <String, dynamic>{'team': teamId},
      options: dio.Options(
        headers: const <String, dynamic>{'Content-Type': 'application/json'},
      ),
    );

    final coachData = _requireSuccess(
      coachResponse.data,
      fallbackErrorCode: 'coach_by_team_fetch_failed',
    );

    final profile = CoachProfileApiModel.fromCoachResponse(coachData);
    final resolvedCoachId = profile.id;

    final resolvedFromDate = _resolveCareerDate(
      preferredDate: fromDate,
      profile: profile,
      teamId: teamId,
      useStartDate: true,
    );

    final resolvedToDate = _resolveCareerDate(
      preferredDate: toDate,
      profile: profile,
      teamId: teamId,
      useStartDate: false,
    );

    final record = await _safeFetchCurrentRecord(
      coachId: resolvedCoachId,
      teamId: teamId,
      fromDate: resolvedFromDate,
      toDate: resolvedToDate,
    );

    final trophies = await _safeFetchGroupedTrophies(
      coachId: resolvedCoachId,
      page: trophiesPage,
      limit: trophiesLimit,
    );

    return CoachProfileApiBundleModel(
      profile: profile,
      record: record,
      trophies: trophies,
      isFollowing: _readFollowStatus(coachData) ?? false,
    );
  }

  Future<CoachRecordApiModel?> _safeFetchCurrentRecord({
    required String coachId,
    required String teamId,
    String? fromDate,
    String? toDate,
  }) async {
    if (coachId.trim().isEmpty || teamId.trim().isEmpty) {
      return null;
    }

    try {
      return await fetchCurrentRecord(
        coachId: coachId,
        teamId: teamId,
        fromDate: fromDate,
        toDate: toDate,
      );
    } catch (_) {
      return null;
    }
  }

  Future<CoachTrophiesApiModel> _safeFetchGroupedTrophies({
    required String coachId,
    int page = 1,
    int limit = 20,
  }) async {
    if (coachId.trim().isEmpty) {
      return const CoachTrophiesApiModel();
    }

    try {
      return await fetchGroupedTrophies(
        coachId: coachId,
        page: page,
        limit: limit,
      );
    } catch (_) {
      return const CoachTrophiesApiModel();
    }
  }

  Future<CoachRecordApiModel> fetchCurrentRecord({
    required String coachId,
    required String teamId,
    String? fromDate,
    String? toDate,
  }) async {
    final query = <String, dynamic>{'team': teamId};

    if (fromDate != null && fromDate.trim().isNotEmpty) {
      query['from'] = fromDate.trim();
    }

    if (toDate != null && toDate.trim().isNotEmpty) {
      query['to'] = toDate.trim();
    }

    final response = await _apiClient.get<Map<String, dynamic>>(
      '/football/coaches/$coachId/current-record',
      queryParameters: query,
      options: dio.Options(
        headers: const <String, dynamic>{'Content-Type': 'application/json'},
      ),
    );

    final data = _requireSuccess(
      response.data,
      fallbackErrorCode: 'coach_current_record_fetch_failed',
    );

    return CoachRecordApiModel.fromJson(_readDataMap(data));
  }

  Future<CoachTrophiesApiModel> fetchGroupedTrophies({
    required String coachId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/football/coaches/$coachId/trophies/grouped',
        queryParameters: <String, dynamic>{'page': page, 'limit': limit},
        options: dio.Options(
          headers: const <String, dynamic>{'Content-Type': 'application/json'},
        ),
      );

      final data = _requireSuccess(
        response.data,
        fallbackErrorCode: 'coach_grouped_trophies_fetch_failed',
      );

      return CoachTrophiesApiModel.fromJson(_readDataMap(data));
    } catch (_) {
      return await fetchRawTrophiesByCoach(
        coachId: coachId,
        page: page,
        limit: limit,
      );
    }
  }

  Future<CoachTrophiesApiModel> fetchRawTrophiesByCoach({
    required String coachId,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/football/trophies',
      queryParameters: <String, dynamic>{
        'coach': coachId,
        'page': page,
        'limit': limit,
      },
      options: dio.Options(
        headers: const <String, dynamic>{'Content-Type': 'application/json'},
      ),
    );

    final data = _requireSuccess(
      response.data,
      fallbackErrorCode: 'coach_trophies_fetch_failed',
    );

    return CoachTrophiesApiModel.fromJson(_readDataMap(data));
  }

  String _resolveTeamId(String? preferredTeamId, String fallbackTeamId) {
    final cleanPreferred = preferredTeamId?.trim() ?? '';
    if (cleanPreferred.isNotEmpty) {
      return cleanPreferred;
    }
    return fallbackTeamId.trim();
  }

  String? _resolveCareerDate({
    required String? preferredDate,
    required CoachProfileApiModel profile,
    required String teamId,
    required bool useStartDate,
  }) {
    final cleanPreferredDate = preferredDate?.trim() ?? '';
    if (cleanPreferredDate.isNotEmpty) {
      return cleanPreferredDate;
    }

    final careerItem = _findCareerItem(profile: profile, teamId: teamId);
    if (careerItem == null) {
      return null;
    }

    final date = useStartDate ? careerItem.start : careerItem.end;
    final cleanDate = date.trim();

    if (cleanDate.isEmpty) {
      return null;
    }

    return cleanDate;
  }

  CoachCareerApiModel? _findCareerItem({
    required CoachProfileApiModel profile,
    required String teamId,
  }) {
    final cleanTeamId = teamId.trim();

    for (final item in profile.career) {
      if (item.teamId == cleanTeamId) {
        return item;
      }
    }

    if (profile.career.isNotEmpty) {
      return profile.career.first;
    }

    return null;
  }

  bool? _readFollowStatus(Map<String, dynamic> responseData) {
    final data = _readDataMap(responseData);
    final follow = data['follow'];

    if (follow is Map) {
      final isFollowed = follow['isFollowed'];
      if (isFollowed is bool) {
        return isFollowed;
      }
    }

    return null;
  }

  Map<String, dynamic> _requireSuccess(
    Map<String, dynamic>? responseData, {
    required String fallbackErrorCode,
  }) {
    if (responseData == null) {
      throw Exception('empty_response');
    }

    final success = responseData['success'];
    if (success is bool && !success) {
      final message = responseData['message'];
      if (message is String && message.trim().isNotEmpty) {
        throw Exception(message.trim());
      }
      throw Exception(fallbackErrorCode);
    }

    return responseData;
  }

  Map<String, dynamic> _readDataMap(Map<String, dynamic> responseData) {
    final data = responseData['data'];
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return responseData;
  }
}
