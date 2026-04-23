import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/following_service.dart';
import 'model/coach_profile_model.dart';

class CoachProfileController extends GetxController {
  final FollowingService _followingService;

  CoachProfileController({required FollowingService followingService})
    : _followingService = followingService;

  final Rx<CoachProfileViewModel> state = const CoachProfileViewModel(
    id: 'diego-simeone',
    coachName: 'Diego Simeone',
    teamName: 'Atletico Madrid',
    avatarSeed: 'DS',
    facts: <CoachProfileFactUiModel>[
      CoachProfileFactUiModel(value: 'ARG', label: 'Country', highlighted: true),
      CoachProfileFactUiModel(value: '41 years', label: 'Feb 1, 1985'),
    ],
    matches: '790',
    currentClub: 'Atletico Madrid',
    records: <CoachProfileRecordUiModel>[
      CoachProfileRecordUiModel(title: 'Wins', value: '466', progress: 0.74, color: Color(0xFF39E0B3)),
      CoachProfileRecordUiModel(title: 'Draw', value: '167', progress: 0.57, color: Color(0xFF39E0B3)),
      CoachProfileRecordUiModel(title: 'Losses', value: '157', progress: 0.31, color: Color(0xFFFF6B6B)),
    ],
    trophies: <CoachProfileTrophyUiModel>[
      CoachProfileTrophyUiModel(title: 'Sudamericano U20', country: 'South-America', season: 'Peru 2011', result: 'Winner', seed: 'SA'),
      CoachProfileTrophyUiModel(title: 'Trophee des Champions', country: 'France', season: '2019/2020', result: 'Winner', seed: 'TC'),
    ],
    careerItems: <CoachCareerItemUiModel>[
      CoachCareerItemUiModel(title: 'Atletico Madrid', rangeLabel: 'DEC 2011 - NOW', seed: 'ATM'),
      CoachCareerItemUiModel(title: 'Racing Club', rangeLabel: 'JUN 2011 - DEC 2011', seed: 'RC'),
      CoachCareerItemUiModel(title: 'Catania', rangeLabel: 'JAN 2011 - MAY 2011', seed: 'CAT'),
      CoachCareerItemUiModel(title: 'Placeholder', rangeLabel: '', seed: ''),
      CoachCareerItemUiModel(title: 'Placeholder', rangeLabel: '', seed: ''),
    ],
  ).obs;

  Worker? _worker;
  String _coachId = 'diego-simeone';

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      final id = args['id']?.toString();
      if (id != null && id.isNotEmpty) {
        _applyCoachId(id);
      }
    }
    _syncFollowState();
    _worker = ever<int>(_followingService.revision, (_) => _syncFollowState());
  }

  @override
  void onClose() {
    _worker?.dispose();
    super.onClose();
  }

  void follow() {
    _followingService.follow(FollowEntityType.coach, _coachId);
  }

  void unfollow() {
    _followingService.unfollow(FollowEntityType.coach, _coachId);
  }

  void _syncFollowState() {
    state.value = state.value.copyWith(
      isFollowing: _followingService.isFollowing(FollowEntityType.coach, _coachId),
    );
  }

  void _applyCoachId(String id) {
    _coachId = id;
    switch (id) {
      case 'mikel-arteta':
        state.value = state.value.copyWith(
          id: id,
          coachName: 'Mikel Arteta',
          teamName: 'Arsenal',
          avatarSeed: 'MA',
          currentClub: 'Arsenal',
        );
        break;
      case 'pep-guardiola':
        state.value = state.value.copyWith(
          id: id,
          coachName: 'Pep Guardiola',
          teamName: 'Manchester City',
          avatarSeed: 'PG',
          currentClub: 'Manchester City',
        );
        break;
      default:
        _coachId = 'diego-simeone';
        state.value = state.value.copyWith(
          id: 'diego-simeone',
          coachName: 'Diego Simeone',
          teamName: 'Atletico Madrid',
          avatarSeed: 'DS',
          currentClub: 'Atletico Madrid',
        );
        break;
    }
  }
}

class CoachProfileBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<FollowingService>()) {
      Get.lazyPut<FollowingService>(() => FollowingService(), fenix: true);
    }
    Get.lazyPut<CoachProfileController>(
      () => CoachProfileController(followingService: Get.find<FollowingService>()),
    );
  }
}
