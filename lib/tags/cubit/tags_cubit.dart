import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tag_repository/tag_repository.dart';

part 'tags_state.dart';

class TagsCubit extends Cubit<TagsState> {
  TagsCubit(this.tagsRepository) : super(TagsInitial());

  final TagRepository tagsRepository;


  Future<void> FetchTags() async{
    emit(TagsLoading());
    try{
      final List<Tag> tags = await tagsRepository.getTags(userId: '');
      emit(Tagsloaded(tags: tags));
    }
    catch(err){
      print(err);
    }
  }
}
