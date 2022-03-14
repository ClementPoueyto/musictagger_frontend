import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'api_path.dart';
import 'auth_tokens.dart';

class SpotifyAuthApi {
  static final clientId = dotenv.env['CLIENT_ID'];
  static final clientSecret = dotenv.env['CLIENT_SECRET'];
  static final base64Credential =
      utf8.fuse(base64).encode('$clientId:$clientSecret');

  static Future<AuthTokens> getAuthTokens(
      String code, String redirectUri) async {
    final response = await http.post(
      Uri.parse(APIPath.requestToken),
      body: {
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': redirectUri,
      },
      headers: {HttpHeaders.authorizationHeader: 'Basic $base64Credential'},
    );

    if (response.statusCode == 200) {
      final String body = response.body;
      return AuthTokens.fromJson(json.decode(body) as Map<String, dynamic>);
    } else {
      throw Exception(
          'Failed to load token with status code ${response.statusCode}');
    }
  }


}
