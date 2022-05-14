import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../models/models.dart';
import '../utils/constant.dart';


class ApiUserService {
  final String _url = URL_API+'users';

  Future<User> fetchUser(String id, String token) async {

    Map<String, String > headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': '*/*',
      "authorization": 'Bearer $token'
    };
    try {
      Response response = await http.get(Uri.parse(_url+"/"+id.toString()),headers: headers);
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

  Future<void> connectSpotify(User user, String token) async {
      print(user.toJson());
      Map<String, String > headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '*/*',
        'Access-Control-Allow-Origin': '*',
        'authorization': 'Bearer $token'

      };
      Response response = await http.post(Uri.parse(_url+"/"+user.id.toString()+"/spotify/connect?userId="+user.id.toString()), headers: headers, body:json.encode(user.spotifyUser.toJson()));
      print(response.statusCode);
      if (response.statusCode != 200) {
        throw Exception('Failed to connect user to spotify');
      }
  }

  Future<void> importTracksFromSpotify(String userId, String token) async {
    Map<String, String > headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': '*/*',
      'Access-Control-Allow-Origin': '*',
      'authorization': 'Bearer $token'

    };
    Response response = await http.get(Uri.parse(_url+"/"+userId+"/spotify/import"), headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Failed to connect user to spotify');
    }
  }

  Future<void> generatePlaylistToSpotify(String userId, List<String> tags, String token) async {
    Map<String, String > headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': '*/*',
      'Access-Control-Allow-Origin': '*',
      'authorization': 'Bearer $token'

    };
    Response response = await http.put(Uri.parse(_url+"/"+userId+"/spotify/playlists"),body: jsonEncode(tags), headers: headers);
    print(response.body);
    print(response.statusCode);
    if (response.statusCode != 200) {
      throw Exception('Failed to generate playlist to spotify');
    }
  }
}