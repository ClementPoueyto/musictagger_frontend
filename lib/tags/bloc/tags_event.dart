part of 'tags_bloc.dart';

abstract class TagsEvent extends Equatable {
  const TagsEvent();
}

class LoadTagEvent extends TagsEvent {
  @override
  List<Object> get props => [];
}
