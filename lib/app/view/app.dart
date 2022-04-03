import 'package:authentication_repository/authentication_repository.dart';
import 'package:tag_repository/tag_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_tagger/app/app.dart';
import 'package:music_tagger/router/AuthGuard.dart';
import 'package:music_tagger/router/routes.gr.dart';


class App extends StatelessWidget {
  App({
    Key? key,
    required AuthenticationRepository authenticationRepository,
    required TagRepository tagRepository
  })  : _authenticationRepository = authenticationRepository,
      _tagRepository = tagRepository,
        super(key: key);

  final AuthenticationRepository _authenticationRepository;
  final TagRepository _tagRepository;
  final _appRouter = AppRouter(authGuard: AuthGuard());

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => _authenticationRepository),
        RepositoryProvider(create: (_) => _tagRepository),
      ],
      child: BlocProvider(
        create: (_) => AuthBloc(
          authenticationRepository: _authenticationRepository,
          tagRepository: _tagRepository,

        ),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) => MaterialApp.router(
            theme: ThemeData.from(
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.blue,
              ).copyWith(secondary: Colors.yellow),
            ),
            routerDelegate: _appRouter.delegate(),
            routeInformationParser: _appRouter.defaultRouteParser(),
          ),
        ),
      ),
    );
  }
}
