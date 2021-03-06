import 'package:tag_repository/src/services/services.dart';
import 'package:uuid/uuid.dart';

import '../tag_repository.dart';


class TagRepository {

  final _providerUser = ApiUserService();
  final _providerTag = ApiTagService();



  Future<User> getUser({required String id, required String jwtToken}) async {

    User _user = await _providerUser.fetchUser(id, jwtToken);
    if(_user==null){
      _user = await Future.delayed(
        const Duration(milliseconds: 300),
            () => _user = User("",SpotifyUser.empty),
      );
    }
    print(_user);
    return _user;
  }

  Future<void> connectSpotify({required User user, required String jwtToken}) async {
    print(user);
    if (user == null || user.spotifyUser==null) return null;
    return _providerUser.connectSpotify(user, jwtToken);
  }

  Future<String?> generatePlaylistToSpotify({required String userId, required List<String> tags, required String jwtToken}) async {
    if (userId == null || tags.length==0) return null;
    return _providerUser.generatePlaylistToSpotify(userId, tags, jwtToken);
  }

  Future<void> importSpotifyTracks({required String userId, required String jwtToken}) async {
    print(userId);
    if (userId == null) return null;
    return _providerUser.importTracksFromSpotify(userId, jwtToken);
  }

  Future<Tag> getTagById({required String tagId,required String jwtToken}) async {
    try {
      return await _providerTag.getTagById(tagId, jwtToken);
    } on Exception catch (e) {
      throw FetchAndUpdateTagFailure.fromCode(e.toString());
    } catch (_) {
      throw const FetchAndUpdateTagFailure();
    }
  }

  Future<List<Tag>> getTags({required String userId, required int page, required String query, required List<String> filters, required String jwtToken}) async {
    try {
      return await _providerTag.getTags(userId, page, query, filters, jwtToken);
    } on Exception catch (e) {
      print(e.toString());
      throw FetchAndUpdateTagFailure.fromCode(e.toString());
    } catch (_) {
      throw const FetchAndUpdateTagFailure();
    }
  }

  Future<List<String>> getTagsNames({required String userId, required String jwtToken}) async {
    try {
      return await _providerTag.getTagsName(userId, jwtToken);
    } on Exception catch (e) {
      print(e.toString());
      throw FetchAndUpdateTagFailure.fromCode(e.toString());
    } catch (_) {
      throw const FetchAndUpdateTagFailure();
    }
  }

  Future<void> updateTagsToTrack({required Tag tag,required String jwtToken}) async {
    try {
      return await _providerTag.updateTagsToTrack(tag, tag.userId, jwtToken);
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