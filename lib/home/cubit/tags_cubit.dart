import 'dart:async';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:music_tagger/profile/cubit/profile_cubit.dart';
import 'package:tag_repository/tag_repository.dart';

part 'tags_state.dart';

class TagsCubit extends Cubit<TagsState> {
  TagsCubit( this.tagsRepository, this.authenticationRepository) : super(TagsInitial()){
    authenticationRepository.userAuth.listen(
            (user) => {
              if(user.isNotEmpty){
                fetchTags(user.id, '', [])
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

  Future<void> fetchTags(String userId, String? search, List<String>? filters) async{
    final currentState = state;
    if (currentState is TagsLoading) return;
    var oldTags = <Tag>[];
    var pageIndex = 0;
    if (currentState is TagsLoaded ) {
      //meme recherche
      search = search??currentState.search;
      filters = filters??currentState.filters;
      if(search == currentState.search && filters == currentState.filters) {
        oldTags = currentState.tags;
        pageIndex = currentState.pageIndex+1;
      }
    }

    search = search??'';
    filters = filters??[];

    emit(TagsLoading(oldTags, search,pageIndex,filters));

    try{
      final tags = await tagsRepository.getTags(userId: userId, page: pageIndex, query: search,filters: filters);
      oldTags.addAll(tags);
      emit(TagsLoaded(search: search,tags: oldTags, pageIndex: pageIndex, filters: filters));
    }
    catch(err){
      print(err);
      emit(TagsError(error: err.toString()));
    }
  }
  



  Future<void> updateTag(Tag tag)async {
    final currentState = state;

    var oldTags = <Tag>[];
    var oldFilters = <String> [];
    var oldSearch = '';
    var oldPageIndex = 0;
    if (currentState is TagsLoaded) {
      oldTags = currentState.tags;
      oldSearch = currentState.search;
      oldFilters = currentState.filters;
      oldPageIndex = currentState.pageIndex;
      emit(TagsLoading(oldTags, oldSearch, oldPageIndex, oldFilters));
      if(tag.tags.isNotEmpty){
        final index = oldTags.indexWhere((item)=>tag.id==item.id);
        oldTags[index] = tag;
      }
      else{
        oldTags.removeWhere((item)=>tag.id==item.id);
      }
      emit(TagsLoaded(tags: oldTags, search: oldSearch, pageIndex: oldPageIndex, filters: oldFilters));
    }

  }

  Future<void> reinitialisation() async {
    emit(TagsInitial());
  }

  Future<void> refreshTags(String userId)async {
    final currentState = state;
    if (currentState is TagsLoading) return;
    var oldTags = <Tag>[];
    var pageIndex = 0;
    var search ="";
    var filters = <String>[];
    if (currentState is TagsLoaded ) {
      //meme recherche
      search = currentState.search;
      filters = currentState.filters;
    }
    emit(TagsLoading(oldTags, search,pageIndex,filters));

    try{
      final tags = await tagsRepository.getTags(userId: userId, page: pageIndex, query: search,filters: filters);
      oldTags.addAll(tags);
      emit(TagsLoaded(search: search,tags: oldTags, pageIndex: pageIndex, filters: filters));
    }
    catch(err){
      print(err);
      emit(TagsError(error: err.toString()));
    }
  }

}
