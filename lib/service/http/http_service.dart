import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:lk_client/model/authentication/api_key.dart';

import 'package:lk_client/service/app_config.dart';

class HttpResponse {
  final int status;
  final dynamic body;

  HttpResponse({this.status, this.body});
}

abstract class HttpService {
  final AppConfig _configuration;

  final defaultHeaders = {
    HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
    HttpHeaders.acceptHeader: 'application/json',
  };

  HttpService(this._configuration);

  Future<HttpResponse> post(String url, Map<String, dynamic> body,
      [String apiJwtToken]) async {
    Uri uri;
    if (_configuration.useHttps == true) {
      uri = Uri.https(_configuration.apiBase, url);
    } else {
      uri = Uri.http(_configuration.apiBase, url);
    }

    Map<String, String> headers = defaultHeaders;
    if (apiJwtToken != null) {
      headers[HttpHeaders.authorizationHeader] = "Bearer $apiJwtToken";
    }

    try {
      final response =
          await http.post(uri, headers: headers, body: jsonEncode(body));
      final responseBody = jsonDecode(response.body);
      return new HttpResponse(status: response.statusCode, body: responseBody);
    } on Exception {
      rethrow;
    }
  }

  Future<HttpResponse> get(String url, Map<String, dynamic> params,
      [String apiJwtToken]) async {
    Uri uri;
    if (_configuration.useHttps == true) {
      uri = Uri.https(_configuration.apiBase, url, params);
    } else {
      uri = Uri.http(_configuration.apiBase, url, params);
    }

    Map<String, String> headers = defaultHeaders;
    if (apiJwtToken != null) {
      headers[HttpHeaders.authorizationHeader] = "Bearer $apiJwtToken";
    }

    final response = await http.get(uri, headers: headers);
    if(response.headers['content-type'] != 'application/json') {
      var r = response.body;
      throw new Exception('Undefined response type');
    }
    final responseBody = jsonDecode(response.body);
    return new HttpResponse(status: response.statusCode, body: responseBody);
  }
}
