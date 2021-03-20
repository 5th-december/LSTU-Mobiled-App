import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:lk_client/exception/api_exception.dart';
import 'package:lk_client/model/response/jwt_token.dart';

import 'package:lk_client/service/app_config.dart';

class HttpResponse
{
  final int status;
  final Map<String, dynamic> body;

  HttpResponse({this.status, this.body});
}

abstract class HttpService
{
  final AppConfig _configuration;
  final jsonHeaders = {
    HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
    HttpHeaders.acceptHeader: 'application/json',
  };

  HttpService(this._configuration);

  Future<HttpResponse> post(String url, Map<String, dynamic> body, [JwtToken authToken]) async {
    final Uri uri = Uri.https(_configuration.apiBase, url);

    Map<String, String> headers = jsonHeaders;
    if (authToken != null) {
      headers[HttpHeaders.authorizationHeader] = authToken.token;
    }

    try {
      final response = await http.post(
        uri,
        headers: headers,
        body: body
      );
      final responseBody = jsonDecode(response.body);
      return new HttpResponse(status: response.statusCode, body: responseBody);
    } on SocketException {
      throw ApiException(message: '');
    } on FormatException {
      throw ApiException(message: '');
    }
  }

  Future<HttpResponse> get(String url, Map<String, dynamic> params, [JwtToken authToken]) async {
    if (params.length != 0) {
      List<String> queryData = [];
      params.forEach((key, value) {
        queryData.add("${Uri.encodeComponent(key)}=${Uri.encodeComponent(value)}");
      });
      url = "$url?${queryData.join('&')}";
    }

    final Uri uri = Uri.https(_configuration.apiBase, url);
    
    Map<String, String> headers = jsonHeaders;
    if (authToken != null) {
      headers[HttpHeaders.authorizationHeader] = authToken.token;
    }

    try {
      final response = await http.get(uri, headers: headers);
      final responseBody = jsonDecode(response.body);
      return new HttpResponse(status: response.statusCode, body: responseBody);
    } on SocketException {
      throw ApiException(message: '');
    } on HttpException {
      throw ApiException(message: '');
    }
  }
}