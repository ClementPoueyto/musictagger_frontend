class SpotifyImage
{
  int? height;
  String? url;
  int? width;


  SpotifyImage(this.height, this.url, this.width);

  SpotifyImage.fromJson(Map<String, dynamic> json){
    url = json['url'] as String;
    height = json['height'] as int;
    width = json['width'] as int;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['url'] = url;
    _data['height'] = height;
    _data['width'] = width;
    return _data;
  }

}