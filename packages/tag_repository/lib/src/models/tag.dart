import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:tag_repository/src/models/track.dart';


Tag tagModelFromJson(String str) => Tag.fromJson(json.decode(str));

String tagModelToJson(Tag data) => json.encode(data.toJson());

class Tag extends Equatable{

  const Tag(
      this.id,
     this.tags,
     this.track,
  );

  final int id;
  final List<String> tags;
  final Track track;

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
      json["id"],
      List<String>.from(json["tags"]),
      Track.fromJson(json["track"]),
  );

  Map<String, dynamic> toJson() => {
    "id" : id,
    "tags": tags,
    "track": track
  };

  static const empty = const Tag(0,[],Track.empty);

  @override
  List<Object> get props => [tags,track];
}