part of 'tags_cubit.dart';

abstract class TagsState extends Equatable {
  const TagsState();
  @override
  List<Object> get props => [];
}

class TagsInitial extends TagsState {
  final String search;
  const TagsInitial(this.search);
}

class TagsLoading extends TagsState {
  final List<Tag> oldTags;
  final String search;
  final int pageIndex;
  final List<String> filters;

  const TagsLoading(this.oldTags, this.search, this.pageIndex, this.filters);

  @override
  List<Object> get props => [oldTags, search, pageIndex];

}

class TagsLoaded extends TagsState {
  final List<Tag> tags;
  final String search;
  final int pageIndex;
  final List<String> filters;

  const TagsLoaded({required this.tags, required this.search, required this.pageIndex, required this.filters});

  @override
  List<Object> get props => [tags, search, pageIndex];
}

class TagsError extends TagsState {
  final String error;

  const TagsError({required this.error});

  @override
  List<Object> get props => [error];
}