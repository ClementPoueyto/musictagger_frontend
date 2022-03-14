import 'package:music_tagger/spotify/spotify_auth_api.dart';


class AuthTokens {
  AuthTokens(this.accessToken, this.refreshToken);
  String accessToken;
  String refreshToken;

  static String accessTokenKey = 'storify-access-token';
  static String refreshTokenKey = 'storify-refresh-token';

  AuthTokens.fromJson(Map<String, dynamic> json)
      : accessToken = json['access_token'] as String,
        refreshToken = json['refresh_token'] as String ;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'access_token': accessToken,
        'refresh_token': refreshToken,
      };


}
