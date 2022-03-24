import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:tag_repository/src/models/models.dart';

class ApiUserService {
  final String _url = 'http://localhost:8080/tag/';

  Future<Tag> getTagById() async {
    final response = await http.get(Uri.parse(_url));
    if (response.statusCode == 200) {
      return tagModelFromJson(response.body);
    } else {
      throw Exception("Failed to load tag");
    }
  }

  Future<List<Tag>> getTags() async {
    final response = await http.get(Uri.parse(_url));
    if (response.statusCode == 200) {
      List<Tag> tags = [];
      List<Map<String, dynamic>> tagsMap = convert.jsonDecode(response.body) as List<Map<String, dynamic>>;
      tagsMap.forEach((element) {
        tags.add(Tag.fromJson(element));
      });
      return tags;
    } else {
      throw Exception("Failed to load tags");
    }
  }

}