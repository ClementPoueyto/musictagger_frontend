import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:music_tagger/spotify/spotify_auth_api.dart';


import 'api_path.dart';
import 'auth_tokens.dart';

class SpotifyAuth extends ChangeNotifier {

  /// Authenticate user and and get token and user information
  ///
  /// Implemented using 'Authorization Code' flow from Spotify auth guide:
  /// https://developer.spotify.com/documentation/general/guides/authorization-guide/
  /*Future<void> authenticate(String clientId, String redirectUri) async {

    final state = _getRandomString(6);

    try {
      final result = await FlutterWebAuth.authenticate(
        url: APIPath.requestAuthorization(clientId!, redirectUri!, state),
        callbackUrlScheme: DotEnv().env['CALLBACK_URL_SCHEME']!,
      );

      // Validate state from response
      final returnedState = Uri.parse(result).queryParameters['state'];
      if (state != returnedState) throw HttpException('Invalid access');

      final code = Uri.parse(result).queryParameters['code'];
      final AuthTokens tokens = await SpotifyAuthApi.getAuthTokens(code!, redirectUri);

    } on Exception catch (e) {
      print(e);
      rethrow;
    }
  }*/


  static String _getRandomString(int length) {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }
}
