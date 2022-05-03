import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tag_repository/tag_repository.dart';

part 'tag_names_state.dart';

class TagNamesCubit extends Cubit<TagNamesState> {
  TagNamesCubit(this.tagsRepository, this.authenticationRepository) : super(TagNamesInitial());

  final TagRepository tagsRepository;
  final AuthenticationRepository authenticationRepository;

  bool isFetching = false;

  Future<void> fetchTagNames(String userId) async{
    final jwt = await authenticationRepository.firebaseAuth.currentUser?.getIdToken();
    if(jwt==null){ return Future.error('No jwt Token'); }
    emit(TagNamesLoading());
    try{
      final names= await tagsRepository.getTagsNames(userId: userId, jwtToken: jwt);
      emit(TagNamesLoaded(names: names));
    }
    catch(err){
      print(err);
      emit(TagNamesError(error: err.toString()));
    }
  }

  void updateTags(List<String> names){
    emit(TagNamesLoaded(names: names));
  }
}
