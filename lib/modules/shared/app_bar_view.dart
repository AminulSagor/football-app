import 'package:flutter/material.dart';

import '../../core/themes/app_text_styles.dart';

class CustomAppBar extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final bool showBackButton;
  final VoidCallback? onBackTap;
  final bool isBrandTitle;
  final List<Widget> actions;
  final EdgeInsetsGeometry padding;
  final TextStyle? titleStyle;
  final bool showBottomDivider;
  final Color? dividerColor;

  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.showBackButton = false,
    this.onBackTap,
    this.isBrandTitle = false,
    this.actions = const <Widget>[],
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.titleStyle,
    this.showBottomDivider = false,
    this.dividerColor,
  }) : assert(
         title != null || titleWidget != null,
         'CustomAppBar requires either title or titleWidget.',
       );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveTitleStyle =
        titleStyle ??
        TextStyle(
          color: isBrandTitle
              ? theme.colorScheme.secondary
              : theme.colorScheme.onSurface,
          fontSize: isBrandTitle
              ? AppTextStyles.sizeHeading
              : AppTextStyles.sizeTitle,
          fontWeight: FontWeight.w700,
          letterSpacing: isBrandTitle ? 0.4 : -0.1,
          height: 1.12,
        );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: padding,
          child: Row(
            children: [
              if (showBackButton) ...[
                CustomAppBarIconButton(
                  icon: Icons.arrow_back,
                  onTap: onBackTap ?? () => Navigator.of(context).maybePop(),
                  color: theme.colorScheme.onSurface.withAlpha(208),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child:
                    titleWidget ??
                    Text(
                      title!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: effectiveTitleStyle,
                    ),
              ),
              if (actions.isNotEmpty) const SizedBox(width: 10),
              ..._buildActions(actions),
            ],
          ),
        ),
        SizedBox(height: 8),
        if (showBottomDivider)
          Container(
            height: 1,
            color: dividerColor ?? theme.dividerColor.withAlpha(170),
          ),
      ],
    );
  }

  List<Widget> _buildActions(List<Widget> items) {
    final children = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      children.add(items[i]);
      if (i != items.length - 1) {
        children.add(const SizedBox(width: 8));
      }
    }
    return children;
  }
}

class CustomAppBarIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color? color;
  final double size;

  const CustomAppBarIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.color,
    this.size = 22,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(
            icon,
            size: size,
            color: color ?? theme.colorScheme.onSurface.withAlpha(188),
          ),
        ),
      ),
    );
  }
}
