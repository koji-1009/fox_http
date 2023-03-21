import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:jni/jni.dart';

import 'okhttp3.dart' as okhttp3;

class OkHttpClient extends BaseClient {
  OkHttpClient();

  @override
  Future<StreamedResponse> send(
    BaseRequest request,
  ) async {
    if (_Client().client.isDeleted) {
      throw ClientException(
        'HTTP request failed. Client is already closed.',
        request.url,
      );
    }

    return compute(
      _execute,
      request,
    );
  }
}

StreamedResponse _execute(
  BaseRequest httpRequest,
) {
  final requestBuilder = okhttp3.Request_Builder()
    ..url1(httpRequest.url.toString().toJString())
    ..headers(
      _createHeaders(
        headers: httpRequest.headers,
      ),
    );

  final method = _HttpMethod.values.firstWhere(
    (element) => element.code == httpRequest.method,
    orElse: () => throw ClientException(
      '${httpRequest.method} is not supported',
    ),
  );

  final okhttp3.Request okHttpRequest;
  if (httpRequest is Request) {
    switch (method) {
      case _HttpMethod.delete:
        if (httpRequest.body.isNotEmpty) {
          final body = okhttp3.RequestBody.create(
            httpRequest.body.toJString(),
            okhttp3.MediaType.parse('application/json'.toJString()),
          );
          okHttpRequest = requestBuilder.delete1(body).build();
        } else {
          okHttpRequest = requestBuilder.delete2().build();
        }
        break;
      case _HttpMethod.get:
        okHttpRequest = requestBuilder.get0().build();
        break;
      case _HttpMethod.head:
        okHttpRequest = requestBuilder.head().build();
        break;
      case _HttpMethod.patch:
        final body = okhttp3.RequestBody.create(
          httpRequest.body.toJString(),
          okhttp3.MediaType.parse('application/json'.toJString()),
        );
        okHttpRequest = requestBuilder.patch(body).build();
        break;
      case _HttpMethod.post:
        final body = okhttp3.RequestBody.create(
          httpRequest.body.toJString(),
          okhttp3.MediaType.parse('application/json'.toJString()),
        );
        okHttpRequest = requestBuilder.post(body).build();
        break;
      case _HttpMethod.put:
        final body = okhttp3.RequestBody.create(
          httpRequest.body.toJString(),
          okhttp3.MediaType.parse('application/json'.toJString()),
        );
        okHttpRequest = requestBuilder.put(body).build();
        break;
    }
  } else if (httpRequest is MultipartRequest) {
    /// TODO: implementation
    final bodyBuilder = okhttp3.MultipartBody_Builder(
      okhttp3.UUID.randomUUID().toString1(),
    );
    final body = bodyBuilder.build();
    bodyBuilder.delete();

    switch (method) {
      case _HttpMethod.patch:
        okHttpRequest = requestBuilder.patch(body).build();
        break;
      case _HttpMethod.post:
        okHttpRequest = requestBuilder.post(body).build();
        break;
      case _HttpMethod.put:
        okHttpRequest = requestBuilder.put(body).build();
        break;
      case _HttpMethod.delete:
      case _HttpMethod.get:
      case _HttpMethod.head:
        throw ClientException('$method is not supported');
    }
  } else {
    throw ClientException('${httpRequest.runtimeType} is not supported');
  }
  requestBuilder.delete();

  final client = _Client().client;
  final okHttpResponse = client.newCall(okHttpRequest).execute();
  okHttpRequest.delete();

  final body = okHttpResponse.body().bytes();
  final contentLength = body.length;
  final bytes = <int>[];
  for (var i = 0; i < contentLength; i++) {
    bytes.add(body[i]);
  }

  final headers = <String, String>{};
  final responseHeaders = okHttpResponse.headers();
  final headerSize = responseHeaders.size();
  for (var i = 0; i < headerSize; i++) {
    final key = responseHeaders.name(i).toDartString();
    final value = responseHeaders.value(i).toDartString();
    headers[key] = value;
  }

  final code = okHttpResponse.code();
  final isRedirect = okHttpResponse.isRedirect();
  final message = okHttpResponse.message().toDartString();

  okHttpResponse.delete();
  return StreamedResponse(
    Stream.value(bytes),
    code,
    contentLength: contentLength,
    request: httpRequest,
    headers: headers,
    isRedirect: isRedirect,
    reasonPhrase: message,
  );
}

okhttp3.Headers _createHeaders({
  required Map<String, String> headers,
}) {
  final builder = okhttp3.Headers_Builder();
  for (final entry in headers.entries) {
    builder.add1(
      entry.key.toJString(),
      entry.value.toJString(),
    );
  }

  return builder.build();
}

class _Client {
  static final _Client _singleton = _Client._internal();

  factory _Client() => _singleton;

  _Client._internal();

  final client = okhttp3.OkHttpClient_Builder().build();
}

enum _HttpMethod {
  delete('DELETE'),
  get('GET'),
  head('HEAD'),
  patch('PATCH'),
  post('POST'),
  put('PUT');

  const _HttpMethod(this.code);

  final String code;
}
