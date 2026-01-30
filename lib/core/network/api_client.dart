import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import '../constants/api_constants.dart';
import '../errors/exceptions.dart';

class ApiClient {
  final Dio _dio;
  final CacheStore? _cacheStore;
  
  ApiClient({CacheStore? cacheStore}) 
      : _cacheStore = cacheStore,
        _dio = Dio(
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
    if (cacheStore != null) {
      _dio.interceptors.add(
        DioCacheInterceptor(
          options: CacheOptions(
            store: cacheStore,
            policy: CachePolicy.request,
            hitCacheOnErrorExcept: [401, 403],
            maxStale: const Duration(days: 7),
            priority: CachePriority.normal,
            cipher: null,
            keyBuilder: CacheOptions.defaultCacheKeyBuilder,
            allowPostMethod: false,
          ),
        ),
      );
    }
    
  }
  
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      if (response.statusCode == 304) {
        return response;
      }
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response?.statusCode;
        if (statusCode == 304) {
          return e.response!;
        }
        final errorMessage = e.response?.data is Map
            ? (e.response?.data['message']?.toString() ?? 
               e.response?.data['error']?.toString() ??
               'Server error occurred')
            : 'Server error occurred';
        throw ServerException(
          errorMessage,
          statusCode: statusCode,
        );
      } else if (e.type == DioExceptionType.connectionTimeout ||
                 e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection. Please check your network.');
      } else {
        throw NetworkException('Network error occurred: ${e.message ?? 'Unknown error'}');
      }
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
