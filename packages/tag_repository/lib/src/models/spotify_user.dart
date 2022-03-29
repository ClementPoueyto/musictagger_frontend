import 'package:equatable/equatable.dart';

class SpotifyUser {
  SpotifyUser( this.spotifyAccessToken, this.spotifyRefreshToken);

  String spotifyAccessToken;

  String spotifyRefreshToken;

  final int expiresIn = 3600;

  @override
  List<Object> get props => [spotifyRefreshToken, spotifyAccessToken, expiresIn];

  static final empty = SpotifyUser('', '');

  Map<String, dynamic> toJson(){
    final Map<String, String> data = new Map<String, String>();
    data['accessToken'] = spotifyAccessToken;
    data['refreshToken'] = spotifyRefreshToken;
    data['expiresIn'] = expiresIn.toString();

    return data;
  }
}