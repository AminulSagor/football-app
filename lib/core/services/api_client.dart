import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'storage_service.dart';
import '../utils/utiils.dart';

class ApiClient extends GetxService {
  late final dio.Dio _dio;
  final StorageService _storageService;
  final FirebaseInstallations _installations;
  Future<String>? _installationIdFuture;

  ApiClient({
    required dio.Dio? client,
    required StorageService storageService,
    FirebaseInstallations? installations,
  }) : _storageService = storageService,
       _installations = installations ?? FirebaseInstallations.instance {
    _dio =
        client ??
        dio.Dio(
          dio.BaseOptions(
            baseUrl: dotenv.env['BASE_URL'] ?? '',
            connectTimeout: AppConstants.apiTimeout,
            sendTimeout: AppConstants.apiTimeout,
            receiveTimeout: AppConstants.apiTimeout,
          ),
        );
  }

  @override
  void onInit() {
    super.onInit();
    _dio.interceptors.add(
      dio.InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = _storageService.token;
          final skipAuth = options.extra['skipAuth'] == true;
          if (!skipAuth && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          final installationId = await _resolveInstallationId();
          if (installationId.isNotEmpty) {
            options.headers['x-installation-id'] = installationId;
          }
          handler.next(options);
        },
      ),
    );
    // _dio.interceptors.add(
    //   PrettyDioLogger(
    //     requestHeader: true,
    //     requestBody: true,
    //     responseBody: true,
    //     responseHeader: false,
    //     error: true,
    //     compact: true,
    //     maxWidth: 120,
    //   ),
    // );
  }

  void setBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  Future<void> preloadInstallationId() async {
    await _resolveInstallationId();
  }

  Future<String> _resolveInstallationId() {
    final cachedInstallationId = _storageService.installationId.trim();
    if (cachedInstallationId.isNotEmpty) {
      return Future<String>.value(cachedInstallationId);
    }

    final inFlightFuture = _installationIdFuture;
    if (inFlightFuture != null) {
      return inFlightFuture;
    }

    final nextFuture = _installations.getId().then((resolvedInstallationId) async {
      await _storageService.setInstallationId(resolvedInstallationId);
      return resolvedInstallationId;
    }).whenComplete(() {
      _installationIdFuture = null;
    });

    _installationIdFuture = nextFuture;
    return nextFuture;
  }

  Future<dio.Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    dio.Options? options,
  }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<dio.Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    dio.Options? options,
  }) {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<dio.Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    dio.Options? options,
  }) {
    return _dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<dio.Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    dio.Options? options,
  }) {
    return _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<dio.Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    dio.Options? options,
  }) {
    return _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
