import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tag_repository/tag_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
part 'tags_state.dart';

class TagsCubit extends Cubit<TagsState> {
  TagsCubit( this.tagsRepository, this.authenticationRepository) : super(TagsInitial()){
    authenticationRepository.userAuth.listen(
            (user) => {
              if(user!=null&&user.id!=null){
                fetchTags(user.id)
              }
        }
    );
  }

  final TagRepository tagsRepository;
  final AuthenticationRepository authenticationRepository;

  Future<void> fetchTags(String userId) async{
    emit(TagsLoading());
    try{
      final List<Tag> tags = await tagsRepository.getTags(userId: userId);
      emit(Tagsloaded(tags: tags));
    }
    catch(err){
      print(err);
      emit(TagsError(error: err.toString()));
    }
  }

  void updateTags(List<Tag> tags){
    emit(Tagsloaded(tags: tags));
  }
}
