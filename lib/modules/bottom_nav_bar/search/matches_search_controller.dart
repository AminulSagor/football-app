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

  void reset() {
    _debounce?.cancel();
    state.value = const MatchesSearchViewModel();
  }

  void onQueryChanged(String query) {
    state.value = state.value.copyWith(
      query: query,
      visibleCount: 0,
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

    state.value = state.value.copyWith(
      selectedFilterCode: filterCode,
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
        results: const <MatchesSearchResultUiModel>[],
        visibleCount: 0,
        errorCode: null,
      );
      return;
    }

    state.value = state.value.copyWith(isLoading: true, errorCode: null);

    final response =
        await ApiErrorHandler.handle<List<MatchesSearchResultUiModel>>(
          () => _service.fetchSearchResults(
            MatchesSearchPayloadModel(
              query: trimmedQuery,
              filterCode: state.value.selectedFilterCode,
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
        results: const <MatchesSearchResultUiModel>[],
        visibleCount: 0,
        errorCode: response.errorCode,
      );
      return;
    }

    final results = response.data!;
    final visibleCount = results.length > _pageSize
        ? _pageSize
        : results.length;

    state.value = state.value.copyWith(
      isLoading: false,
      results: results,
      visibleCount: visibleCount,
      errorCode: null,
    );
  }

  void clearSearch() {
    _debounce?.cancel();
    state.value = state.value.copyWith(
      query: '',
      isLoading: false,
      results: const <MatchesSearchResultUiModel>[],
      visibleCount: 0,
      errorCode: null,
    );
  }

  void showMore() {
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
