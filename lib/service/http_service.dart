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

class ApiEndpointConsumer {
  final AppConfig _configuration;

  final defaultHeaders = {
    HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
    HttpHeaders.acceptHeader: 'application/json',
  };

  ApiEndpointConsumer(this._configuration);

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

    final response =
        await http.post(uri, headers: headers, body: jsonEncode(body));

    if (response.headers['content-type'] != 'application/json') {
      throw new Exception('Undefined response type');
    }

    final responseBody = jsonDecode(response.body);
    return new HttpResponse(status: response.statusCode, body: responseBody);
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
    if (response.headers['content-type'] != 'application/json') {
      throw new Exception('Undefined response type');
    }

    final responseBody = jsonDecode(response.body);
    return new HttpResponse(status: response.statusCode, body: responseBody);
  }

  Future<http.ByteStream> consumeResourseAsStream(
      String url, Map<String, String> params,
      {String method = 'GET', int expectedCode = 200}) async {
    final _client = http.Client();
    http.Request request = http.Request(
        method,
        this._configuration.useHttps
            ? Uri.https(this._configuration.apiBase, url, params)
            : Uri.http(this._configuration.apiBase, url, params));

    http.StreamedResponse response = await _client.send(request);

    if (response.statusCode != expectedCode) {
      throw new Exception('Error');
    }

    return response.stream;
  }
}
