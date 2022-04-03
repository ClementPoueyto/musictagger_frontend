part of 'tags_cubit.dart';

abstract class TagsState extends Equatable {
  const TagsState();
  @override
  List<Object> get props => [];
}

class TagsInitial extends TagsState {}

class TagsLoading extends TagsState {}

class Tagsloaded extends TagsState {
  final List<Tag> tags;

  const Tagsloaded({required this.tags});

  @override
  List<Object> get props => [tags];
}

class TagsError extends TagsState {
  final String error;

  const TagsError({required this.error});

  @override
  List<Object> get props => [error];
}