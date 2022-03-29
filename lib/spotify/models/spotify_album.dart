import 'dart:ui';

import 'package:music_tagger/spotify/models/spotify_artist.dart';
import 'package:music_tagger/spotify/models/spotify_image.dart';

import 'external_urls.dart';

class SpotifyAlbum
{
  String? album_type;
  List<SpotifyArtist>? artists;
  List<String>? available_markets;
  ExternalUrls? external_urls;
  String? href;
  String? id;
  List<SpotifyImage>? images;
  String? name;
  String? release_date;
  String? release_date_precision;
  int? total_tracks;
  String? type;
  String? uri;


  SpotifyAlbum(
      this.album_type,
      this.artists,
      this.available_markets,
      this.external_urls,
      this.href,
      this.id,
      this.images,
      this.name,
      this.release_date,
      this.release_date_precision,
      this.total_tracks,
      this.type,
      this.uri);


  SpotifyAlbum.fromJson(Map<String, dynamic> json){
    album_type = json['album_type'] as String;
    total_tracks = json['total_tracks'] as int;
    available_markets = List.castFrom<dynamic, String>(json['available_markets'] as List<dynamic>);
    external_urls = ExternalUrls.fromJson(json['external_urls'] as Map<String, dynamic>);
    href = json['href'] as String;
    id = json['id'] as String;
    images = List<dynamic>.from(json['images'] as List<Map<String , dynamic>>).map((dynamic e) =>SpotifyImage.fromJson(e as Map<String , dynamic>)).toList();
    name = json['name'] as String;
    release_date = json['release_date'] as String ;
    type = json['type'] as String;
    uri = json['uri'] as String;
    artists = List<dynamic>.from(json['artists'] as List<Map<String, dynamic>>).map((dynamic e)=>SpotifyArtist.fromJson(e as Map<String, dynamic>)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['album_type'] = album_type;
    _data['total_tracks'] = total_tracks;
    _data['available_markets'] = available_markets;
    _data['external_urls'] = external_urls?.toJson();
    _data['href'] = href;
    _data['id'] = id;
    _data['images'] = images?.map((e)=>e.toJson()).toList();
    _data['name'] = name;
    _data['release_date'] = release_date;
    _data['type'] = type;
    _data['uri'] = uri;
    _data['artists'] = artists?.map((e)=>e.toJson()).toList();
    return _data;
  }
}