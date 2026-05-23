import 'package:get/get.dart';

import '../../core/services/api_client.dart';
import '../../core/services/api_error_handler.dart';
import 'model/leagues_models.dart';
import 'service/leagues_service.dart';

class LeaguesController extends GetxController {
  final LeaguesService _service;

  LeaguesController({required LeaguesService service}) : _service = service;

  static const int _countryLeagueLimit = 20;

  final Rx<LeaguesViewModel> state = const LeaguesViewModel().obs;

  int get _season => DateTime.now().year - 1;

  Future<void> ensureLoaded() async {
    if (state.value.hasLoaded || state.value.isLoading) return;
    await _loadLeagues();
  }

  Future<void> reload() async {
    await _loadLeagues(force: true);
  }

  void toggleTopLeaguesVisibility() {
    if (!state.value.hasExpandableTopLeagues) return;

    state.value = state.value.copyWith(
      showAllTopLeagues: !state.value.showAllTopLeagues,
    );
  }

  void onCountryTap(String countryId) {
    final country = _countryById(countryId);
    if (country == null) return;

    final nextExpanded = Set<String>.from(state.value.expandedCountryIds);
    final willExpand = !nextExpanded.contains(countryId);

    if (willExpand) {
      nextExpanded.add(countryId);
    } else {
      nextExpanded.remove(countryId);
    }

    state.value = state.value.copyWith(expandedCountryIds: nextExpanded);

    if (willExpand &&
        !country.hasLoadedCompetitions &&
        !country.isLoadingCompetitions) {
      _loadCountryLeagues(countryId: countryId, page: 1);
    }
  }

  Future<void> loadMoreCountryLeagues(String countryId) async {
    final country = _countryById(countryId);
    if (country == null || !country.canLoadMoreCompetitions) return;
    await _loadCountryLeagues(
      countryId: countryId,
      page: country.leaguePage + 1,
    );
  }

  Future<void> _loadLeagues({bool force = false}) async {
    state.value = state.value.copyWith(isLoading: true, errorCode: null);

    final response = await ApiErrorHandler.handle<LeaguesFeedUiModel>(
      () => _service.fetchLeagues(
        const LeaguesFeedPayloadModel(sportCode: LeaguesSportCodes.football),
      ),
      fallbackErrorCode: 'leagues_fetch_failed',
      userMessage: 'Unable to load leagues right now.',
    );

    if (isClosed) return;

    if (!response.success || response.data == null) {
      state.value = state.value.copyWith(
        isLoading: false,
        topLeagues: const <LeaguesTopLeagueUiModel>[],
        countries: const <LeaguesCountryUiModel>[],
        expandedCountryIds: <String>{},
        showAllTopLeagues: false,
        errorCode: response.errorCode,
        hasLoaded: false,
      );
      return;
    }

    final feed = response.data!;

    state.value = state.value.copyWith(
      isLoading: false,
      topLeagues: feed.topLeagues,
      countries: feed.countries,
      expandedCountryIds: <String>{},
      showAllTopLeagues: false,
      errorCode: null,
      hasLoaded: true,
    );
  }

  Future<void> _loadCountryLeagues({
    required String countryId,
    required int page,
  }) async {
    final country = _countryById(countryId);
    if (country == null) return;

    _replaceCountry(
      country.copyWith(
        isLoadingCompetitions: page == 1,
        isLoadingMoreCompetitions: page > 1,
      ),
    );

    final response =
        await ApiErrorHandler.handle<FootballLeaguesByCountryDataModel>(
          () => _service.fetchLeaguesByCountry(
            country: country.countryName,
            season: _season,
            page: page,
            limit: _countryLeagueLimit,
          ),
          fallbackErrorCode: 'country_leagues_fetch_failed',
          userMessage: 'Unable to load country leagues right now.',
        );

    if (isClosed) return;

    final latestCountry = _countryById(countryId);
    if (latestCountry == null) return;

    if (!response.success || response.data == null) {
      _replaceCountry(
        latestCountry.copyWith(
          isLoadingCompetitions: false,
          isLoadingMoreCompetitions: false,
          hasLoadedCompetitions: page == 1
              ? true
              : latestCountry.hasLoadedCompetitions,
        ),
      );
      return;
    }

    final data = response.data!;
    final competitions =
        data.items
            .map(LeaguesCompetitionUiModel.fromFootballLeague)
            .toList(growable: false)
          ..sort((left, right) => left.title.compareTo(right.title));

    final mergedCompetitions = page == 1
        ? competitions
        : <LeaguesCompetitionUiModel>[
            ...latestCountry.competitions,
            ...competitions,
          ];

    _replaceCountry(
      latestCountry.copyWith(
        competitions: mergedCompetitions,
        hasLoadedCompetitions: true,
        isLoadingCompetitions: false,
        isLoadingMoreCompetitions: false,
        leaguePage: data.meta.page,
        totalLeaguePages: data.meta.totalPages,
        totalCompetitions: data.meta.total,
      ),
    );
  }

  LeaguesCountryUiModel? _countryById(String countryId) {
    for (final country in state.value.countries) {
      if (country.countryId == countryId) return country;
    }
    return null;
  }

  void _replaceCountry(LeaguesCountryUiModel country) {
    final updatedCountries = state.value.countries
        .map((item) => item.countryId == country.countryId ? country : item)
        .toList(growable: false);

    state.value = state.value.copyWith(countries: updatedCountries);
  }
}

class LeaguesBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<LeaguesService>()) {
      Get.lazyPut<LeaguesService>(
        () => LeaguesService(apiClient: Get.find<ApiClient>()),
        fenix: true,
      );
    }

    if (!Get.isRegistered<LeaguesController>()) {
      Get.lazyPut<LeaguesController>(
        () => LeaguesController(service: Get.find<LeaguesService>()),
      );
    }
  }
}
