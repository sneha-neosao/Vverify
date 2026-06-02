import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Set this to false to completely disable all API request/response logging in debug mode.
const bool enableApiLogging = true;

/// A custom [Interceptor] that logs Dio HTTP requests and responses using
/// the `logger` package.
///
/// Under production mode (i.e. `!kDebugMode`) or when [enableApiLogging] is false,
/// all logging is disabled completely.
class ApiLoggingInterceptor extends Interceptor {
  late final Logger _logger;

  ApiLoggingInterceptor() {
    // Override any global logger levels to ensure logs are processed
    Logger.level = Level.all;

    _logger = Logger(
      // Bypass standard DevelopmentFilter assertions so logs show up on all debug configs
      filter: ProductionFilter(),
      // Standard ConsoleOutput uses stdout/print and is 100% compatible with all IDEs and terminals
      output: ConsoleOutput(),
      printer: PrettyPrinter(
        methodCount: 0, // No method stacktrace prefix needed for simple API logs
        errorMethodCount: 5,
        lineLength: 90,
        colors: false, // Set to false to avoid ANSI escape sequences in debug consoles
        printEmojis: true,
      ),
      // Disable log output if enableApiLogging is false or not in debug mode
      level: (enableApiLogging && kDebugMode) ? Level.all : Level.off,
    );
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (enableApiLogging && kDebugMode) {
      final url = '${options.baseUrl}${options.path}';
      final buffer = StringBuffer();
      buffer.writeln('🚀 [API REQUEST] => ${options.method.toUpperCase()} $url');

      if (options.headers.isNotEmpty) {
        buffer.writeln('Headers: ${options.headers}');
      }

      if (options.queryParameters.isNotEmpty) {
        buffer.writeln('Query Params: ${options.queryParameters}');
      }

      if (options.data != null) {
        if (options.data is FormData) {
          final formData = options.data as FormData;
          final fields = formData.fields.map((f) => '${f.key}: ${f.value}').toList();
          final files = formData.files.map((f) => '${f.key}: File(${f.value.filename}, ${f.value.length} bytes)').toList();
          buffer.writeln('Body (FormData): Fields: $fields | Files: $files');
        } else {
          buffer.writeln('Body: ${options.data}');
        }
      }

      _logger.i(buffer.toString());
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (enableApiLogging && kDebugMode) {
      final url = '${response.requestOptions.baseUrl}${response.requestOptions.path}';
      final buffer = StringBuffer();
      buffer.writeln('✅ [API RESPONSE] <= ${response.statusCode} ${response.requestOptions.method.toUpperCase()} $url');

      if (response.data != null) {
        buffer.writeln('Response Data: ${response.data}');
      }

      _logger.i(buffer.toString());
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (enableApiLogging && kDebugMode) {
      final url = '${err.requestOptions.baseUrl}${err.requestOptions.path}';
      final buffer = StringBuffer();
      buffer.writeln('❌ [API ERROR] <= ${err.response?.statusCode ?? 'No Code'} ${err.requestOptions.method.toUpperCase()} $url');
      buffer.writeln('Error Message: ${err.message}');

      if (err.response?.data != null) {
        buffer.writeln('Error Data: ${err.response?.data}');
      }

      _logger.e(buffer.toString(), error: err.error, stackTrace: err.stackTrace);
    }
    super.onError(err, handler);
  }
}


