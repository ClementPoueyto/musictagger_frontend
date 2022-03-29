import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../models/models.dart';


class ApiUserService {
  final String _url = 'http://localhost:8080/user/';

  Future<User> fetchUser() async {
    try {
      Response response = await http.get(Uri.parse(_url));
      return User.fromJson(convert.jsonDecode(response.body));
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return Future.error("Data not found / Connection issue");
    }
  }

  Future<void> connectSpotify(User user) async {
      print(user.toJson());
      Map<String, String > queryParameters = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '*/*',
      };
      Response response = await http.post(Uri.parse(_url+"connect/spotify?userId="+user.id.toString()), headers: queryParameters, body:json.encode(user.spotifyUser!.toJson()));
      if (response.statusCode != 201) {
        throw Exception('Failed to connect user to spotify');
      }



  }
}