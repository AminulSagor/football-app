import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/themes/app_text_styles.dart';
import '../../shared/app_bar_view.dart';
import 'models/notification_models.dart';
import 'notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
	const NotificationView({super.key});

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final isDark = theme.brightness == Brightness.dark;

		return Scaffold(
			backgroundColor: theme.scaffoldBackgroundColor,
			body: Container(
				decoration: BoxDecoration(
					gradient: LinearGradient(
						begin: Alignment.topCenter,
						end: Alignment.bottomCenter,
						colors: [
							theme.scaffoldBackgroundColor,
							isDark
									? const Color(0xFF040A08)
									: theme.colorScheme.surface.withAlpha(18),
						],
					),
				),
				child: SafeArea(
					bottom: false,
					child: Obx(() {
						final state = controller.state.value;

						return Column(
							children: [
								Padding(
									padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 0),
									child: CustomAppBar(
										title: 'Notifications',
										showBackButton: true,
										titleStyle: TextStyle(
											color: theme.colorScheme.onSurface,
											fontSize: AppTextStyles.sizeTitle.sp,
											fontWeight: FontWeight.w700,
											letterSpacing: -0.15,
										),
										actions: [
											CustomAppBarIconButton(
												icon: Icons.done_all,
												color: state.hasUnread
														? theme.colorScheme.secondary
														: theme.colorScheme.onSurface.withAlpha(148),
												size: 22.r,
												onTap: controller.markAllAsRead,
											),
										],
									),
								),
								SizedBox(height: 6.h),
								Expanded(
									child: _Body(state: state, controller: controller),
								),
							],
						);
					}),
				),
			),
		);
	}
}

class _Body extends StatelessWidget {
	final NotificationViewModel state;
	final NotificationController controller;

	const _Body({required this.state, required this.controller});

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);

		if (state.isLoading) {
			return Center(
				child: SizedBox(
					width: 26.r,
					height: 26.r,
					child: CircularProgressIndicator(
						strokeWidth: 2.4.w,
						valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.secondary),
					),
				),
			);
		}

		if (state.errorCode != null) {
			return Center(
				child: Padding(
					padding: EdgeInsets.symmetric(horizontal: 24.w),
					child: Column(
						mainAxisSize: MainAxisSize.min,
						children: [
							Text(
								'Could not load notifications.',
								textAlign: TextAlign.center,
								style: TextStyle(
									color: theme.colorScheme.onSurface,
									fontSize: AppTextStyles.sizeBody.sp,
									fontWeight: FontWeight.w600,
								),
							),
							SizedBox(height: 12.h),
							TextButton(
								onPressed: controller.reload,
								child: Text(
									'Retry',
									style: TextStyle(
										color: theme.colorScheme.secondary,
										fontSize: AppTextStyles.sizeBodySmall.sp,
										fontWeight: FontWeight.w700,
									),
								),
							),
						],
					),
				),
			);
		}

		if (state.notifications.isEmpty) {
			return Center(
				child: Text(
					'No notifications yet',
					style: TextStyle(
						color: theme.colorScheme.onSurface.withAlpha(155),
						fontSize: AppTextStyles.sizeBody.sp,
						fontWeight: FontWeight.w600,
					),
				),
			);
		}

		final todayItems = state.groupedItems(NotificationGroupCodes.today);
		final yesterdayItems = state.groupedItems(NotificationGroupCodes.yesterday);

		return ListView(
			physics: const BouncingScrollPhysics(),
			padding: EdgeInsets.fromLTRB(16.w, 2.h, 16.w, 22.h),
			children: [
				if (todayItems.isNotEmpty) ...[
					const _SectionLabel(label: 'TODAY'),
					SizedBox(height: 12.h),
					for (final item in todayItems)
						Padding(
							padding: EdgeInsets.only(bottom: 12.h),
							child: _NotificationCard(item: item),
						),
					SizedBox(height: 10.h),
				],
				if (yesterdayItems.isNotEmpty) ...[
					const _SectionLabel(label: 'YESTERDAY'),
					SizedBox(height: 12.h),
					for (final item in yesterdayItems)
						Padding(
							padding: EdgeInsets.only(bottom: 12.h),
							child: _NotificationCard(item: item),
						),
				],
			],
		);
	}
}

class _SectionLabel extends StatelessWidget {
	final String label;

	const _SectionLabel({required this.label});

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);

		return Padding(
			padding: EdgeInsets.only(left: 8.w),
			child: Text(
				label,
				style: TextStyle(
					color: theme.colorScheme.onSurface.withAlpha(164),
					fontSize: AppTextStyles.sizeLabel.sp,
					fontWeight: FontWeight.w700,
					letterSpacing: 1.6,
				),
			),
		);
	}
}

class _NotificationCard extends StatelessWidget {
	final NotificationItemUiModel item;

	const _NotificationCard({required this.item});

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final isDark = theme.brightness == Brightness.dark;

		return Container(
			decoration: BoxDecoration(
				borderRadius: BorderRadius.circular(14.r),
				gradient: LinearGradient(
					begin: Alignment.centerLeft,
					end: Alignment.centerRight,
					colors: [
						theme.colorScheme.surface.withAlpha(isDark ? 236 : 255),
						theme.colorScheme.surface.withAlpha(isDark ? 212 : 248),
					],
				),
				border: Border.all(
					color: theme.dividerColor.withAlpha(isDark ? 140 : 100),
					width: 1.w,
				),
				boxShadow: [
					BoxShadow(
						color: Colors.black.withAlpha(isDark ? 28 : 12),
						offset: Offset(0, 8.h),
						blurRadius: 18.r,
					),
				],
			),
			child: ClipRRect(
				borderRadius: BorderRadius.circular(14.r),
				child: Row(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						AnimatedContainer(
							duration: const Duration(milliseconds: 180),
							width: 3.w,
							height: 100.h,
							color: item.isUnread
									? theme.colorScheme.secondary
									: Colors.transparent,
						),
						Expanded(
							child: Padding(
								padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
								child: Row(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										_LeadingIcon(assetPath: item.iconAsset),
										SizedBox(width: 12.w),
										Expanded(
											child: Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													Row(
														crossAxisAlignment: CrossAxisAlignment.start,
														children: [
															Expanded(
																child: Text(
																	item.title,
																	maxLines: 2,
																	overflow: TextOverflow.ellipsis,
																	style: TextStyle(
																		color: theme.colorScheme.onSurface,
																		fontSize: AppTextStyles.sizeHeading.sp,
																		fontWeight: FontWeight.w700,
																		height: 1.08,
																		letterSpacing: -0.2,
																	),
																),
															),
															SizedBox(width: 8.w),
															Text(
																item.relativeTime,
																style: TextStyle(
																	color: theme.colorScheme.onSurface.withAlpha(144),
																	fontSize: AppTextStyles.sizeBodySmall.sp,
																	fontWeight: FontWeight.w500,
																),
															),
														],
													),
													SizedBox(height: 8.h),
													Text(
														item.message,
														maxLines: 3,
														overflow: TextOverflow.ellipsis,
														style: TextStyle(
															color: theme.colorScheme.onSurface.withAlpha(184),
															fontSize: AppTextStyles.sizeBody.sp,
															fontWeight: FontWeight.w500,
															height: 1.32,
														),
													),
												],
											),
										),
									],
								),
							),
						),
					],
				),
			),
		);
	}
}

class _LeadingIcon extends StatelessWidget {
	final String assetPath;

	const _LeadingIcon({required this.assetPath});

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);

		return Container(
			width: 44.r,
			height: 44.r,
			decoration: BoxDecoration(
				borderRadius: BorderRadius.circular(12.r),
				color: theme.colorScheme.surface.withAlpha(140),
				border: Border.all(color: theme.dividerColor.withAlpha(140), width: 1.w),
			),
			alignment: Alignment.center,
			child: ClipRRect(
				borderRadius: BorderRadius.circular(10.r),
				child: Image.asset(
					assetPath,
					width: 34.r,
					height: 34.r,
					fit: BoxFit.cover,
					errorBuilder: (context, error, stackTrace) {
						return Icon(
							Icons.notifications_none,
							size: 18.r,
							color: theme.colorScheme.onSurface.withAlpha(170),
						);
					},
				),
			),
		);
	}
}
