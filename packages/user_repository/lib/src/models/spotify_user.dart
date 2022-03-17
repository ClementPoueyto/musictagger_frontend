import 'package:equatable/equatable.dart';
import 'package:user_repository/src/models/models.dart';

class SpotifyUser extends User {
  SpotifyUser( this.spotifyAccessToken, this.spotifyRefreshToken) : super('16');

  String spotifyAccessToken;

  String spotifyRefreshToken;

  final int expiresIn = 3600;

  @override
  List<Object> get props => [spotifyRefreshToken, spotifyAccessToken, expiresIn];

  static final empty = SpotifyUser('-', '');

  Map<String, dynamic> toJson(){
    final Map<String, String> data = new Map<String, String>();
    data['id'] = id;
    data['accessToken'] = spotifyAccessToken;
    data['refreshToken'] = spotifyRefreshToken;
    data['expiresIn'] = expiresIn.toString();

    return data;
  }
}