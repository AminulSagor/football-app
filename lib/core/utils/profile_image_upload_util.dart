import 'dart:typed_data';

import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../services/api_client.dart';

class ProfileImageUploadResult {
  final String fileId;
  final String photoReadUrl;

  const ProfileImageUploadResult({
    required this.fileId,
    required this.photoReadUrl,
  });
}

class ProfileImageUploadUtil extends GetxService {
  final ApiClient _apiClient;
  final ImagePicker _imagePicker;
  final dio.Dio _s3Client;

  ProfileImageUploadUtil({
    required ApiClient apiClient,
    ImagePicker? imagePicker,
    dio.Dio? s3Client,
  }) : _apiClient = apiClient,
       _imagePicker = imagePicker ?? ImagePicker(),
       _s3Client = s3Client ?? dio.Dio();

  Future<XFile?> pickProfileImage({ImageSource source = ImageSource.gallery}) {
    return _imagePicker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1200,
      maxHeight: 1200,
    );
  }

  Future<ProfileImageUploadResult> uploadAndSetProfilePhoto(XFile image) async {
    final contentType = _contentTypeFromImage(image);
    final sizeBytes = await image.length();

    final signedUpload = await _getSignedUploadUrl(
      fileName: _fileNameFromImage(image),
      contentType: contentType,
      sizeBytes: sizeBytes,
    );

    await _uploadDirectlyToS3(
      image: image,
      uploadUrl: signedUpload.uploadUrl,
      contentType: signedUpload.contentType,
    );

    await _confirmUpload(signedUpload.fileId);

    return _setProfilePhoto(signedUpload.fileId);
  }

  Future<_SignedUploadInfo> _getSignedUploadUrl({
    required String fileName,
    required String contentType,
    required int sizeBytes,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/files/signed-upload-url',
      data: <String, dynamic>{
        'fileName': fileName,
        'contentType': contentType,
        'sizeBytes': sizeBytes,
        'folder': 'profile-photos',
      },
      options: dio.Options(
        headers: <String, dynamic>{'Content-Type': 'application/json'},
      ),
    );

    final data = _readData(response.data);

    final fileId = data['fileId'] as String? ?? '';
    final uploadUrl = data['uploadUrl'] as String? ?? '';

    final headers = data['headers'];
    final signedContentType = headers is Map<String, dynamic>
        ? headers['Content-Type'] as String?
        : null;

    if (fileId.isEmpty || uploadUrl.isEmpty) {
      throw Exception('invalid_signed_upload_response');
    }

    return _SignedUploadInfo(
      fileId: fileId,
      uploadUrl: uploadUrl,
      contentType: signedContentType ?? contentType,
    );
  }

  Future<void> _uploadDirectlyToS3({
    required XFile image,
    required String uploadUrl,
    required String contentType,
  }) async {
    final Uint8List bytes = await image.readAsBytes();

    if (bytes.isEmpty) {
      throw Exception('empty_file');
    }

    final response = await _s3Client.putUri<dynamic>(
      Uri.parse(uploadUrl),
      data: bytes,
      options: dio.Options(
        method: 'PUT',
        contentType: contentType,
        responseType: dio.ResponseType.plain,
        headers: <String, dynamic>{
          'Content-Type': contentType,
          dio.Headers.contentLengthHeader: bytes.length,
        },
        validateStatus: (status) {
          return status != null && status >= 200 && status < 300;
        },
      ),
    );

    final statusCode = response.statusCode ?? 0;

    if (statusCode < 200 || statusCode >= 300) {
      throw Exception('s3_upload_failed_$statusCode');
    }
  }

  Future<void> _confirmUpload(String fileId) async {
    await _apiClient.post<Map<String, dynamic>>(
      '/files/confirm-upload',
      data: <String, dynamic>{'fileId': fileId},
      options: dio.Options(
        headers: <String, dynamic>{'Content-Type': 'application/json'},
      ),
    );
  }

  Future<ProfileImageUploadResult> _setProfilePhoto(String fileId) async {
    final response = await _apiClient.patch<Map<String, dynamic>>(
      '/users/me/profile-photo',
      data: <String, dynamic>{'fileId': fileId},
      options: dio.Options(
        headers: <String, dynamic>{'Content-Type': 'application/json'},
      ),
    );

    final data = _readData(response.data);

    return ProfileImageUploadResult(
      fileId:
          data['profilePhotoFileId'] as String? ??
          data['fileId'] as String? ??
          fileId,
      photoReadUrl: data['photoReadUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> _readData(Map<String, dynamic>? responseData) {
    if (responseData == null) {
      throw Exception('empty_response');
    }

    final data = responseData['data'];

    if (data is! Map<String, dynamic>) {
      throw Exception('missing_data');
    }

    return data;
  }

  String _fileNameFromImage(XFile image) {
    final imageName = image.name.trim();

    if (imageName.isNotEmpty) {
      return imageName;
    }

    final normalized = image.path.replaceAll('\\', '/');
    final name = normalized.split('/').last.trim();

    if (name.isEmpty) {
      return 'profile-photo-${DateTime.now().millisecondsSinceEpoch}.jpg';
    }

    return name;
  }

  String _contentTypeFromImage(XFile image) {
    final mimeType = image.mimeType?.trim();

    if (mimeType != null && mimeType.isNotEmpty) {
      return mimeType;
    }

    final lower = image.path.toLowerCase();

    if (lower.endsWith('.png')) {
      return 'image/png';
    }

    if (lower.endsWith('.webp')) {
      return 'image/webp';
    }

    if (lower.endsWith('.heic') || lower.endsWith('.heif')) {
      return 'image/heic';
    }

    return 'image/jpeg';
  }
}

class _SignedUploadInfo {
  final String fileId;
  final String uploadUrl;
  final String contentType;

  const _SignedUploadInfo({
    required this.fileId,
    required this.uploadUrl,
    required this.contentType,
  });
}
