import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:tag_repository/src/models/models.dart';

import '../utils/constant.dart';

class ApiTagService {
  final String _url = URL_API+'tags';


  Future<Tag> getTagById(String tagId, String token) async {
    Map<String, String > headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': '*/*',
      'Access-Control-Allow-Origin': '*',
      'Authorization': 'Bearer $token'
    };
    final response = await http.get(Uri.parse(_url+"/"+tagId), headers: headers);
    if (response.statusCode == 200) {
      return tagModelFromJson(response.bodyBytes);
    } else {
      throw Exception("Failed to load tag");
    }
  }

  Future<List<Tag>> getTags(String userId, int page, String query, List<String> filters, String token) async {
    Map<String, String > headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': '*/*',
      'Access-Control-Allow-Origin': '*',
      'Authorization': 'Bearer $token'
    };
    try {
      final response = await http.get(
          Uri.parse(_url + "?userId=" + userId+"&page="+page.toString()+"&limit=50&query="+query.toString()+"&filters="+filters.join(",")), headers: headers);
      if (response.statusCode == 200) {
        List<Tag> tags = [];
        print(response.body);
        List<dynamic> tagsMap = jsonDecode(
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

  Future<List<String>> getTagsName(String userId, String token) async {
    Map<String, String > headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': '*/*',
      'Access-Control-Allow-Origin': '*',
      'Authorization': 'Bearer $token'

    };
    try {
      final response = await http.get(
          Uri.parse(_url + "/names?userId=" + userId), headers: headers);
      if (response.statusCode == 200) {
        print(response.body);
        List<String> tagsMap = List.from(jsonDecode(
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

  Future<void> updateTagsToTrack(Tag tag, String userId, String token) async {
    Map<String, String > headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': '*/*',
      'Access-Control-Allow-Origin': '*',
      'authorization': 'Bearer $token'

    };
    try {
      final response = await http.put(
          Uri.parse(_url + "/"+tag.id.toString()+"?userId=" + userId), body: jsonEncode(
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