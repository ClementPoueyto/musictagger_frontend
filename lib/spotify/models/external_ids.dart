class ExternalIds {
  String? isrc;


  ExternalIds(this.isrc);

  ExternalIds.fromJson(Map<String, dynamic> json){
    isrc = json['isrc'] as String;

  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['isrc'] = isrc;
    return _data;
  }

}