import 'external_urls.dart';

class SpotifyArtist
{
  ExternalUrls? external_urls;
  String? href;
  String? id;
  String? name;
  String? type;
  String? uri;



  SpotifyArtist(
      this.external_urls, this.href, this.id, this.name, this.type, this.uri);

  SpotifyArtist.fromJson(Map<String, dynamic> json){
    external_urls = ExternalUrls.fromJson(json['external_urls'] as Map<String, dynamic>);
    href = json['href'] as String;
    id = json['id'] as String;
    name = json['name'] as String;
    type = json['type'] as String;
    uri = json['uri'] as String;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['external_urls'] = external_urls?.toJson();
    _data['href'] = href;
    _data['id'] = id;
    _data['name'] = name;
    _data['type'] = type;
    _data['uri'] = uri;
    return _data;
  }


}