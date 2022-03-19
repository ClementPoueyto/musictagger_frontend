import 'package:authentication_repository/authentication_repository.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_tagger/app/app.dart';
import 'package:music_tagger/screens/screens.dart';
import 'package:music_tagger/theme.dart';

import '../../config/app_router.dart';
import '../../home/view/home_page.dart';
import '../../login/view/login_page.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(key: key);

  final AuthenticationRepository _authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: BlocProvider(
        create: (_) => AppBloc(
          authenticationRepository: _authenticationRepository,
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
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: ProfileScreen.routeName,
    );
  }

  List<Page> onGenerateAppViewPages(AppStatus state, List<Page<dynamic>> pages) {
    switch (state) {
      case AppStatus.authenticated:
        return [HomePage.page()];
      case AppStatus.unauthenticated:
        return [LoginPage.page()];
    }
  }
}