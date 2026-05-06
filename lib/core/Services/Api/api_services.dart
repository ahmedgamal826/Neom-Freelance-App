

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiServices {
 ApiServices({http.Client? client})
     : _client = client ?? http.Client();

 final http.Client _client;

 // =========================
 // BASE URL
 // =========================
 static const String baseUrl =
     'https://nawaf0ev-neom-chatbot-v2.hf.space';

 // =========================
 // HF TOKEN
 // =========================
 static const String hfToken = '';

 // =========================
 // HEADERS
 // =========================
 Map<String, String> get _headers => {
  'Content-Type': 'application/json; charset=UTF-8',
  'Authorization': 'Bearer $hfToken',
 };

 // =========================
 // WAKE SERVER
 // =========================
 Future<void> wakeServer() async {
  try {
   await _client
       .get(Uri.parse(baseUrl))
       .timeout(const Duration(seconds: 30));
  } catch (_) {}
 }

 // =========================
 // SEND MESSAGE
 // =========================
 Future<ChatApiResponse> sendMessage({
  required String question,
  int topK = 4,
  double temperature = 0.1,
  int maxTokens = 500,
 }) async {
  try {
   // =========================
   // WAKE HUGGING FACE SPACE
   // =========================
   await wakeServer();

   final response = await _client
       .post(
    Uri.parse('$baseUrl/api/chat-full'),
    headers: _headers,
    body: jsonEncode({
     'question': question,
     'top_k': topK,
     'temperature': temperature,
     'max_tokens': maxTokens,
    }),
   )
       .timeout(const Duration(minutes: 10));

   // =========================
   // SUCCESS
   // =========================
   if (response.statusCode >= 200 &&
       response.statusCode < 300) {

    // FIX ARABIC ENCODING
    final data = jsonDecode(
     utf8.decode(response.bodyBytes),
    );

    return ChatApiResponse(
     answer: data['improved_answer'] ??
         data['raw_answer'] ??
         data['answer'] ??
         'No Response',
    );
   }

   // =========================
   // SERVER STARTING
   // =========================
   if (response.statusCode == 503) {
    throw const ApiException(
     'الخادم يبدأ التشغيل حالياً، حاول بعد ثواني',
    );
   }

   // =========================
   // INTERNAL SERVER ERROR
   // =========================
   if (response.statusCode == 500) {
    throw const ApiException(
     'حدث خطأ داخل AI Server',
    );
   }

   // =========================
   // OTHER ERRORS
   // =========================
   throw ApiException(
    'Server Error: ${response.statusCode}',
   );

  } on TimeoutException {

   // =========================
   // TIMEOUT
   // =========================
   throw const ApiException(
    'الخادم استغرق وقت طويل في الرد',
   );

  } catch (e) {

   // =========================
   // UNKNOWN ERROR
   // =========================
   throw ApiException(
    e.toString(),
   );
  }
 }
}

// =========================
// CHAT RESPONSE
// =========================
class ChatApiResponse {
 final String answer;

 ChatApiResponse({
  required this.answer,
 });
}

// =========================
// API EXCEPTION
// =========================
class ApiException implements Exception {
 final String message;

 const ApiException(this.message);

 @override
 String toString() => message;
}