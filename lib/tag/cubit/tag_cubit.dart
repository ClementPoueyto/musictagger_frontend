import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tag_repository/tag_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
part 'tag_state.dart';

class TagCubit extends Cubit<TagState> {
  TagCubit( this.tagsRepository, this.authenticationRepository) : super(TagInitial()){
  }

  final TagRepository tagsRepository;
  final AuthenticationRepository authenticationRepository;

  bool isFetching = false;

  Future<void> fetchTag(String tagId) async{

    emit(TagLoading());
    try{
      final Tag tag= await tagsRepository.getTagById(tagId: tagId);
      emit(TagLoaded(tag: tag));
    }
    catch(err){
      print(err);
      emit(TagError(error: err.toString()));
    }
  }

  Future<void> updateTag(Tag tag) async {
    try{
      await tagsRepository.updateTagsToTrack(tag: tag);
      emit(TagLoaded(tag: tag));
    }
    catch(err){
      print(err);
      emit(TagError(error: err.toString()));
    }
  }
}
