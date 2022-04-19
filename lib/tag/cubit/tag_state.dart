part of 'tag_cubit.dart';

abstract class TagState extends Equatable {
  const TagState();
  @override
  List<Object> get props => [];
}

class TagInitial extends TagState {}

class TagLoading extends TagState {

  TagLoading();

}

class TagLoaded extends TagState {
  final Tag tag;

  const TagLoaded({required this.tag});

  @override
  List<Object> get props => [tag];
}

class TagError extends TagState {
  final String error;

  const TagError({required this.error});

  @override
  List<Object> get props => [error];
}