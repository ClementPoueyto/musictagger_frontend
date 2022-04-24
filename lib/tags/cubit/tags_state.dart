part of 'tags_cubit.dart';

abstract class TagsState extends Equatable {
  const TagsState();
  @override
  List<Object> get props => [];
}

class TagsInitial extends TagsState {}

class TagsLoading extends TagsState {
  final List<Tag> oldTags;
  final String search;
  final int pageIndex;

  TagsLoading(this.oldTags, this.search, this.pageIndex);

  @override
  List<Object> get props => [oldTags, search, pageIndex];

}

class TagsLoaded extends TagsState {
  final List<Tag> tags;
  final String search;
  final int pageIndex;

  const TagsLoaded({required this.tags, required this.search, required this.pageIndex});

  @override
  List<Object> get props => [tags, search, pageIndex];
}

class TagsError extends TagsState {
  final String error;

  const TagsError({required this.error});

  @override
  List<Object> get props => [error];
}