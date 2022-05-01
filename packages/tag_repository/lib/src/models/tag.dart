import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:tag_repository/src/models/track.dart';


Tag tagModelFromJson(Uint8List bytes) => Tag.fromJson(json.decode(
    utf8.decode(bytes)));

String tagModelToJson(Tag data) => json.encode(data.toJson());

class Tag extends Equatable{

  const Tag(
      this.id,
     this.tags,
     this.track,
      this.userId,
      );

  final int id;
  final List<String> tags;
  final Track track;
  final String userId;

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
      json["id"],
      List<String>.from(json["tags"]),
      Track.fromJson(json["track"]),
      json["userId"],

  );

  Map<String, dynamic> toJson() => {
    "id" : id,
    "tags": tags,
    "track": track,
    "userId" : userId
  };

  static const empty = const Tag(0,[],Track.empty, "-");

  @override
  List<Object> get props => [tags,track];
}