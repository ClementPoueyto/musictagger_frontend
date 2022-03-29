part of 'tags_bloc.dart';

abstract class TagsState extends Equatable {
  const TagsState();
}

class TagsLoadingState extends TagsState {
  @override
  List<Object> get props => [];
}

class TagsLoadedState extends TagsState {
  TagsLoadedState(this.tags);


  final List<Tag> tags;


  @override
  List<Object> get props => [tags];
}

class TagErrorState extends TagsState {
  final String error;

  TagErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
