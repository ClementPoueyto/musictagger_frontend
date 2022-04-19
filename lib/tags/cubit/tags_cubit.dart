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

    var oldTags = <Tag>[];
    if (currentState is TagsLoaded) {
      oldTags = currentState.tags;
    }
    emit(TagsLoading(oldTags, isFirstFetch: page==0));
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

  void updateTags(List<Tag> tags){
    emit(TagsLoaded(tags: tags));
  }

  Future<void> refreshTags(String userId)async {
    this.page = 0;
    this.fetchTags(userId);
  }
}
