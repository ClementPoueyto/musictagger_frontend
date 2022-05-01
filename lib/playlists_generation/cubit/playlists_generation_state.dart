part of 'playlists_generation_cubit.dart';

abstract class PlaylistsGenerationState extends Equatable {
  const PlaylistsGenerationState();
  @override
  List<Object> get props => [];
}

class PlaylistsGenerationLoading extends PlaylistsGenerationState {
  final List<String> selected;

  const PlaylistsGenerationLoading({required this.selected} );

  @override
  List<Object> get props => [selected];

}

class PlaylistsGenerationLoaded extends PlaylistsGenerationState {
  final List<String> selected;

  const PlaylistsGenerationLoaded({required this.selected} );

  @override
  List<Object> get props => [selected];

}


class PlaylistsGenerationError extends PlaylistsGenerationState {
  final String error;

  const PlaylistsGenerationError({required this.error});

  @override
  List<Object> get props => [error];
}
