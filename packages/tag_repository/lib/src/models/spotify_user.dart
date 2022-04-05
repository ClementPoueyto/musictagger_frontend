import 'package:equatable/equatable.dart';

class SpotifyUser extends Equatable{
  const SpotifyUser( this.spotifyAccessToken, this.spotifyRefreshToken);

  final String spotifyAccessToken;

  final String spotifyRefreshToken;

  final int expiresIn = 3600;

  @override
  List<Object> get props => [spotifyRefreshToken, spotifyAccessToken, expiresIn];

  static const empty = SpotifyUser('_', '_');

  Map<String, dynamic> toJson(){
    final Map<String, String> data = new Map<String, String>();
    data['accessToken'] = spotifyAccessToken;
    data['refreshToken'] = spotifyRefreshToken;
    data['expiresIn'] = expiresIn.toString();

    return data;
  }

  static SpotifyUser fromJson(Map<String, dynamic> data) {
    return SpotifyUser(
        data['spotifyAccessToken'],
        data['spotifyRefreshToken'],
    );
  }
}