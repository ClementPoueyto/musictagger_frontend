import 'package:music_tagger/spotify/models/spotify_album.dart';
import 'package:music_tagger/spotify/models/spotify_artist.dart';

import 'external_ids.dart';
import 'external_urls.dart';

class SpotifyTrack
{
  SpotifyAlbum? album;
  List<SpotifyArtist>? artists;
  List<String>? available_markets;
  int? disc_number;
  int? duration_ms;
  bool? explicit;
  ExternalIds? external_ids;
  ExternalUrls? external_urls;
  String? href;
  String? id;
  bool? is_local;
  String? name;
  int? popularity;
  String? preview_url;
  int? track_number;
  String? type;
  String? uri;


  SpotifyTrack(
      this.album,
      this.artists,
      this.available_markets,
      this.disc_number,
      this.duration_ms,
      this.explicit,
      this.external_ids,
      this.external_urls,
      this.href,
      this.id,
      this.is_local,
      this.name,
      this.popularity,
      this.preview_url,
      this.track_number,
      this.type,
      this.uri);


  SpotifyTrack.fromJson(Map<String, dynamic> json){
    album = SpotifyAlbum.fromJson(json['album'] as Map<String, dynamic>);
    artists = List<dynamic>.from(json['artists'] as List<Map<String, dynamic>>).map((dynamic e)=>SpotifyArtist.fromJson(e as Map<String, dynamic>)).toList();
    available_markets = List.castFrom<dynamic, String>(json['available_markets'] as List<Map<String, dynamic>>);
    explicit = json['explicit'] as bool;
    disc_number = json['disc_number'] as int;
    duration_ms = json['duration_ms'] as int;
    external_ids = ExternalIds.fromJson(json['external_ids'] as Map<String, dynamic>);
    external_urls = ExternalUrls.fromJson(json['external_urls'] as Map<String, dynamic>);
    href = json['href'] as String;
    id = json['id'] as String;
    name = json['name'] as String;
    popularity = json['popularity'] as int;
    preview_url = json['preview_url'] as String;
    track_number = json['track_number'] as int;
    type = json['type'] as String;
    uri = json['uri'] as String;
    is_local = json['is_local'] as bool;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['album'] = album?.toJson();
    _data['artists'] = artists?.map((e)=>e.toJson()).toList();
    _data['available_markets'] = available_markets;
    _data['disc_number'] = disc_number;
    _data['duration_ms'] = duration_ms;
    _data['explicit'] = explicit;
    _data['external_ids'] = external_ids?.toJson();
    _data['external_urls'] = external_urls?.toJson();
    _data['href'] = href;
    _data['id'] = id;
    _data['name'] = name;
    _data['popularity'] = popularity;
    _data['preview_url'] = preview_url;
    _data['track_number'] = track_number;
    _data['type'] = type;
    _data['uri'] = uri;
    _data['is_local'] = is_local;
    return _data;
  }

}