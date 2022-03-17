import 'dart:async';
import 'package:user_repository/src/services/services.dart';
import 'package:uuid/uuid.dart';
import 'models/models.dart';

class UserRepository {
  User? _user;
  final _provider = ApiUserService();

  Future<User?> getUser() async {
    if (_user != null) return _user;
    User user = await _provider.fetchUser();
    if(user==null){
      user = await Future.delayed(
        const Duration(milliseconds: 300),
            () => _user = User(const Uuid().v4()),
      );
    }
    this._user = user;
    return user;
  }

  Future<void> updateSpotifyUser(SpotifyUser user) async {
    if (user == null) return null;
    return _provider.updateSpotifyUser(user);
  }
}