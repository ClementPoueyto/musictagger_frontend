import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert' as convert;

import 'package:tag_repository/src/models/models.dart';

class ApiTagService {
  //mobile :
  //final String _url = 'http://10.0.2.2:8080/tags';
  final String _url = 'http://localhost:8080/tags';

  Future<Tag> getTagById(String tagId) async {
    final response = await http.get(Uri.parse(_url+"/"+tagId));
    if (response.statusCode == 200) {
      return tagModelFromJson(response.bodyBytes);
    } else {
      throw Exception("Failed to load tag");
    }
  }

  Future<List<Tag>> getTags(String userId, int page, String query, List<String> filters) async {
    Map<String, String > headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': '*/*',
    'Access-Control-Allow-Origin': '*',
      'Access-Control-Request-Method':'GET'
    };
    try {
      Response response = await http.get(
          Uri.parse(_url + "?userId=" + userId+"&page="+page.toString()+"&limit=50&query="+query.toString()+"&filters="+filters.join(",")), headers: headers);
      if (response.statusCode == 200) {
        List<Tag> tags = [];
        print(response.body);
        List<dynamic> tagsMap = convert.jsonDecode(
                utf8.decode(response.bodyBytes)) as List<dynamic>;
        tagsMap.forEach((element ) {
          var tag = Tag.fromJson(element);
          tags.add(tag);
        });
        return tags;
      } else {
        throw Exception(response.body);
      }
    }
    catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return Future.error("Data not found / Connection issue");
    }
  }

  Future<List<String>> getTagsName(String userId) async {
    Map<String, String > headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': '*/*',
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Request-Method':'GET'
    };
    try {
      Response response = await http.get(
          Uri.parse(_url + "/names?userId=" + userId), headers: headers);
      if (response.statusCode == 200) {
        print(response.body);
        List<String> tagsMap = List.from(convert.jsonDecode(
            utf8.decode(response.bodyBytes)));
        return tagsMap;
      } else {
        throw Exception(response.body);
      }
    }
    catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return Future.error("Data not found / Connection issue");
    }
  }

  Future<void> updateTagsToTrack(Tag tag, String userId) async {
    Map<String, String > headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': '*/*',
      'Access-Control-Allow-Origin': '*',
    };
    try {
      Response response = await http.post(
          Uri.parse(_url + "/"+tag.id.toString()+"?userId=" + userId), body: convert.jsonEncode(
          tag.tags), headers: headers);
      if (response.statusCode == 200) {
        print(response.body);
      } else {
        throw Exception(response.body);
      }
    }
    catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return Future.error("Data not found / Connection issue");
    }
  }
}