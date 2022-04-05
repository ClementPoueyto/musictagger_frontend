import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../models/models.dart';


class ApiUserService {
  final String _url = 'http://localhost:8080/user/';

  Future<User> fetchUser(String id) async {
    Map<String, String > headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': '*/*',
    };
    try {
      Response response = await http.get(Uri.parse(_url+"?id="+id.toString()),headers: headers);
      if (response.statusCode != 200) {
        throw Exception(response.body);
      }
      else {
        return User.fromJson(convert.jsonDecode(response.body));
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return Future.error("Data not found / Connection issue");
    }
  }

  Future<void> connectSpotify(User user) async {
      print(user.toJson());
      Map<String, String > headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '*/*',
      };
      Response response = await http.post(Uri.parse(_url+"connect/spotify?userId="+user.id.toString()), headers: headers, body:json.encode(user.spotifyUser!.toJson()));
      print(response.statusCode);
      if (response.statusCode != 201) {
        throw Exception('Failed to connect user to spotify');
      }



  }
}