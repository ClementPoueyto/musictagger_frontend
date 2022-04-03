import 'dart:async';
import 'package:tag_repository/tag_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:very_good_analysis/very_good_analysis.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required AuthenticationRepository authenticationRepository, required TagRepository tagRepository})
      : _authenticationRepository = authenticationRepository, _tagRepository = tagRepository,
        super(
        authenticationRepository.currentUser.isNotEmpty
            ? AuthState.authenticated(authenticationRepository.currentUser)
            : const AuthState.unauthenticated(),
      ) {
    on<AuthUserChanged>(_onUserChanged);
    on<AuthLogoutRequested>(_onLogoutRequested);
    _userSubscription = _authenticationRepository.userAuth.listen(
          (user) => {
            add(AuthUserChanged(user)),
          _tagRepository.getUser(user.id)
          }
    );
  }

  final AuthenticationRepository _authenticationRepository;
  final TagRepository _tagRepository;
  late final StreamSubscription<UserAuth> _userSubscription;


  void _onUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    emit(
      event.user.isNotEmpty
          ? AuthState.authenticated(event.user)
          : const AuthState.unauthenticated(),
    );
  }

  void _onLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) {
    unawaited(_authenticationRepository.logOut());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}