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

  int page = 0;
  bool isFetching = false;

  Future<void> fetchTags(String userId) async{
    if (state is TagsLoading) return;

    final currentState = state;
    final isFirstFetch = page==0;
    var oldTags = <Tag>[];
    if (currentState is TagsLoaded && !isFirstFetch) {
      oldTags = currentState.tags;
    }
    emit(TagsLoading(oldTags, isFirstFetch: isFirstFetch));
    try{
      final List<Tag> tags = await tagsRepository.getTags(userId: userId, page: page);
      oldTags.addAll(tags);
      page++;
      emit(TagsLoaded(tags: oldTags));
    }
    catch(err){
      print(err);
      emit(TagsError(error: err.toString()));
    }
  }

  Future<void> updateTags(List<Tag> tags)async {
    emit(TagsLoaded(tags: tags));
  }



  void updateTag(Tag tag){
    final currentState = state;

    var oldTags = <Tag>[];
    if (currentState is TagsLoaded) {
      oldTags = currentState.tags;
      emit(TagsLoading(oldTags));
      if(tag.tags.isNotEmpty){
        final index = oldTags.indexWhere((item)=>tag.id==item.id);
        oldTags[index] = tag;
      }
      else{
        oldTags.removeWhere((item)=>tag.id==item.id);
      }

      emit(TagsLoaded(tags: oldTags));
    }

  }

  Future<void> reinitialisation() async {
    this.page = 0;
    emit(TagsInitial());
  }

  Future<void> refreshTags(String userId)async {
    this.page = 0;
    this.fetchTags(userId);
  }
}
