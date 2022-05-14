import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tag_repository/tag_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:url_launcher/url_launcher.dart';

part 'playlists_generation_state.dart';

class PlaylistsGenerationCubit extends Cubit<PlaylistsGenerationState> {
  PlaylistsGenerationCubit(this.tagRepository, this.authenticationRepository) : super(const PlaylistsGenerationLoaded(selected: []));

  final TagRepository tagRepository;
  final AuthenticationRepository authenticationRepository;
  void updateSelectedTag(String tag) {
    final currentState = state;
    if(currentState is PlaylistsGenerationLoaded){
      if(currentState.selected.contains(tag)){
        final currentSelection = List<String>.of(currentState.selected);
        currentSelection.remove(tag);
        emit(PlaylistsGenerationLoaded(selected: currentSelection));
      }
      else{
        emit(PlaylistsGenerationLoaded(selected: [...currentState.selected, tag]));
      }
    }
  }

  Future<void> generatePlaylist( String userId, List<String> tags) async {
    final jwt = await authenticationRepository.firebaseAuth.currentUser?.getIdToken();
    if(jwt==null){ return Future.error('No jwt Token'); }

    final currentState = state;
    if(currentState is PlaylistsGenerationLoaded){
      emit(PlaylistsGenerationLoading(selected: tags));
      final uri = await tagRepository.generatePlaylistToSpotify(userId: userId, tags: tags, jwtToken: jwt);
      emit(PlaylistsGenerationLoaded(selected: tags));
      if(uri!=null){
        var _url =Uri.parse(uri);
        if (!await launchUrl(_url)) throw 'Could not launch $_url';
      }

    }

  }

}
