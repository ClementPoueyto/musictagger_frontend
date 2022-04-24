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
              if(user.isNotEmpty){
                fetchTags(user.id, '')
              }
              else{
                emit(TagsInitial())

              }
        }
    );
  }

  final TagRepository tagsRepository;
  final AuthenticationRepository authenticationRepository;

  bool isFetching = false;

  Future<void> fetchTags(String userId, String? search) async{
    final currentState = state;
    if (currentState is TagsLoading) return;
    var oldTags = <Tag>[];
    var pageIndex = 0;

    if (currentState is TagsLoaded ) {
      //meme recherche
      search = search??currentState.search;
      if(search == currentState.search) {
        oldTags = currentState.tags;
        pageIndex = currentState.pageIndex+1;
      }
    }

    search = search??'';

    emit(TagsLoading(oldTags, search,pageIndex));

    try{
      final tags = await tagsRepository.getTags(userId: userId, page: pageIndex, query: search);
      oldTags.addAll(tags);
      emit(TagsLoaded(search: search,tags: oldTags, pageIndex: pageIndex));
    }
    catch(err){
      print(err);
      emit(TagsError(error: err.toString()));
    }
  }
  



  void updateTag(Tag tag){
    final currentState = state;

    var oldTags = <Tag>[];
    var oldSearch = '';
    var oldPageIndex = 0;
    if (currentState is TagsLoaded) {
      oldTags = currentState.tags;
      oldSearch = currentState.search;
      oldPageIndex = currentState.pageIndex;
      emit(TagsLoading(oldTags, oldSearch, oldPageIndex));
      if(tag.tags.isNotEmpty){
        final index = oldTags.indexWhere((item)=>tag.id==item.id);
        oldTags[index] = tag;
      }
      else{
        oldTags.removeWhere((item)=>tag.id==item.id);
      }
      emit(TagsLoaded(tags: oldTags, search: oldSearch, pageIndex: oldPageIndex));
    }

  }

  Future<void> reinitialisation() async {
    emit(TagsInitial());
  }

  Future<void> refreshTags(String userId)async {
    this.fetchTags(userId, '');
  }
}
