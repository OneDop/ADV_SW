import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late Dio dio;
  bool _isLoggingOut = false; // Flag to suppress errors during logout
  static const String tokenKey = 'auth_token';
  static const String _baseUrl = 'http://10.236.55.75:8080/api';
  static const String serverBaseUrl = 'http://10.236.55.75:8080';

  static String? buildImageUrl(String? relativePath) {
    if (relativePath == null || relativePath.isEmpty) return null;
    if (relativePath.startsWith('http://') || relativePath.startsWith('https://')) return relativePath;
    return '$serverBaseUrl$relativePath';
  }

  ApiClient._internal() {
    dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    ));

    _addInterceptors();
  }

  void _addInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString(tokenKey);

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          } else {
            // Ensure no Authorization header is sent if token is not available
            options.headers.remove('Authorization');
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // Suppress 401 errors during logout to prevent stale error popups
          if (_isLoggingOut && e.response?.statusCode == 401) {
            return handler.resolve(Response(
              statusCode: 200,
              data: {},
              requestOptions: e.requestOptions,
            ));
          }
          
          String errorMessage = 'An unexpected error occurred.';
          if (e.response != null && e.response?.data != null) {
            if (e.response?.data is Map && e.response?.data.containsKey('message')) {
              errorMessage = e.response?.data['message'];
            } else if (e.response?.data is String) {
              errorMessage = e.response?.data;
            }
          } else if (e.message != null) {
            errorMessage = e.message!;
          }
          print('Error: $errorMessage (Status: ${e.response?.statusCode})');
          return handler.next(e);
        },
      ),
    );

    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  /// Clear the authentication token from storage and memory
  Future<void> clearToken() async {
    _isLoggingOut = true; // Suppress stale 401 errors during logout
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
    // Ensure the header is explicitly cleared for the next request
    dio.options.headers.remove('Authorization');
    
    // Reset the flag after a short delay to allow pending requests to settle
    Future.delayed(const Duration(milliseconds: 500), () {
      _isLoggingOut = false;
    });
  }

  Future<Response> uploadProfilePicture(File image) async {
    try {
      String fileName = image.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(image.path, filename: fileName),
      });
      return await dio.post('/profile/upload-picture', data: formData);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await dio.get(path, queryParameters: queryParameters);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      return await dio.post(path, data: data, queryParameters: queryParameters);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      return await dio.put(path, data: data, queryParameters: queryParameters);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> patch(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      return await dio.patch(path, data: data, queryParameters: queryParameters);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await dio.delete(path, queryParameters: queryParameters);
    } catch (e) {
      rethrow;
    }
  }
}

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());
