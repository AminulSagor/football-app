class FacebookAdPlacementHelper {
  static const int maxNativeAdsPerList = 5;
  static const int firstNativeAdAfterItemCount = 5;
  static const int nativeAdRepeatItemCount = 10;

  const FacebookAdPlacementHelper._();

  static bool shouldShowNativeAdAfterIndex(
    int itemIndex, {
    int firstAdAfterItemCount = firstNativeAdAfterItemCount,
    int repeatItemCount = nativeAdRepeatItemCount,
    int maxAds = maxNativeAdsPerList,
  }) {
    final itemPosition = itemIndex + 1;
    return shouldShowNativeAdAfterItemPosition(
      itemPosition,
      firstAdAfterItemCount: firstAdAfterItemCount,
      repeatItemCount: repeatItemCount,
      maxAds: maxAds,
    );
  }

  static bool shouldShowNativeAdAfterItemPosition(
    int itemPosition, {
    int firstAdAfterItemCount = firstNativeAdAfterItemCount,
    int repeatItemCount = nativeAdRepeatItemCount,
    int maxAds = maxNativeAdsPerList,
  }) {
    if (itemPosition < firstAdAfterItemCount || maxAds <= 0) return false;
    if (itemPosition == firstAdAfterItemCount) return true;

    final itemOffset = itemPosition - firstAdAfterItemCount;
    if (itemOffset % repeatItemCount != 0) return false;

    final adPosition = (itemOffset ~/ repeatItemCount) + 1;
    return adPosition <= maxAds;
  }

  static int nativeAdCountForCompletedItems(
    int completedItemCount, {
    int firstAdAfterItemCount = firstNativeAdAfterItemCount,
    int repeatItemCount = nativeAdRepeatItemCount,
    int maxAds = maxNativeAdsPerList,
  }) {
    if (completedItemCount < firstAdAfterItemCount || maxAds <= 0) return 0;

    final itemOffset = completedItemCount - firstAdAfterItemCount;
    final adCount = (itemOffset ~/ repeatItemCount) + 1;
    return adCount > maxAds ? maxAds : adCount;
  }
}
