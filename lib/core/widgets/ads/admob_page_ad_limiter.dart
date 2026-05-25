import 'package:flutter/widgets.dart';

class AdMobPageAdLimiter {
  AdMobPageAdLimiter._();

  static const int maxAdsPerPage = 5;
  static const int _maxTrackedPages = 120;

  static final Map<String, _PageAdSlots> _slotsByPage =
      <String, _PageAdSlots>{};

  static bool reserveSlot(BuildContext context, String placementId) {
    final normalizedPlacementId = placementId.trim();
    if (normalizedPlacementId.isEmpty) return false;

    final pageKey = _pageKey(context);
    final pageSlots = _slotsByPage.putIfAbsent(pageKey, _PageAdSlots.new);

    if (pageSlots.has(normalizedPlacementId)) {
      return true;
    }

    if (pageSlots.count >= maxAdsPerPage) {
      return false;
    }

    _trimTrackedPagesIfNeeded(currentPageKey: pageKey);
    pageSlots.add(normalizedPlacementId);
    return true;
  }

  static void releaseUnloadedSlot(BuildContext context, String placementId) {
    final normalizedPlacementId = placementId.trim();
    if (normalizedPlacementId.isEmpty) return;

    final pageSlots = _slotsByPage[_pageKey(context)];
    pageSlots?.remove(normalizedPlacementId);
  }

  static String fallbackPlacementId({
    required BuildContext context,
    required Object widget,
    Key? key,
  }) {
    if (key != null) return key.toString();

    final widgetName = widget.runtimeType.toString();
    final contextWidgetName = context.widget.runtimeType.toString();
    return '${widgetName}_${contextWidgetName}_${context.hashCode}';
  }

  static String _pageKey(BuildContext context) {
    final route = ModalRoute.of(context);
    if (route == null)
      return 'routeless_${Navigator.maybeOf(context).hashCode}';

    final routeName = route.settings.name ?? 'unnamed';
    final routeId = route.hashCode;
    return '${routeName}_$routeId';
  }

  static void _trimTrackedPagesIfNeeded({required String currentPageKey}) {
    if (_slotsByPage.length <= _maxTrackedPages) return;

    final staleKey = _slotsByPage.keys.firstWhere(
      (key) => key != currentPageKey,
      orElse: () => _slotsByPage.keys.first,
    );
    _slotsByPage.remove(staleKey);
  }
}

class _PageAdSlots {
  final Set<String> _placementIds = <String>{};

  int get count => _placementIds.length;

  bool has(String placementId) => _placementIds.contains(placementId);

  void add(String placementId) => _placementIds.add(placementId);

  void remove(String placementId) => _placementIds.remove(placementId);
}
