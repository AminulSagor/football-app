import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

import '../themes/app_colors.dart';

class ApiResponseModel<T> {
  final T? data;
  final bool success;
  final String? errorCode;

  const ApiResponseModel({
    required this.data,
    required this.success,
    required this.errorCode,
  });

  const ApiResponseModel.success(T data)
    : this(data: data, success: true, errorCode: null);

  const ApiResponseModel.failure(String errorCode)
    : this(data: null, success: false, errorCode: errorCode);
}

class ApiErrorHandler {
  static Future<ApiResponseModel<T>> handle<T>(
    Future<T> Function() action, {
    String fallbackErrorCode = 'unexpected_error',
    String userMessage = 'Something went wrong. Please try again.',
    bool showUserError = true,
  }) async {
    try {
      final data = await action();
      return ApiResponseModel<T>.success(data);
    } catch (error) {
      final message = _extractUserMessage(error) ?? userMessage;
      if (showUserError) {
        _showUserError(message);
      }
      return ApiResponseModel<T>.failure(
        _extractErrorCode(error) ?? fallbackErrorCode,
      );
    }
  }

  static void _showUserError(String message) {
    if (Get.context == null && Get.overlayContext == null) {
      debugPrint('[ApiErrorHandler] $message');
      return;
    }

    try {
      Get.closeAllSnackbars();
      Get.snackbar(
        'Error',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.snackbarBackground,
        colorText: AppColors.snackbarText,
        margin: const EdgeInsets.all(14),
        duration: const Duration(seconds: 2),
      );
    } catch (_) {
      debugPrint('[ApiErrorHandler] $message');
    }
  }

  static String? _extractErrorCode(Object error) {
    final message = error.toString().trim();
    if (message.isEmpty) {
      return null;
    }

    return message
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }

  static String? _extractUserMessage(Object error) {
    if (error is dio.DioException) {
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        final message = data['message'];
        if (message is String && message.trim().isNotEmpty) {
          return message.trim();
        }
        if (message is List && message.isNotEmpty) {
          final first = message.first;
          if (first is String && first.trim().isNotEmpty) {
            return first.trim();
          }
        }
      }
    }

    return null;
  }
}
