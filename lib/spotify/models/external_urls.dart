class ExternalUrls {
  String? spotify;

  ExternalUrls({required this.spotify});

  ExternalUrls.fromJson(Map<String, dynamic> json){
    spotify = json['spotify'] as String;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['spotify'] = spotify;
    return _data;
  }

}