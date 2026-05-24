import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PlayerProfileSkeletonizer extends StatelessWidget {
  final bool enabled;
  final Widget child;

  const PlayerProfileSkeletonizer({
    super.key,
    required this.enabled,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: enabled,
      child: AbsorbPointer(absorbing: enabled, child: child),
    );
  }
}
