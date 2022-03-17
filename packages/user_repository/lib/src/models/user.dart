import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User(this.id);

  final String id;

  @override
  List<Object> get props => [id];

  static const empty = User('-');

  static User fromJson(Map<String, dynamic> data) {
    return User(data['id']);
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    return data;
  }

}