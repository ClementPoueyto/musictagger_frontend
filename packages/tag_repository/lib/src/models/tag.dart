import 'dart:convert';

import 'package:equatable/equatable.dart';


Tag tagModelFromJson(String str) => Tag.fromJson(json.decode(str));

String tagModelToJson(Tag data) => json.encode(data.toJson());

class Tag extends Equatable{

  Tag({
    required this.id,
    required this.userId,
    required this.name,
  });


  final int id;
  final String userId;
  final String name;

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
    id: json["id"],
    userId: json["userId"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "delivery": userId,
    "name": name,
  };

  @override
  List<Object?> get props => [id, userId, name];
}