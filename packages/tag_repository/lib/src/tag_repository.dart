import 'package:tag_repository/src/services/services.dart';
import 'package:uuid/uuid.dart';

import '../tag_repository.dart';


class TagRepository {

  final _providerUser = ApiUserService();
  final _providerTag = ApiTagService();

  Future<User> getUser(String id) async {

    User _user = await _providerUser.fetchUser(id);
    if(_user==null){
      _user = await Future.delayed(
        const Duration(milliseconds: 300),
            () => _user = User(Uuid().v4(),SpotifyUser.empty),
      );
    }
    print(_user);
    return _user;
  }

  Future<void> connectSpotify(User _user) async {
    print(_user);
    if (_user == null || _user.spotifyUser==null) return null;
    return _providerUser.connectSpotify(_user);
  }

  Future<void> importSpotifyTracks(String _userId) async {
    print(_userId);
    if (_userId == null) return null;
    return _providerUser.importTracksFromSpotify(_userId);
  }

  Future<Tag> getTagById({required String tagId}) async {
    try {
      return await _providerTag.getTagById(tagId);
    } on Exception catch (e) {
      throw FetchAndUpdateTagFailure.fromCode(e.toString());
    } catch (_) {
      throw const FetchAndUpdateTagFailure();
    }
  }

  Future<List<Tag>> getTags({required String userId, required int page}) async {
    try {
      return await _providerTag.getTags(userId, page);
    } on Exception catch (e) {
      print(e.toString());
      throw FetchAndUpdateTagFailure.fromCode(e.toString());
    } catch (_) {
      throw const FetchAndUpdateTagFailure();
    }
  }

  Future<List<String>> getTagsNames({required String userId}) async {
    try {
      return await _providerTag.getTagsName(userId);
    } on Exception catch (e) {
      print(e.toString());
      throw FetchAndUpdateTagFailure.fromCode(e.toString());
    } catch (_) {
      throw const FetchAndUpdateTagFailure();
    }
  }

  Future<void> updateTagsToTrack({required Tag tag}) async {
    try {
      return await _providerTag.updateTagsToTrack(tag, tag.userId);
    } on Exception catch (e) {
      print(e.toString());
      throw FetchAndUpdateTagFailure.fromCode(e.toString());
    } catch (_) {
      throw const FetchAndUpdateTagFailure();
    }
  }
}

class FetchAndUpdateTagFailure implements Exception {
  /// {@macro log_in_with_email_and_password_failure}
  const FetchAndUpdateTagFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create a tag message
  factory FetchAndUpdateTagFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const FetchAndUpdateTagFailure(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const FetchAndUpdateTagFailure(
          'This user has been disabled. Please contact support for help.',
        );
      default:
        return const FetchAndUpdateTagFailure();
    }
  }

  /// The associated error message.
  final String message;
}