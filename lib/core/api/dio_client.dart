import 'package:dio/dio.dart';
import '../constants/app_constants.dart';

class DioClient {
  DioClient._();

  static final Dio _instance = _createDio();

  static Dio get instance => _instance;


  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        queryParameters: {
          'apikey': AppConstants.apiKey,
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout) {
            handler.reject(
              DioException(
                requestOptions: error.requestOptions,
                type: DioExceptionType.connectionTimeout,
                message: 'Connection timed out. Please try again.',
              ),
            );
            return;
          }

          if (error.type == DioExceptionType.connectionError) {
            handler.reject(
              DioException(
                requestOptions: error.requestOptions,
                type: DioExceptionType.connectionError,
                message: 'No internet connection.',
              ),
            );
            return;
          }

          handler.next(error);
        },
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        request: true,
        responseBody: true,
        error: true,
      ),
    );

    return dio;
  }
}