import 'package:authentication_repository/authentication_repository.dart';
import 'package:music_tagger/home/cubit/tags_cubit.dart';
import 'package:music_tagger/profile/cubit/profile_cubit.dart';
import 'package:music_tagger/tag/cubit/tag_names_cubit.dart';
import 'package:tag_repository/tag_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_tagger/app/app.dart';
import 'package:music_tagger/router/AuthGuard.dart';
import 'package:music_tagger/router/routes.gr.dart';

import '../../tag/cubit/tag_cubit.dart';

class App extends StatelessWidget {
  App(
      {Key? key,
      required AuthenticationRepository authenticationRepository,
      required TagRepository tagRepository})
      : _authenticationRepository = authenticationRepository,
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
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (_) => AuthBloc(
              authenticationRepository: _authenticationRepository,
            ),
          ),
          BlocProvider<TagsCubit>(
            create: (_) => TagsCubit(_tagRepository, _authenticationRepository),
          ),
          BlocProvider<ProfileCubit>(
            create: (_) =>
                ProfileCubit(_tagRepository, _authenticationRepository),
          ),
          BlocProvider(
            create: (_) =>
                TagNamesCubit(_tagRepository, _authenticationRepository),
          )
        ],
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
