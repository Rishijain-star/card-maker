import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:get/get.dart' as getx;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../routes/app_pages.dart';
import '../services/local_storage_services/local_storage_services.dart';
import '../services/secure_token_service/secure_token_service.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  static Dio? _dio;

  factory ApiClient() {
    if (_dio == null) _instance._initDio();
    return _instance;
  }

  ApiClient._internal();

  void _initDio() {
    // Default targets Android emulator -> host machine Laravel server.
    // Override at run time for web/physical device with:
    // --dart-define=APP_API_BASE_URL=http://127.0.0.1:8000/api/v1/
    // --dart-define=APP_API_BASE_URL=http://<LAN_IP>:8000/api/v1/
    const configuredBase = String.fromEnvironment(
      'APP_API_BASE_URL',
      defaultValue: 'http://127.0.0.1:8000/api/v1/',
    );
    _dio = Dio(
      BaseOptions(
        receiveTimeout: const Duration(seconds: 30),
        connectTimeout: const Duration(seconds: 30),
        baseUrl: configuredBase,
      ),
    );

    _dio!.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true, //
        responseBody: true,
      ),
    );

    _dio!.interceptors.addAll([
      RetryInterceptor(
        dio: _dio!,
        retries: 3,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 3),
        ],
      ),
    ]);

    // âœ… Fixed Interceptor - Token automatically add kar raha hai
    _dio!.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          final secureToken = await SecureTokenService().getAuthToken();
          final authToken = secureToken.isNotEmpty
              ? secureToken
              : LocalStorageService().getAuthToken();
          if (authToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $authToken';
          }

          return handler.next(options);
        },
        onError: (error, handler) async {
          print("API Error: ${error.response?.statusCode}");

          if (error.response?.statusCode == 401) {
            print("Unauthorized - Token might be expired");
            await LocalStorageService().logout();
            getx.Get.offAllNamed(Routes.WELCOME);
          }

          return handler.next(error);
        },
      ),
    );
  }

  // âœ… Simplified getHeaders method
  Map<String, String> getHeaders({
    bool isMultipart = false,
    bool includeAuth = true,
  }) {
    final token = LocalStorageService().getAuthToken();
    final headers = <String, String>{
      "Content-Type": isMultipart ? "multipart/form-data" : "application/json",
      "Accept": "application/json",
    };
    if (includeAuth && token.isNotEmpty) {
      headers["Authorization"] = "Bearer $token";
    }
    return headers;
  }

  Future<T?> _makeRequest<T>(Future<Response> request) async {
    try {
      Response response = await request;
      return _parseResponse<T>(response);
    } on DioException catch (e) {
      print("DioException_line_103: ${e.message}");
      print("Status Code_line_104 ${e.response?.statusCode}");
      print("Response Data_line_10 ${e.response?.data}");
      return ApiException(dioException: e).apiExceptionResponse() as T?;
    }
  }

  // âœ… GET request - Headers properly add kiye
  Future<Map<String, dynamic>?> getRequest({
    required String endPoint,
    bool includeAuth = true,
  }) async {
    return await _makeRequest<Map<String, dynamic>>(
      _dio!.get(
        endPoint,
        options: Options(headers: getHeaders(includeAuth: includeAuth)),
      ),
    );
  }

  // âœ… POST request - Simple version
  Future<Map<String, dynamic>?> postRequest({
    required String endPoint,
    required dynamic body,
    bool includeAuth = true,
  }) async {
    return await _makeRequest<Map<String, dynamic>>(
      _dio!.post(
        endPoint,
        data: body,
        options: Options(headers: getHeaders(includeAuth: includeAuth)),
      ),
    );
  }

  // âœ… PUT request - Headers properly add kiye
  Future<Map<String, dynamic>?> putRequest({
    required String endPoint,
    required dynamic body,
    bool? isMultipart,
    bool includeAuth = true,
  }) async {
    return await _makeRequest<Map<String, dynamic>>(
      _dio!.put(
        endPoint,
        data: body,
        options: Options(
          headers: getHeaders(
            isMultipart: isMultipart ?? false,
            includeAuth: includeAuth,
          ),
        ),
      ),
    );
  }

  // âœ… DELETE request - Headers properly add kiye
  Future<Map<String, dynamic>?> deleteRequest({
    required String endPoint,
    required dynamic body,
    bool includeAuth = true,
  }) async {
    return await _makeRequest<Map<String, dynamic>>(
      _dio!.delete(
        endPoint,
        data: body,
        options: Options(headers: getHeaders(includeAuth: includeAuth)),
      ),
    );
  }

  // âœ… PATCH request - Headers properly add kiye
  Future<Map<String, dynamic>?> patchRequest({
    required String endPoint,
    required dynamic body,
    bool includeAuth = true,
  }) async {
    return await _makeRequest<Map<String, dynamic>>(
      _dio!.patch(
        endPoint,
        data: body,
        options: Options(headers: getHeaders(includeAuth: includeAuth)),
      ),
    );
  }

  Future<Map<String, dynamic>?> uploadFileRequest({
    required String endPoint,
    required String filePath,
    String fileField = 'file',
    Map<String, dynamic>? extraFields,
    ProgressCallback? onSendProgress,
    bool includeAuth = true,
  }) async {
    final fileName = filePath.split(RegExp(r'[\\/]')).last;
    final formData = FormData.fromMap({
      ...(extraFields ?? const {}),
      fileField: await MultipartFile.fromFile(filePath, filename: fileName),
    });

    return await _makeRequest<Map<String, dynamic>>(
      _dio!.post(
        endPoint,
        data: formData,
        onSendProgress: onSendProgress,
        options: Options(
          headers: getHeaders(isMultipart: true, includeAuth: includeAuth),
        ),
      ),
    );
  }

  T _parseResponse<T>(Response response) {
    print("Response Status Code: ${response.statusCode}");

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 400) {
      return response.data as T;
    } else {
      return ApiException(response: response).apiExceptionResponse() as T;
    }
  }
}

class ApiException implements Exception {
  DioException? dioException;
  Response? response;

  ApiException({this.dioException, this.response});

  Map<String, dynamic>? apiExceptionResponse() {
    if (dioException != null) {
      final d = dioException!;
      final code = d.response?.statusCode;

      if (d.type == DioExceptionType.connectionError) {
        _logError('Connection error');
      } else if (d.type == DioExceptionType.connectionTimeout ||
          d.type == DioExceptionType.receiveTimeout ||
          d.type == DioExceptionType.sendTimeout) {
        _logError('Connection timeout');
      } else if (code == 400) {
        final msg = d.response?.data is Map
            ? '${(d.response!.data as Map)['message'] ?? 'Bad Request'}'
            : 'Bad Request';
        _logError(msg);
      } else if (code == 401) {
        LocalStorageService().logout();
        getx.Get.offAllNamed(Routes.WELCOME);
      } else if (code == 403) {
        LocalStorageService().logout();
      } else if (code == 404) {
        final msg = d.response?.data is Map ? '${(d.response!.data as Map)['message'] ?? ''}' : '';
        if (msg.isNotEmpty && !msg.contains('route') && !msg.contains('could not be found')) {
          _logError(msg);
        }
      } else if (code == 420) {
        return d.response?.data;
      } else if (code == 422) {
        final body = d.response?.data;
        if (body is Map<String, dynamic>) return body;
        if (body is Map) return Map<String, dynamic>.from(body);
        return <String, dynamic>{'message': 'Validation failed'};
      }
      return null;
    }

    switch (response?.statusCode) {
      case 204:
        return {"message": "Updated Successfully"};
      case 400:
        _logError('Bad request: ${response?.data}');
        return null;
      case 403:
        getx.Get.offAllNamed(Routes.WELCOME);
        _logError('Authentication error 403: ${response?.data}');
        return null;
      case 404:
        _logError('Not found: ${response?.data}');
        return null;
      case 500:
      case 502:
      case 503:
        _logError('Server error: ${response?.data}');
        return null;
      case 401:
        _logError('Unauthorized : ${response?.data}');
        LocalStorageService().logout();
        getx.Get.offAllNamed(Routes.WELCOME);
        return null;
      default:
        _logError('API error: ${response?.data}');
        return null;
    }
  }

  void _logError(String message) {
    print(message);
  }
}

