import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dynamic_365_integration/constants/http_type.dart';
import 'package:dynamic_365_integration/constants/http_uri.dart';
import 'package:dynamic_365_integration/helpers/application.dart';
import 'package:dynamic_365_integration/helpers/hive.dart';
import 'package:dynamic_365_integration/repositories/http_response.dart';
import 'package:dynamic_365_integration/screens/authentication.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppHttpClient {
  final Dio _dio = Dio();
  HttpResponseRepository<T> _errorModel<T>() => HttpResponseRepository<T>(
        response: null,
        hasError: true,
        errorMessage: "Error",
        statusCode: -1,
        errorCode: "",
      );

  static Map<String, String> generateHeaders({required bool withAuth, int? page, int? pageSize}) {
    Map<String, String> headers = {};
    if (withAuth) headers = {...headers, "Authorization": "Bearer ${AppHive().token}"};
    return headers;
  }

  static final AppHttpClient _AppHttpClient = AppHttpClient._internal();
  factory AppHttpClient() {
    return _AppHttpClient;
  }
  AppHttpClient._internal();

  /*
  Http Error hata kodları 400
   */

  Future<Response> _get({
    required Map<String, String> headers,
    required String url,
    CancelToken? cancelToken,
  }) async {
    return await _dio.get(
      url,
      options: Options(headers: headers),
      cancelToken: cancelToken,
    );
  }

  Future<Response> _post({
    required Map<String, String> headers,
    required String url,
    required dynamic data,
    CancelToken? cancelToken,
  }) async {
    return await _dio.post(
      url,
      options: Options(headers: headers),
      cancelToken: cancelToken,
      data: data,
    );
  }

  static _printError(apiUrl, headers, data, DioError dioError) {
    if (kReleaseMode) return;
    debugPrint("""
====================ERROR REQUEST====================
URL: ${apiUrl}
HEADERS: ${headers}
REQUEST-DATA: ${jsonEncode(data)}
RESPONSE-ERROR: ${dioError}
RESPONSE-DATA: ${dioError.response}
=======================================================
      """, wrapWidth: 1024);
  }

  static _printSuccess(apiUrl, headers, data, Response dioResponse) {
    if (kReleaseMode) return;
    debugPrint("""
====================SUCCESS REQUEST====================
URL: ${apiUrl}
HEADERS: ${headers}
REQUEST-DATA: ${jsonEncode(data)}
RESPONSE: ${dioResponse.data}
=======================================================
      """, wrapWidth: 1024);
  }

  Future<HttpResponseRepository<T>> call<T>({
    required HttpCallType type,
    T Function(dynamic)? fromJSON,
    String? apiUrlString,
    HttpClientApiUrl? apiUrl,
    dynamic data,
    int? page,
    int? pageSize,
    bool dynamicResponse = false,
    bool withAuth = true,
    CancelToken? cancelToken,
  }) async {
    if (fromJSON == null && dynamicResponse == false) throw ("Please set fromJSON response");
    if (type == null) throw ("Please set HttpCallType");
    Map<String, String> headers = generateHeaders(withAuth: withAuth, page: page, pageSize: pageSize);
    late Response dioResponse;
    String url = apiUrlString ?? apiUrl!.uri;
    String queryString = "";

    //#region DART BUG
    //integer to string yaptığımızda integer değerlerin sonuna %E2%80%8B ifadesi ekleniyor
    //bunu düzeltmek için aşağıdaki kod bloğunu kullanmamız gerekir.
    // print(url);
    // url = (Uri.decodeComponent(url)).replaceAll("%E2%80%8B", "");
    //#endregion

    try {
      if (type == HttpCallType.get) {
        if (data != null) {
          queryString = _getQueryString(data);
          queryString = queryString.substring(1, queryString.length);
          queryString = "?$queryString";
        }
        url = Uri.encodeFull("${url}${queryString}");
        dioResponse = await _get(
          url: url,
          cancelToken: cancelToken,
          headers: headers,
        );
      } else if (type == HttpCallType.post) {
        dioResponse = await _post(
          data: data,
          url: url,
          cancelToken: cancelToken,
          headers: headers,
        );
      }
      _printSuccess(url, headers, data, dioResponse);
      return HttpResponseRepository(
        response: dynamicResponse ? dioResponse.data : fromJSON!(dioResponse.data),
      );
    } on DioError catch (dioError) {
      _printError(url, headers, data, dioError);
      if (dioError.response!.statusCode == 401) {
        Navigator.of(ApplicationHelper().context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const AuthenticationScreen()),
          (route) => false,
        );
        return _errorModel<T>();
      }
      if (dioError.response!.statusCode == 500) {
        return _errorModel<T>();
      }
      try {
        if (dioError.response!.data["error_message"] == null && dioError.response!.data["statusMessage"] == null) return _errorModel<T>();
        return HttpResponseRepository(
          response: null,
          hasError: true,
          errorMessage: dioError.response!.data["error_message"] ?? dioError.response!.data["statusMessage"],
          statusCode: dioError.response!.data["status_code"] ?? dioError.response!.data["statusCode"],
          errorCode: dioError.response!.data["error_code"] ?? dioError.response!.data["errorCode"],
        );
      } catch (err) {
        return _errorModel<T>();
      }
    } catch (err) {
      print(err);
      return _errorModel<T>();
    }
  }

  String _getQueryString(Map params, {String prefix: '&', bool inRecursion: false}) {
    String query = '';
    params.forEach((key, value) {
      if (inRecursion) {
        key = '[$key]';
      }
      if (value is List) {
        value.forEach((element) {
          query += '$prefix$key=${Uri.encodeComponent("${element}")}';
        });
      } else if (value is String || value is int || value is double || value is bool) {
        query += '$prefix$key=${Uri.encodeComponent(value)}';
      } else if (value is List || value is Map) {
        if (value is List) value = value.asMap();
        value.forEach((k, v) {
          query += _getQueryString({k: v}, prefix: '$prefix$key', inRecursion: true);
        });
      }
    });
    return query;
  }
}
