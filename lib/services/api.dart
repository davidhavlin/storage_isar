library api;

import 'package:dio/dio.dart';

typedef Params = Map<String, dynamic>;

final api = Api();

class ApiException extends DioException implements Exception {
  @override
  final String message;
  final List<dynamic>? errors;

  ApiException({
    required super.requestOptions,
    required this.message,
    required super.stackTrace,
    super.response,
    super.type = DioExceptionType.unknown,
    this.errors,
    super.error,
  }) : super(message: message);
}

class Api {
  final baseUrl = const String.fromEnvironment(
    'API_URL',
    // defaultValue: 'https://localhost:3000',
    defaultValue: 'https://jsonplaceholder.typicode.com',
  );
  final version = 'v1';
  final client = Dio();
  String? token;

  Api() {
    client.options.baseUrl = '$baseUrl/';
    client.options.connectTimeout = const Duration(seconds: 5);
    client.options.receiveTimeout = const Duration(seconds: 10);

    client.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers = {
            'authorization': 'Bearer $token',
            ...options.headers,
          };

          print('request: ${options.uri}');

          return handler.next(options);
        },
        onError: (error, handler) {
          print(
              'request failed: ${error.requestOptions.uri}, ${error.response?.statusCode}');
          print(error.response?.data ?? error.message);

          final data = error.response?.data?['error'];
          final validation = error.response?.data?['errors'];

          String message = 'An error occurred';

          if (data != null && data['message'] != null) {
            message = data['message'];
          }

          if (validation != null && validation is List) {
            message = validation.map((e) => e['message']).join('\n');
          }

          return handler.next(
            ApiException(
              requestOptions: error.requestOptions,
              message: message,
              stackTrace: error.stackTrace,
              response: error.response,
              type: error.type,
              error: error.error,
              errors: validation,
            ),
          );
        },
      ),
    );
  }

  Future<Response<T>> get<T>(
    String path, {
    Params? params,
    Options? options,
  }) async {
    return await client.get<T>(path, queryParameters: params, options: options);
  }

  Future<T> $get<T>(String path, {Params? params, Options? options}) async {
    final response = await get<T>(path, params: params, options: options);
    return response.data!;
  }

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Params? params,
    Options? options,
  }) async {
    return await client.post<T>(
      path,
      queryParameters: params,
      data: data,
      options: options,
    );
  }

  Future<T> $post<T>(
    String path, {
    Object? data,
    Params? params,
    Options? options,
  }) async {
    final response =
        await post<T>(path, params: params, data: data, options: options);

    return response.data!;
  }

  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    Params? params,
    Options? options,
  }) async {
    return await client.patch<T>(
      path,
      queryParameters: params,
      data: data,
      options: options,
    );
  }

  Future<T> $patch<T>(
    String path, {
    Object? data,
    Params? params,
    Options? options,
  }) async {
    final response =
        await patch<T>(path, params: params, data: data, options: options);

    return response.data!;
  }

  Future<Response<T>> delete<T>(
    String path, {
    Params? params,
    Options? options,
  }) async {
    return await client.delete<T>(
      path,
      queryParameters: params,
      options: options,
    );
  }

  Future<T> $delete<T>(String path, {Params? params, Options? options}) async {
    final response = await delete<T>(path, params: params, options: options);

    return response.data!;
  }
}
