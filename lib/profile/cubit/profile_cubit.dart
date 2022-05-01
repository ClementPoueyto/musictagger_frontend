import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:music_tagger/home/cubit/tags_cubit.dart';
import 'package:tag_repository/tag_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this.tagsRepository, this.authenticationRepository, this.tagsCubit) : super(ProfileInitial()){
    authenticationRepository.userAuth.listen(
            (user) => {
          if(user.isNotEmpty){
            fetchProfile(user.id)
          }
          else{
            emit(ProfileInitial())
          }
        }
    );
  }

  final TagRepository tagsRepository;
  final AuthenticationRepository authenticationRepository;
  final TagsCubit tagsCubit;

  Future<void> fetchProfile(String userId) async{
    emit(ProfileLoading());
    try{
      final user = await tagsRepository.getUser(userId);
      emit(ProfileLoaded( user: user));
    }
    catch(err){
      print(err);
      emit(ProfileError(error: err.toString()));
    }
  }

  Future<void> connectSpotify(User user) async {
    print(user);
    try{
      await tagsRepository.connectSpotify(user);
      emit(ProfileLoaded( user: user));
      await tagsCubit.refreshTags(user.id);
    }
    catch(err){
      print(err);
      emit(ProfileError(error: err.toString()));
    }
  }

  Future<void> importTracksFromSpotify(String userId) async {
    try{
      await tagsRepository.importSpotifyTracks(userId);
      await tagsCubit.refreshTags(userId);

    }
    catch(err){
      print(err);
      emit(ProfileError(error: err.toString()));
    }
  }
}
