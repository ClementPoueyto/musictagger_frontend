import 'dart:convert';

import 'package:equatable/equatable.dart';


Track tagModelFromJson(String str) => Track.fromJson(json.decode(str));

String tagModelToJson(Track data) => json.encode(data.toJson());

class Track extends Equatable{

  const Track(
     this.id,
     this.spotifyId,
     this.artistName,
     this.artists,
     this.albumName,
     this.name,
     this.image,
     this.duration
  );


  final int id;
  final String? spotifyId;
  final List<String> artists;
  final String artistName;
  final String albumName;
  final String name;
  final String? image;
  final int duration;

  factory Track.fromJson(Map<String, dynamic> json) => Track(
     json["id"],
     json["spotifyId"],
     json["artistName"],
    List<String>.from(json["artists"]),
    json["albumName"],
    json["name"],
    json["image"],
     json["duration"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "spotifyId": spotifyId,
    "artistName":artistName,
    "artists": artists,
    "albumName" : albumName,
    "name": name,
    "image": image,
    "duration": duration,
  };

  static const empty = const Track(0,  '','',[],'','','',0);

  @override
  List<Object?> get props => [artistName, name];
}