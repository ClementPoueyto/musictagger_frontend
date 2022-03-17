import 'package:authentication_repository/authentication_repository.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_tagger/app/app.dart';
import 'package:music_tagger/theme.dart';
import 'package:user_repository/src/user_repository.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required AuthenticationRepository authenticationRepository, required UserRepository userRepository,
  })  : _authenticationRepository = authenticationRepository, _userRepository = userRepository,
        super(key: key);

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: [_authenticationRepository,_userRepository],
      child: BlocProvider(
        create: (_) => AppBloc(
          authenticationRepository: _authenticationRepository,
          userRepository: _userRepository,
        ),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: FlowBuilder<AppStatus>(
        state: context.select((AppBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages,
      ),
    );
  }
}