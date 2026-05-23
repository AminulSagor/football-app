import 'dart:async';

import 'package:get/get.dart';

import '../../../core/services/api_client.dart';
import '../../../core/services/api_error_handler.dart';
import 'search_models/matches_search_models.dart';
import 'search_services/matches_search_service.dart';

class MatchesSearchController extends GetxController {
  final MatchesSearchService _service;

  static const int _pageSize = 10;

  MatchesSearchController({required MatchesSearchService service})
    : _service = service;

  final Rx<MatchesSearchViewModel> state = const MatchesSearchViewModel().obs;

  Timer? _debounce;
  int _playersPage = 1;

  void reset() {
    _debounce?.cancel();
    _playersPage = 1;
    state.value = const MatchesSearchViewModel();
  }

  void onQueryChanged(String query) {
    _playersPage = 1;
    state.value = state.value.copyWith(
      query: query,
      visibleCount: 0,
      canLoadMore: false,
      isLoadingMore: false,
      errorCode: null,
    );
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 220), () {
      submitSearch();
    });
  }

  Future<void> onFilterSelected(String filterCode) async {
    if (filterCode == state.value.selectedFilterCode) {
      return;
    }

    _playersPage = 1;
    state.value = state.value.copyWith(
      selectedFilterCode: filterCode,
      canLoadMore: false,
      isLoadingMore: false,
      errorCode: null,
    );

    await submitSearch();
  }

  Future<void> submitSearch() async {
    _debounce?.cancel();

    final trimmedQuery = state.value.query.trim();
    if (trimmedQuery.isEmpty) {
      state.value = state.value.copyWith(
        isLoading: false,
        isLoadingMore: false,
        results: const <MatchesSearchResultUiModel>[],
        visibleCount: 0,
        canLoadMore: false,
        errorCode: null,
      );
      return;
    }

    if (trimmedQuery.length < 3) {
      state.value = state.value.copyWith(
        isLoading: false,
        isLoadingMore: false,
        results: const <MatchesSearchResultUiModel>[],
        visibleCount: 0,
        canLoadMore: false,
        errorCode: null,
      );
      return;
    }

    final isPlayersSearch =
        state.value.selectedFilterCode == MatchesSearchFilterCodes.players;
    _playersPage = 1;

    state.value = state.value.copyWith(
      isLoading: true,
      isLoadingMore: false,
      canLoadMore: false,
      errorCode: null,
    );

    final response =
        await ApiErrorHandler.handle<List<MatchesSearchResultUiModel>>(
          () => _service.fetchSearchResults(
            MatchesSearchPayloadModel(
              query: trimmedQuery,
              filterCode: state.value.selectedFilterCode,
              page: 1,
              limit: _pageSize,
            ),
          ),
          fallbackErrorCode: 'matches_search_fetch_failed',
          userMessage: 'Unable to search right now.',
        );

    if (isClosed) {
      return;
    }

    if (!response.success || response.data == null) {
      state.value = state.value.copyWith(
        isLoading: false,
        isLoadingMore: false,
        results: const <MatchesSearchResultUiModel>[],
        visibleCount: 0,
        canLoadMore: false,
        errorCode: response.errorCode,
      );
      return;
    }

    final results = response.data!;
    final visibleCount = isPlayersSearch
        ? results.length
        : results.length > _pageSize
        ? _pageSize
        : results.length;
    final canLoadMore = isPlayersSearch && results.length >= _pageSize;

    state.value = state.value.copyWith(
      isLoading: false,
      isLoadingMore: false,
      results: results,
      visibleCount: visibleCount,
      canLoadMore: canLoadMore,
      errorCode: null,
    );
  }

  void clearSearch() {
    _debounce?.cancel();
    _playersPage = 1;
    state.value = state.value.copyWith(
      query: '',
      isLoading: false,
      isLoadingMore: false,
      results: const <MatchesSearchResultUiModel>[],
      visibleCount: 0,
      canLoadMore: false,
      errorCode: null,
    );
  }

  Future<void> showMore() async {
    if (state.value.selectedFilterCode == MatchesSearchFilterCodes.players) {
      await _loadMorePlayers();
      return;
    }

    final current = state.value.visibleCount;
    final total = state.value.results.length;
    if (current >= total) {
      return;
    }

    final next = current + _pageSize;
    state.value = state.value.copyWith(
      visibleCount: next > total ? total : next,
    );
  }

  Future<void> _loadMorePlayers() async {
    final currentState = state.value;
    if (currentState.isLoading ||
        currentState.isLoadingMore ||
        !currentState.canLoadMore) {
      return;
    }

    final trimmedQuery = currentState.query.trim();
    if (trimmedQuery.isEmpty) {
      return;
    }

    final nextPage = _playersPage + 1;
    state.value = currentState.copyWith(isLoadingMore: true);

    final response =
        await ApiErrorHandler.handle<List<MatchesSearchResultUiModel>>(
          () => _service.fetchSearchResults(
            MatchesSearchPayloadModel(
              query: trimmedQuery,
              filterCode: currentState.selectedFilterCode,
              page: nextPage,
              limit: _pageSize,
            ),
          ),
          fallbackErrorCode: 'players_search_failed',
          userMessage: 'Unable to load more players right now.',
        );

    if (isClosed) {
      return;
    }

    final latestState = state.value;
    if (latestState.selectedFilterCode != currentState.selectedFilterCode ||
        latestState.query.trim() != trimmedQuery) {
      return;
    }

    if (!response.success || response.data == null) {
      state.value = latestState.copyWith(isLoadingMore: false);
      return;
    }

    final newItems = response.data!;
    if (newItems.isEmpty) {
      state.value = latestState.copyWith(
        isLoadingMore: false,
        canLoadMore: false,
      );
      return;
    }

    final merged = <MatchesSearchResultUiModel>[
      ...latestState.results,
      ...newItems,
    ];

    _playersPage = nextPage;

    state.value = latestState.copyWith(
      isLoadingMore: false,
      results: merged,
      visibleCount: merged.length,
      canLoadMore: newItems.length >= _pageSize,
    );
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }
}

class MatchesSearchBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<MatchesSearchService>()) {
      Get.lazyPut<MatchesSearchService>(
        () => MatchesSearchService(apiClient: Get.find<ApiClient>()),
        fenix: true,
      );
    }

    if (!Get.isRegistered<MatchesSearchController>()) {
      Get.lazyPut<MatchesSearchController>(
        () =>
            MatchesSearchController(service: Get.find<MatchesSearchService>()),
        fenix: true,
      );
    }
  }
}
