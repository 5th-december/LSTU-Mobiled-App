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
    HttpHeaders.contentTypeHeader: ContentType.json.value,
    HttpHeaders.acceptHeader: ContentType.json.value,
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

    if (response.headers[HttpHeaders.contentTypeHeader] != ContentType.json.value) {
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
    if (response.headers[HttpHeaders.contentTypeHeader] != ContentType.json.value) {
      throw new Exception('Undefined response type');
    }

    final responseBody = jsonDecode(response.body);
    return new HttpResponse(status: response.statusCode, body: responseBody);
  }

  Future<void> produceResourseAsStream(
    String url, Map<String, String> params, Stream producer,
    {String method = 'POST', List<int> expectedCodes = const[]}) async {
    final client = http.Client();
    
    http.StreamedRequest request = http.StreamedRequest(
      method,
      this._configuration.useHttps
            ? Uri.https(this._configuration.apiBase, url, params)
            : Uri.http(this._configuration.apiBase, url, params)
    );
    request.headers.addAll({HttpHeaders.contentTypeHeader: ContentType.binary.value});
    producer.listen((chunk) {
      request.sink.add(chunk);
    }, onDone: () {
      request.sink.close();
    });

    http.StreamedResponse response = await client.send(request);

    if(expectedCodes.length != 0 && !expectedCodes.contains(response.statusCode)) {
      throw new Exception('Uploading error');
    }

    return response.stream;
  }

  Future<http.ByteStream> consumeResourseAsStream(
      String url, Map<String, String> params,
      {String method = 'GET', List<int> expectedCodes = const[]}) async {
    final client = http.Client();

    http.Request request = http.Request(
        method,
        this._configuration.useHttps
            ? Uri.https(this._configuration.apiBase, url, params)
            : Uri.http(this._configuration.apiBase, url, params));

    http.StreamedResponse response = await client.send(request);

    if (expectedCodes.length != 0 && !expectedCodes.contains(response.statusCode)) {
      throw new Exception('Downloading error');
    }

    return response.stream;
  }
}
