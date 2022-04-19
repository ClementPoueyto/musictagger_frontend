import 'package:equatable/equatable.dart';

import '../../tag_repository.dart';

class User extends Equatable {
  const User(this.id, this.spotifyUser);

  final String id;

  final SpotifyUser spotifyUser;

  @override
  List<Object> get props => [id, spotifyUser];

  static const empty = const User('-',  SpotifyUser.empty);

  static User fromJson(Map<String, dynamic> data) {
    return User(
      data['id'],
        data['spotifyUser']!=null?SpotifyUser.fromJson(data['spotifyUser']):SpotifyUser.empty
    );
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    return data;
  }

}