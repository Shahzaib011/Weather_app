import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class NetworkHelper {
  /// Generic GET request handler
  static Future<Map<String, dynamic>> get({
    required String url,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 10));

      return _processResponse(response);
    } on SocketException {
      throw Exception('No Internet connection');
    } on HttpException {
      throw Exception('Could not find the resource');
    } on FormatException {
      throw Exception('Bad response format');
    } on TimeoutException {
      throw Exception('Connection timeout');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Handle API response
  static Map<String, dynamic> _processResponse(http.Response response) {
    final statusCode = response.statusCode;

    if (statusCode >= 200 && statusCode < 300) {
      return jsonDecode(response.body);
    } else if (statusCode == 400) {
      throw Exception('Bad request');
    } else if (statusCode == 401 || statusCode == 403) {
      throw Exception('Unauthorized request');
    } else if (statusCode == 404) {
      throw Exception('Resource not found');
    } else if (statusCode >= 500) {
      throw Exception('Server error');
    } else {
      throw Exception(
        'Error occurred with status code: $statusCode',
      );
    }
  }
}
