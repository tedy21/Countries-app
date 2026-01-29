import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../errors/exceptions.dart';

class ApiClient {
  final Dio _dio;
  
  ApiClient() : _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  ) {
      _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          if (error.response != null) {
            throw ServerException(
              error.response?.data['message']?.toString() ?? 
              'Server error occurred',
              statusCode: error.response?.statusCode,
            );
          } else if (error.type == DioExceptionType.connectionTimeout ||
                     error.type == DioExceptionType.receiveTimeout) {
            throw NetworkException('Connection timeout. Please check your internet connection.');
          } else if (error.type == DioExceptionType.connectionError) {
            throw NetworkException('No internet connection. Please check your network.');
          } else {
            throw NetworkException('Network error occurred: ${error.message}');
          }
        },
      ),
    );
  }
  
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw NetworkException('Unexpected error: ${e.toString()}');
    }
  }
}
