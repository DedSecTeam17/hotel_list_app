import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:hotel_list_app/core/constants/status_code.dart';
import 'package:http/http.dart' as http;

class FakeHttpClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      final String jsonString =
          await rootBundle.loadString('assets/hotels.json');

      return http.StreamedResponse(
        Stream.fromIterable([utf8.encode(jsonString)]),
        StatusCode.success,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );
    } catch (e) {
      return http.StreamedResponse(
        Stream.fromIterable(utf8.encode('{"error": "Mock server error"}')
            as Iterable<List<int>>),
        StatusCode.internalServerError,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );
    }
  }
}
