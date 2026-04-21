import 'package:get/get.dart';

import '../../core/services/api_error_handler.dart';
import 'leagues_models.dart';
import 'leagues_service.dart';

class LeaguesController extends GetxController {
  final LeaguesService _service;

  LeaguesController({required LeaguesService service}) : _service = service;

  final Rx<LeaguesViewModel> state = const LeaguesViewModel().obs;

  @override
  void onInit() {
    super.onInit();
    _loadLeagues();
  }

  Future<void> reload() async {
    await _loadLeagues();
  }

  void toggleTopLeaguesVisibility() {
    if (!state.value.hasExpandableTopLeagues) {
      return;
    }

    state.value = state.value.copyWith(
      showAllTopLeagues: !state.value.showAllTopLeagues,
    );
  }

  void toggleCountryExpanded(String countryId) {
    LeaguesCountryUiModel? targetCountry;
    for (final country in state.value.countries) {
      if (country.countryId == countryId) {
        targetCountry = country;
        break;
      }
    }

    if (targetCountry == null || !targetCountry.isExpandable) {
      return;
    }

    final nextExpanded = Set<String>.from(state.value.expandedCountryIds);
    if (nextExpanded.contains(countryId)) {
      nextExpanded.remove(countryId);
    } else {
      nextExpanded.add(countryId);
    }

    state.value = state.value.copyWith(expandedCountryIds: nextExpanded);
  }

  Future<void> _loadLeagues() async {
    state.value = state.value.copyWith(isLoading: true, errorCode: null);

    final response = await ApiErrorHandler.handle<LeaguesFeedUiModel>(
      () => _service.fetchLeagues(
        const LeaguesFeedPayloadModel(sportCode: LeaguesSportCodes.football),
      ),
      fallbackErrorCode: 'leagues_fetch_failed',
      userMessage: 'Unable to load leagues right now.',
    );

    if (isClosed) {
      return;
    }

    if (!response.success || response.data == null) {
      state.value = state.value.copyWith(
        isLoading: false,
        topLeagues: const <LeaguesTopLeagueUiModel>[],
        countries: const <LeaguesCountryUiModel>[],
        expandedCountryIds: <String>{},
        showAllTopLeagues: false,
        errorCode: response.errorCode,
      );
      return;
    }

    final feed = response.data!;
    final initiallyExpanded = feed.countries
        .where((country) => country.isExpandedByDefault && country.isExpandable)
        .map((country) => country.countryId)
        .toSet();

    state.value = state.value.copyWith(
      isLoading: false,
      topLeagues: feed.topLeagues,
      countries: feed.countries,
      expandedCountryIds: initiallyExpanded,
      showAllTopLeagues: false,
      errorCode: null,
    );
  }
}

class LeaguesBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<LeaguesService>()) {
      Get.lazyPut<LeaguesService>(() => LeaguesService(), fenix: true);
    }

    if (!Get.isRegistered<LeaguesController>()) {
      Get.lazyPut<LeaguesController>(
        () => LeaguesController(service: Get.find<LeaguesService>()),
      );
    }
  }
}
