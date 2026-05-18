import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:firebase_app_installations/firebase_app_installations.dart';

import '../models/following_models.dart';
import 'api_client.dart';
import 'storage_service.dart';

class FollowingService extends GetxService {
  final ApiClient _apiClient;
  final StorageService _storageService;
  final FirebaseInstallations _installations;

  FollowingService({
    required ApiClient apiClient,
    required StorageService storageService,
    FirebaseInstallations? installations,
  }) : _apiClient = apiClient,
       _storageService = storageService,
       _installations = installations ?? FirebaseInstallations.instance;

  final RxInt revision = 0.obs;

  final Map<FollowEntityType, Set<String>> _followedIds =
      <FollowEntityType, Set<String>>{
        FollowEntityType.league: <String>{
          'premier-league',
          'laliga',
          'serie-a',
          'champions-league',
          'bundesliga',
        },
        FollowEntityType.player: <String>{'cristiano-ronaldo'},
        FollowEntityType.team: <String>{'bangladesh', 'arsenal', 'al-nassr'},
        FollowEntityType.coach: <String>{'diego-simeone'},
        FollowEntityType.match: <String>{'barcelona-vs-atletico'},
      };

  bool isFollowing(FollowEntityType type, String id) {
    return _followedIds[type]?.contains(id) ?? false;
  }

  Future<FollowingActionUiModel> follow(
    FollowEntityPayloadModel payload,
  ) async {
    final resolvedPayload = await _resolveFollowPayload(payload);

    final response = await _apiClient.post<Map<String, dynamic>>(
      '/follows',
      data: resolvedPayload.toJson(),
      options: dio.Options(
        headers: const <String, dynamic>{'Content-Type': 'application/json'},
        extra: _buildAuthExtras(),
      ),
    );

    _trackFollowing(resolvedPayload.entityType, resolvedPayload.entityId, true);
    return FollowingActionUiModel.fromJson(_requireResponseMap(response.data));
  }

  Future<FollowingActionUiModel> unfollow(UnfollowPayloadModel payload) async {
    final resolvedPayload = await _resolveUnfollowPayload(payload);

    final response = await _apiClient.delete<Map<String, dynamic>>(
      '/follows/${resolvedPayload.entityType.apiValue}/${resolvedPayload.entityId}',
      queryParameters: resolvedPayload.toQuery(),
      options: dio.Options(extra: _buildAuthExtras()),
    );

    _trackFollowing(
      resolvedPayload.entityType,
      resolvedPayload.entityId,
      false,
    );
    return FollowingActionUiModel.fromJson(_requireResponseMap(response.data));
  }

  Future<FollowingListUiModel> fetchFollows(
    FollowListPayloadModel payload,
  ) async {
    final resolvedPayload = await _resolveListPayload(payload);

    final response = await _apiClient.get<Map<String, dynamic>>(
      '/follows',
      queryParameters: resolvedPayload.toQuery(),
      options: dio.Options(extra: _buildAuthExtras()),
    );

    return FollowingListUiModel.fromJson(_requireResponseMap(response.data));
  }

  Future<FollowStatusUiModel> fetchStatus(
    FollowStatusPayloadModel payload,
  ) async {
    final resolvedPayload = await _resolveStatusPayload(payload);

    final response = await _apiClient.get<Map<String, dynamic>>(
      '/follows/status',
      queryParameters: resolvedPayload.toQuery(),
      options: dio.Options(extra: _buildAuthExtras()),
    );

    return FollowStatusUiModel.fromJson(_requireResponseMap(response.data));
  }

  Future<MergeAnonymousFollowsUiModel> mergeAnonymousFollows(
    MergeAnonymousFollowsPayloadModel payload,
  ) async {
    final resolvedPayload = await _resolveMergePayload(payload);

    final response = await _apiClient.post<Map<String, dynamic>>(
      '/follows/merge-anonymous',
      data: resolvedPayload.toJson(),
      options: dio.Options(
        headers: const <String, dynamic>{'Content-Type': 'application/json'},
      ),
    );

    return MergeAnonymousFollowsUiModel.fromJson(
      _requireResponseMap(response.data),
    );
  }

  Map<String, dynamic> _buildAuthExtras() {
    if (_storageService.isLoggedIn) {
      return const <String, dynamic>{};
    }
    return const <String, dynamic>{'skipAuth': true};
  }

  Future<FollowEntityPayloadModel> _resolveFollowPayload(
    FollowEntityPayloadModel payload,
  ) async {
    final installationId = await _resolveInstallationId(payload.installationId);
    if (installationId == null) {
      return payload;
    }
    return payload.copyWith(installationId: installationId);
  }

  Future<UnfollowPayloadModel> _resolveUnfollowPayload(
    UnfollowPayloadModel payload,
  ) async {
    final installationId = await _resolveInstallationId(payload.installationId);
    if (installationId == null) {
      return payload;
    }
    return payload.copyWith(installationId: installationId);
  }

  Future<FollowListPayloadModel> _resolveListPayload(
    FollowListPayloadModel payload,
  ) async {
    final installationId = await _resolveInstallationId(payload.installationId);
    if (installationId == null) {
      return payload;
    }
    return payload.copyWith(installationId: installationId);
  }

  Future<FollowStatusPayloadModel> _resolveStatusPayload(
    FollowStatusPayloadModel payload,
  ) async {
    final installationId = await _resolveInstallationId(payload.installationId);
    if (installationId == null) {
      return payload;
    }
    return payload.copyWith(installationId: installationId);
  }

  Future<MergeAnonymousFollowsPayloadModel> _resolveMergePayload(
    MergeAnonymousFollowsPayloadModel payload,
  ) async {
    final installationId = await _resolveInstallationId(
      payload.installationId,
      allowLoggedIn: true,
    );
    if (installationId == null) {
      return payload;
    }
    return payload.copyWith(installationId: installationId);
  }

  Future<String?> _resolveInstallationId(
    String? installationId, {
    bool allowLoggedIn = false,
  }) async {
    if (_storageService.isLoggedIn && !allowLoggedIn) {
      return null;
    }
    if (installationId != null && installationId.trim().isNotEmpty) {
      return installationId;
    }
    return _installations.getId();
  }

  Map<String, dynamic> _requireResponseMap(Map<String, dynamic>? data) {
    if (data == null) {
      throw Exception('empty_response');
    }
    return data;
  }

  void _trackFollowing(FollowEntityType type, String id, bool shouldFollow) {
    final set = _followedIds.putIfAbsent(type, () => <String>{});
    final didChange = shouldFollow ? set.add(id) : set.remove(id);
    if (didChange) {
      revision.value++;
    }
  }
}
