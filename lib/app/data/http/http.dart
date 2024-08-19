import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:http/http.dart';
import 'package:tv/app/domain/either.dart';

part 'failure.dart';
part 'parse_response_body.dart';

enum HttpMethod { get, post, patch, delete, put }

class Http {
  final Client _client;
  final String _baseUrl;
  final String _apiKey;

  Http({
    required Client client,
    required String baseUrl,
    required String apiKey,
  })  : _client = client,
        _apiKey = apiKey,
        _baseUrl = baseUrl;

  Future<Either<HttpFailure, R>> request<R>(
    String path, {
    required R Function(dynamic responseBody) onSuccess,
    HttpMethod method = HttpMethod.get,
    Map<String, String> headers = const {},
    Map<String, String> queryParams = const {},
    Map<String, dynamic> body = const {},
    bool useApiKey = true,
  }) async {
    Map<String, dynamic> logs = {};
    try {
      if (useApiKey) {
        queryParams = {...queryParams, 'api_key': _apiKey};
      }
      Uri url = Uri.parse(
        path.startsWith('http') ? path : '$_baseUrl$path',
      );
      if (queryParams.isNotEmpty) {
        url = url.replace(queryParameters: queryParams);
      }

      headers = {'Content-Type': 'application/json', ...headers};

      late final Response response;
      final bodyString = jsonEncode(body);
      // guardar el log
      logs = {
        'url': url.toString(),
        'method': method.name,
        'body': body,
      };

      switch (method) {
        case HttpMethod.get:
          response = await _client.get(url);
          break;
        case HttpMethod.post:
          response = await _client.post(
            url,
            headers: headers,
            body: bodyString,
          );
          break;
        case HttpMethod.patch:
          response = await _client.patch(
            url,
            headers: headers,
            body: bodyString,
          );
          break;
        case HttpMethod.delete:
          response = await _client.delete(
            url,
            headers: headers,
            body: bodyString,
          );
          break;
        case HttpMethod.put:
          response = await _client.put(
            url,
            headers: headers,
            body: bodyString,
          );
          break;
      }

      final statusCode = response.statusCode;
      final responseBody = _parseResponseBody(response.body);
      logs = {
        ...logs,
        'statusCode': statusCode,
        'respondeBody': response.body,
        'reponseBody': responseBody,
      };
      if (statusCode >= 200 && statusCode < 300) {
        // si no entra aca es porque hubo un error en el proceso
        return Either.right(
          onSuccess(
            responseBody,
          ),
        );
      }
      return Either.left(
        HttpFailure(
          statusCode: statusCode,
        ),
      );
    } catch (e, stackTrace) {
      logs = {
        ...logs,
        'exception': e.runtimeType,
        'stackTrace': stackTrace.toString(),
      };
      if (e is SocketException || e is ClientException) {
        logs = {...logs, 'exception': 'NetworkExeption'};
        return Either.left(
          HttpFailure(
            exception: NetworkException(),
          ),
        );
      }
      return Either.left(
        HttpFailure(exception: e),
      );
    } finally {
      print(logs);
    }
  }
}
