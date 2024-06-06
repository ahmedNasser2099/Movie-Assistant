import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_assistant/constants.dart';

class GeminiService {
  final String apiKey = Constants.geminiApiKey;
  final String baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?';

  Future<String> sendMessage(String message) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({'prompt': {'text': message}}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData['candidates'][0]['output'] ?? 'No response from AI';
    } else {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData['error']['message'] ?? 'Failed to get response';
    }
  }
}
