import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  ApiServices({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  String? _lastReachableBaseUrl;

  String get baseUrl {
    final configuredBaseUrl = _sanitizeBaseUrl(
      dotenv.env['NEOM_API_BASE_URL']?.trim() ?? '',
    );

    if (configuredBaseUrl.isNotEmpty) {
      // Guard against Android-emulator URL when app runs on desktop/web.
      if (!_isAndroidPlatform && configuredBaseUrl.contains('10.0.2.2')) {
        return 'http://127.0.0.1:8000';
      }
      return configuredBaseUrl;
    }
    return _platformDefaultBaseUrl;
  }

  String get resolvedBaseUrl => _lastReachableBaseUrl ?? baseUrl;

  bool get _isAndroidPlatform => !kIsWeb && Platform.isAndroid;

  String _sanitizeBaseUrl(String url) {
    if (url.isEmpty) {
      return '';
    }

    // Accept only the URL token in case the env value has extra text/emojis.
    final normalized = url.split(RegExp(r'\s+')).first.trim();

    if (normalized.endsWith('/')) {
      return normalized.substring(0, normalized.length - 1);
    }
    return normalized;
  }

  String get _platformDefaultBaseUrl {
    if (kIsWeb) {
      return 'http://127.0.0.1:8000';
    }
    if (_isAndroidPlatform) {
      // Android emulator reaches local machine through 10.0.2.2.
      return 'http://10.0.2.2:8000';
    }
    return 'http://127.0.0.1:8000';
  }

  List<String> get _candidateBaseUrls {
    final primary = baseUrl;
    final candidates = <String>[primary];
    if (_isAndroidPlatform) {
      if (primary.contains('127.0.0.1')) {
        candidates.add('http://10.0.2.2:8000');
      } else if (primary.contains('10.0.2.2')) {
        candidates.add('http://127.0.0.1:8000');
      }
    }
    return candidates.toSet().toList();
  }

  Future<ModelStatus> getStatus() async {
    ApiException? lastConnectionError;

    for (final candidate in _candidateBaseUrls) {
      try {
        final response = await _client
            .get(Uri.parse('$candidate/api/status'))
            .timeout(const Duration(seconds: 12));

        if (response.statusCode >= 200 && response.statusCode < 300) {
          _lastReachableBaseUrl = candidate;
          return ModelStatus.fromJson(_decodeJson(response.bodyBytes));
        }
        throw ApiException(_extractApiError(response), response.statusCode);
      } on SocketException {
        lastConnectionError = ApiException(
          'تعذر الاتصال بالسيرفر على $candidate.',
        );
      } on TimeoutException {
        lastConnectionError = const ApiException(
          'انتهت مهلة الاتصال بالسيرفر. تحقق من الشبكة أو من حالة الخادم.',
        );
      } on FormatException {
        throw const ApiException('استجابة غير صالحة من السيرفر.');
      }
    }

    throw lastConnectionError ??
        ApiException(
          'تعذر الاتصال بالسيرفر على ${_candidateBaseUrls.join(' أو ')}. '
          'تأكد من تشغيل FastAPI وأن عنوان السيرفر صحيح.',
        );
  }

  Future<LoadModelResult> loadModel({
    String modelName = 'google/gemma-2-2b-it',
    String dataPath = 'NEOM_Clean_V5_Expanded.csv',
    bool useCachedIndex = true,
  }) async {
    final requestBaseUrl = resolvedBaseUrl;
    try {
      final response = await _client
          .post(
            Uri.parse('$requestBaseUrl/api/load'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'model_name': modelName,
              'data_path': dataPath,
              'use_cached_index': useCachedIndex,
            }),
          )
          .timeout(const Duration(minutes: 12));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return LoadModelResult.fromJson(_decodeJson(response.bodyBytes));
      }
      throw ApiException(_extractApiError(response), response.statusCode);
    } on SocketException {
      throw ApiException(
        'تعذر الاتصال بالسيرفر على $requestBaseUrl. تأكد من تشغيل python main.py أولاً. '
        'إذا كنت على موبايل حقيقي استخدم IP الجهاز المحلي.',
      );
    } on TimeoutException {
      throw const ApiException(
        'تحميل المودل استغرق وقتاً أطول من المتوقع. قد يكون التحميل ما زال جارياً على الخادم.',
      );
    }
  }

  Future<ChatApiResponse> sendMessage({
    required String question,
    int topK = 5,
    double temperature = 0.1,
    int maxTokens = 220,
  }) async {
    final requestBaseUrl = resolvedBaseUrl;
    try {
      final response = await _client
          .post(
            Uri.parse('$requestBaseUrl/api/chat'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'question': question,
              'top_k': topK,
              'temperature': temperature,
              'max_tokens': maxTokens,
            }),
          )
          .timeout(const Duration(minutes: 6));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ChatApiResponse.fromJson(_decodeJson(response.bodyBytes));
      }
      throw ApiException(_extractApiError(response), response.statusCode);
    } on SocketException {
      throw ApiException(
        'السيرفر غير متصل على $requestBaseUrl. حاول إعادة فحص الاتصال ثم أعد المحاولة.',
      );
    } on TimeoutException {
      throw const ApiException('انتهت مهلة إرسال الرسالة. حاول مجدداً.');
    }
  }

  Map<String, dynamic> _decodeJson(List<int> bodyBytes) {
    final decoded = jsonDecode(utf8.decode(bodyBytes));
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    throw const ApiException('صيغة الاستجابة من السيرفر غير متوقعة.');
  }

  String _extractApiError(http.Response response) {
    try {
      final body = _decodeJson(response.bodyBytes);
      final detail = body['detail'] ?? body['message'] ?? body['error'];
      if (detail is String && detail.trim().isNotEmpty) {
        return detail;
      }
    } catch (_) {
      // Keep generic fallback message.
    }
    return 'حدث خطأ من السيرفر: ${response.statusCode}';
  }
}

class ModelStatus {
  const ModelStatus({
    required this.modelLoaded,
    required this.dataLoaded,
    required this.totalQuestions,
    required this.modelName,
    required this.gpuAvailable,
  });

  final bool modelLoaded;
  final bool dataLoaded;
  final int totalQuestions;
  final String modelName;
  final bool gpuAvailable;

  factory ModelStatus.fromJson(Map<String, dynamic> json) {
    return ModelStatus(
      modelLoaded: json['model_loaded'] == true,
      dataLoaded: json['data_loaded'] == true,
      totalQuestions: (json['total_questions'] as num?)?.toInt() ?? 0,
      modelName: (json['model_name'] as String?) ?? '',
      gpuAvailable: json['gpu_available'] == true,
    );
  }
}

class LoadModelResult {
  const LoadModelResult({
    required this.success,
    required this.message,
    required this.model,
    required this.questionsCount,
    required this.indexSource,
    required this.gpu,
  });

  final bool success;
  final String message;
  final String model;
  final int questionsCount;
  final String indexSource;
  final bool gpu;

  factory LoadModelResult.fromJson(Map<String, dynamic> json) {
    return LoadModelResult(
      success: json['success'] == true,
      message: (json['message'] as String?) ?? '',
      model: (json['model'] as String?) ?? '',
      questionsCount: (json['questions_count'] as num?)?.toInt() ?? 0,
      indexSource: (json['index_source'] as String?) ?? '',
      gpu: json['gpu'] == true,
    );
  }
}

class ChatApiResponse {
  const ChatApiResponse({
    required this.answer,
    required this.retrievedQuestions,
    required this.modelUsed,
  });

  final String answer;
  final List<String> retrievedQuestions;
  final String modelUsed;

  factory ChatApiResponse.fromJson(Map<String, dynamic> json) {
    return ChatApiResponse(
      answer: (json['answer'] as String?) ?? '',
      retrievedQuestions: (json['retrieved_questions'] as List<dynamic>? ?? [])
          .map((item) => item.toString())
          .toList(),
      modelUsed: (json['model_used'] as String?) ?? '',
    );
  }
}

class ApiException implements Exception {
  const ApiException(this.message, [this.statusCode]);

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}
