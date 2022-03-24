part of 'tags_bloc.dart';

abstract class TagsState extends Equatable {
  const TagsState();
}

class TagsInitial extends TagsState {
  @override
  List<Object> get props => [];
}
