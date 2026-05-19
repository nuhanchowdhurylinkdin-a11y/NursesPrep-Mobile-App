import 'dart:async';
import 'dart:convert';
// import 'dart:developer';
import 'package:get/get.dart' hide Response, MultipartFile;
import 'package:http/http.dart';

import '../models/response_data.dart';
import '../utils/constants/api_constants.dart';
import '../services/storage_service.dart';
import '../../routes/app_routes.dart';

class NetworkCaller {
  final int timeoutDuration = 40;
  static bool _isRefreshing = false;
  static bool _isLoggingOut = false;
  static Completer<bool>? _refreshCompleter;

  Map<String, String> _buildHeaders({String? token}) {
    return {
      if (token != null) 'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  // GET method
  Future<ResponseData> getRequest(String url, {String? token}) async {
    // log('GET Request: $url');
    try {
      final Response response = await get(
        Uri.parse(url),
        headers: _buildHeaders(token: token ?? StorageService.accessToken),
      ).timeout(
        Duration(seconds: timeoutDuration),
      );

      if (response.statusCode == 401 && url != ApiConstants.refreshToken) {
        final refreshed = await _refreshTokens();
        if (refreshed) {
          return getRequest(url, token: StorageService.accessToken);
        }
      }

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // POST method
  Future<ResponseData> postRequest(String url,
      {Map<String, dynamic>? body, String? token}) async {
    // log('POST Request: $url');

    try {
      final Response response = await post(
        Uri.parse(url),
        headers: _buildHeaders(token: token ?? StorageService.accessToken),
        body: body == null ? null : jsonEncode(body),
      ).timeout(Duration(seconds: timeoutDuration));

      if (response.statusCode == 401 &&
          url != ApiConstants.refreshToken &&
          !_isAuthEndpoint(url)) {
        final refreshed = await _refreshTokens();
        if (refreshed) {
          return postRequest(url, body: body, token: StorageService.accessToken);
        }
      }

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // PATCH method (JSON body)
  Future<ResponseData> patchRequest(String url,
      {Map<String, dynamic>? body, String? token}) async {
    // log('PATCH Request: $url');

    try {
      final Response response = await patch(
        Uri.parse(url),
        headers: _buildHeaders(token: token ?? StorageService.accessToken),
        body: body == null ? null : jsonEncode(body),
      ).timeout(Duration(seconds: timeoutDuration));

      if (response.statusCode == 401 && !_isAuthEndpoint(url)) {
        final refreshed = await _refreshTokens();
        if (refreshed) {
          return patchRequest(url, body: body, token: StorageService.accessToken);
        }
      }

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // DELETE method
  Future<ResponseData> deleteRequest(String url, {String? token}) async {
    // log('DELETE Request: $url');
    try {
      final Response response = await delete(
        Uri.parse(url),
        headers: _buildHeaders(token: token ?? StorageService.accessToken),
      ).timeout(Duration(seconds: timeoutDuration));

      if (response.statusCode == 401 && !_isAuthEndpoint(url)) {
        final refreshed = await _refreshTokens();
        if (refreshed) {
          return deleteRequest(url, token: StorageService.accessToken);
        }
      }

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // PATCH multipart (form-data)
  Future<ResponseData> patchMultipart(
    String url, {
    Map<String, String>? fields,
    String? filePath,
    String? fileField,
    String? token,
  }) async {
    // log('PATCH Multipart: $url');

    try {
      final request = MultipartRequest('PATCH', Uri.parse(url));
      request.headers['Authorization'] =
          'Bearer ${token ?? StorageService.accessToken}';

      if (fields != null) {
        request.fields.addAll(fields);
      }

      if (filePath != null && fileField != null) {
        request.files.add(
          await MultipartFile.fromPath(fileField, filePath),
        );
      }

      final streamedResponse =
          await request.send().timeout(Duration(seconds: timeoutDuration));
      final response = await Response.fromStream(streamedResponse);

      if (response.statusCode == 401) {
        final refreshed = await _refreshTokens();
        if (refreshed) {
          return patchMultipart(
            url,
            fields: fields,
            filePath: filePath,
            fileField: fileField,
            token: StorageService.accessToken,
          );
        }
      }

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // ─── Token Refresh ────────────────────────────────────────────

  Future<bool> refreshTokens() => _refreshTokens();

  Future<bool> _refreshTokens() async {
    // If already refreshing, wait for the result
    if (_isRefreshing) {
      return _refreshCompleter?.future ?? Future.value(false);
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<bool>();

    try {
      final refreshToken = StorageService.refreshToken;
      if (refreshToken == null) {
        _onRefreshFailed();
        return false;
      }

      // log('Refreshing tokens with: ${refreshToken.substring(0, 20)}...');
      final Response response = await post(
        Uri.parse(ApiConstants.refreshToken),
        headers: {
          'Authorization': 'Bearer $refreshToken',
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: timeoutDuration));

      // log('Refresh response status: ${response.statusCode}');
      // log('Refresh response body: ${response.body}');

      final decoded = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) && decoded['success'] == true) {
        final data = decoded['data'];
        await StorageService.updateTokens(
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'],
        );
        // log('Tokens refreshed successfully');
        _refreshCompleter?.complete(true);
        return true;
      } else {
        _onRefreshFailed();
        return false;
      }
    } catch (e) {
      // log('Token refresh error: $e');
      _onRefreshFailed();
      return false;
    } finally {
      _isRefreshing = false;
      _refreshCompleter = null;
    }
  }

  bool _isAuthEndpoint(String url) {
    return url.startsWith('${ApiConstants.baseUrl}/auth/');
  }

  void _onRefreshFailed() {
    _refreshCompleter?.complete(false);
    if (_isLoggingOut) return;
    _isLoggingOut = true;
    StorageService.logoutUser();
    Get.offAllNamed(AppRoute.getWelcomeScreen());
    Future.delayed(const Duration(seconds: 2), () => _isLoggingOut = false);
  }

  // Handle response
  ResponseData _handleResponse(Response response) {
    // log('Response Status: ${response.statusCode}');
    // log('Response Body: ${response.body}');

    dynamic decodedResponse;
    try {
      decodedResponse = jsonDecode(response.body);
    } on FormatException {
      return ResponseData(
        isSuccess: false,
        statusCode: response.statusCode,
        responseData: response.body,
        errorMessage: 'Invalid response from server.',
      );
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (decodedResponse['success'] == true) {
        return ResponseData(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: decodedResponse,
          errorMessage: '',
        );
      } else {
        return ResponseData(
          isSuccess: false,
          statusCode: response.statusCode,
          responseData: decodedResponse,
          errorMessage: decodedResponse['message'] ?? 'Unknown error occurred',
        );
      }
    } else if (response.statusCode == 400) {
      final extracted = _extractErrorMessages(decodedResponse['errorSources']);
      return ResponseData(
        isSuccess: false,
        statusCode: response.statusCode,
        responseData: decodedResponse,
        errorMessage: extracted != 'Validation error'
            ? extracted
            : decodedResponse['message'] ?? 'Validation error',
      );
    } else if (response.statusCode == 500) {
      return ResponseData(
        isSuccess: false,
        statusCode: response.statusCode,
        responseData: decodedResponse,
        errorMessage:
            decodedResponse['message'] ?? 'An unexpected error occurred!',
      );
    } else {
      return ResponseData(
        isSuccess: false,
        statusCode: response.statusCode,
        responseData: decodedResponse,
        errorMessage: decodedResponse['message'] ?? 'An unknown error occurred',
      );
    }
  }

  // Extract error messages for status 400
  String _extractErrorMessages(dynamic errorSources) {
    if (errorSources is List && errorSources.isNotEmpty) {
      return errorSources
          .map((error) => error['message'] ?? 'Unknown error')
          .join(', ');
    }
    return 'Validation error';
  }

  // Handle errors
  ResponseData _handleError(dynamic error) {
    // log('Request Error: $error');

    if (error is ClientException) {
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        responseData: '',
        errorMessage: 'Network error occurred. Please check your connection.',
      );
    } else if (error is TimeoutException) {
      return ResponseData(
        isSuccess: false,
        statusCode: 408,
        responseData: '',
        errorMessage: 'Request timeout. Please try again later.',
      );
    } else {
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        responseData: '',
        errorMessage: 'Unexpected error occurred.',
      );
    }
  }
}
