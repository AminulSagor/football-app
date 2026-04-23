import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/themes/app_text_styles.dart';
import '../../shared/app_bar_view.dart';
import 'matches_search_controller.dart';
import 'matches_search_models.dart';

class MatchesSearchView extends StatefulWidget {
  const MatchesSearchView({super.key});

  @override
  State<MatchesSearchView> createState() => _MatchesSearchViewState();
}

class _MatchesSearchViewState extends State<MatchesSearchView> {
  late final MatchesSearchController _controller;
  late final TextEditingController _queryController;
  late final FocusNode _queryFocusNode;

  static const List<_SearchFilterChipData> _filterItems =
      <_SearchFilterChipData>[
        _SearchFilterChipData(code: MatchesSearchFilterCodes.all, label: 'All'),
        _SearchFilterChipData(
          code: MatchesSearchFilterCodes.teams,
          label: 'Teams',
        ),
        _SearchFilterChipData(
          code: MatchesSearchFilterCodes.leagues,
          label: 'Leagues',
        ),
        _SearchFilterChipData(
          code: MatchesSearchFilterCodes.players,
          label: 'Players',
        ),
      ];

  @override
  void initState() {
    super.initState();
    _controller = Get.find<MatchesSearchController>();
    _controller.reset();
    _queryController = TextEditingController();
    _queryFocusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _queryFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _queryController.dispose();
    _queryFocusNode.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _queryController.clear();
    _controller.clearSearch();
    _queryFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.scaffoldBackgroundColor,
              theme.colorScheme.surface.withAlpha(
                theme.brightness == Brightness.dark ? 34 : 16,
              ),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Obx(() {
            final state = _controller.state.value;

            return Column(
              children: [
                CustomAppBar(
                  showBackButton: true,
                  onBackTap: () => Navigator.of(context).maybePop(),
                  titleWidget: _SearchInput(
                    controller: _queryController,
                    focusNode: _queryFocusNode,
                    hasQuery: state.query.trim().isNotEmpty,
                    onChanged: _controller.onQueryChanged,
                    onSubmitted: (_) => _controller.submitSearch(),
                    onClear: _clearSearch,
                  ),
                  padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
                  showBottomDivider: true,
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  height: 34.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemBuilder: (context, index) {
                      final item = _filterItems[index];
                      return _SearchFilterChip(
                        label: item.label,
                        selected: state.selectedFilterCode == item.code,
                        onTap: () => _controller.onFilterSelected(item.code),
                      );
                    },
                    separatorBuilder: (_, _) => SizedBox(width: 8.w),
                    itemCount: _filterItems.length,
                  ),
                ),
                SizedBox(height: 20.h),
                Expanded(
                  child: _SearchBody(
                    state: state,
                    onRetry: _controller.submitSearch,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _SearchInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasQuery;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;

  const _SearchInput({
    required this.controller,
    required this.focusNode,
    required this.hasQuery,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 42.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.r),
        color: theme.colorScheme.surface.withAlpha(150),
        border: Border.all(
          color: theme.dividerColor.withAlpha(130),
          width: 1.w,
        ),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        textInputAction: TextInputAction.search,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontSize: AppTextStyles.sizeBody.sp,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(
            color: theme.colorScheme.onSurface.withAlpha(110),
            fontSize: AppTextStyles.sizeBody.sp,
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
          prefixIconConstraints: BoxConstraints(
            minWidth: 38.w,
            minHeight: 42.h,
          ),
          prefixIcon: Icon(
            Icons.search,
            size: 20.r,
            color: theme.colorScheme.onSurface.withAlpha(170),
          ),
          suffixIcon: hasQuery
              ? IconButton(
                  onPressed: onClear,
                  icon: Icon(
                    Icons.close,
                    size: 18.r,
                    color: theme.colorScheme.onSurface.withAlpha(160),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

class _SearchFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SearchFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17.r),
            color: selected ? theme.colorScheme.primary : theme.colorScheme.surface.withAlpha(130),
            border: Border.all(
              color: selected ? theme.colorScheme.primary : theme.dividerColor.withAlpha(110),
              width: 1.w,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface.withAlpha(180),
              fontSize: AppTextStyles.sizeBodySmall.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchBody extends StatelessWidget {
  final MatchesSearchViewModel state;
  final Future<void> Function() onRetry;

  const _SearchBody({required this.state, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (state.isLoading) {
      return Center(
        child: SizedBox(
          width: 24.r,
          height: 24.r,
          child: CircularProgressIndicator(
            strokeWidth: 2.2.w,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.secondary,
            ),
          ),
        ),
      );
    }

    if (state.errorCode != null) {
      return Center(
        child: GestureDetector(
          onTap: onRetry,
          child: Text(
            'Unable to load search',
            style: TextStyle(
              color: theme.colorScheme.onSurface.withAlpha(150),
              fontSize: AppTextStyles.sizeBody.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    if (state.showEmptyState) {
      return Center(
        child: Text(
          'No result found',
          style: TextStyle(
            color: theme.colorScheme.onSurface.withAlpha(85),
            fontSize: AppTextStyles.sizeHero.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    if (state.results.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 20.h),
      itemBuilder: (context, index) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Get.toNamed('/match-details', arguments: {'scenario': 'finished'}),
            child: _SearchResultTile(item: state.results[index]),
          ),
        );
      },
      separatorBuilder: (_, _) => SizedBox(height: 20.h),
      itemCount: state.results.length,
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  final MatchesSearchResultUiModel item;

  const _SearchResultTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final avatarColor = _colorFromHex(
      item.avatarHex,
      theme.colorScheme.secondary,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      child: Row(
        children: [
          Container(
            width: 46.r,
            height: 46.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  avatarColor.withAlpha(240),
                  avatarColor.withAlpha(170),
                ],
              ),
              border: Border.all(color: theme.colorScheme.onSurface.withAlpha(28), width: 1.w),
            ),
            alignment: Alignment.center,
            child: Text(
              item.avatarSeed,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withAlpha(220),
                fontSize: AppTextStyles.sizeBody.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: AppTextStyles.sizeBodySmall.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  item.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withAlpha(160),
                    fontSize: AppTextStyles.sizeBody.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchFilterChipData {
  final String code;
  final String label;

  const _SearchFilterChipData({required this.code, required this.label});
}

Color _colorFromHex(String value, Color fallback) {
  final hex = value.replaceAll('#', '').trim();
  if (hex.length != 6 && hex.length != 8) {
    return fallback;
  }

  final normalized = hex.length == 6 ? 'FF$hex' : hex;
  final parsed = int.tryParse(normalized, radix: 16);
  if (parsed == null) {
    return fallback;
  }

  return Color(parsed);
}
