import 'package:flutter/material.dart';
import '../../models/match_details_model.dart';
import 'package:fotgram/core/themes/themes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VenueCard extends StatelessWidget {
  final MatchDetailsVenueUiModel venue;

  const VenueCard({required this.venue});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppColors.palette(theme.brightness);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 22.r,
              height: 22.r,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withAlpha(10),
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(
                  color: theme.dividerColor.withAlpha(120),
                  width: 1.w,
                ),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.stadium_outlined,
                color: theme.colorScheme.onSurface.withAlpha(180),
                size: 20.r,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    venue.stadiumName,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: AppTextStyles.sizeBody.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    venue.city,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withAlpha(145),
                      fontSize: AppTextStyles.sizeTiny.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                color: palette.background,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_on,
                color: theme.colorScheme.primary,
                size: 17.r,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Image.asset('assets/images/Container.png', width: 22.r, height: 22.r),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Surface',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withAlpha(125),
                    fontSize: AppTextStyles.sizeBodySmall.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  venue.surface,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: AppTextStyles.sizeBody.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}