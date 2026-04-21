import 'dart:async';

import 'package:get/get.dart';

import '../../../core/services/api_error_handler.dart';
import 'matches_search_models.dart';
import 'matches_search_service.dart';

class MatchesSearchController extends GetxController {
  final MatchesSearchService _service;

  MatchesSearchController({required MatchesSearchService service})
    : _service = service;

  final Rx<MatchesSearchViewModel> state = const MatchesSearchViewModel().obs;

  Timer? _debounce;

  void reset() {
    _debounce?.cancel();
    state.value = const MatchesSearchViewModel();
  }

  void onQueryChanged(String query) {
    state.value = state.value.copyWith(query: query, errorCode: null);
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
        errorCode: response.errorCode,
      );
      return;
    }

    state.value = state.value.copyWith(
      isLoading: false,
      results: response.data!,
      errorCode: null,
    );
  }

  void clearSearch() {
    _debounce?.cancel();
    state.value = state.value.copyWith(
      query: '',
      isLoading: false,
      results: const <MatchesSearchResultUiModel>[],
      errorCode: null,
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
        () => MatchesSearchService(),
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
