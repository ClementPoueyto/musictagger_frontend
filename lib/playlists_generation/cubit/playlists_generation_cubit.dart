import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tag_repository/tag_repository.dart';
part 'playlists_generation_state.dart';

class PlaylistsGenerationCubit extends Cubit<PlaylistsGenerationState> {
  PlaylistsGenerationCubit(this.tagRepository) : super(const PlaylistsGenerationLoaded(selected: []));

  final TagRepository tagRepository;

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
    final currentState = state;
    if(currentState is PlaylistsGenerationLoaded){
      emit(PlaylistsGenerationLoading(selected: tags));
      await tagRepository.generatePlaylistToSpotify(userId, tags);
      emit(PlaylistsGenerationLoaded(selected: tags));
    }

  }

}
