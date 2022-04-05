import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tag_repository/tag_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this.tagsRepository, this.authenticationRepository) : super(ProfileInitial()){
    authenticationRepository.userAuth.listen(
            (user) => {
          if(user!=null&&user.id!=null){
            fetchProfile(user.id)
          }
        }
    );
  }

  final TagRepository tagsRepository;
  final AuthenticationRepository authenticationRepository;

  Future<void> fetchProfile(String userId) async{
    emit(ProfileLoading());
    try{
      final User user = await tagsRepository.getUser(userId);
      emit(ProfileLoaded( user: user));
    }
    catch(err){
      print(err);
      emit(ProfileError(error: err.toString()));
    }
  }

  Future<void> updateProfile(User user) async {
    try{
      await tagsRepository.connectSpotify(user);
      emit(ProfileLoaded( user: user));
    }
    catch(err){
      print(err);
      emit(ProfileError(error: err.toString()));
    }
  }
}
