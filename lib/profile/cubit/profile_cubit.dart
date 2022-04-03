import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tag_repository/tag_repository.dart';
part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this.tagsRepository) : super(ProfileInitial());

  final TagRepository tagsRepository;


  Future<void> FetchProfile() async{
    emit(ProfileLoading());
    try{
      final User user = await tagsRepository.getUser('');
      emit(ProfileLoaded( user: user));
    }
    catch(err){
      print(err);
    }
  }
}
