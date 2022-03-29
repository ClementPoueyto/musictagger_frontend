import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tag_repository/tag_repository.dart';

part 'tags_event.dart';
part 'tags_state.dart';

class TagsBloc extends Bloc<TagsEvent, TagsState> {

  final TagRepository _tagRepository;

  TagsBloc(this._tagRepository) : super(TagsLoadingState()) {
    on<LoadTagEvent>((event, emit) async {
      emit(TagsLoadingState());
      try {
        final user = await _tagRepository.getUser();
        if(user==null) throw Exception("no user");
        final tags = await _tagRepository.getTags(userId: user.id);
        emit(TagsLoadedState(tags));
      } catch (e) {
        emit(TagErrorState(e.toString()));
      }
    });
  }
}
