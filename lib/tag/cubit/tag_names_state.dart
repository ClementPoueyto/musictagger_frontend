part of 'tag_names_cubit.dart';

class TagNamesState extends Equatable {
  const TagNamesState();
  List<Object> get props => [];
}

class TagNamesInitial extends TagNamesState {}

class TagNamesLoading extends TagNamesState {}

class TagNamesLoaded extends TagNamesState {
  final List<String> names;

  const TagNamesLoaded({required this.names});

  @override
  List<Object> get props => [names];
}

class TagNamesError extends TagNamesState {
  final String error;

  const TagNamesError({required this.error});

  @override
  List<Object> get props => [error];
}
