import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:music_tagger/app/app.dart';


class SplashPage extends StatelessWidget {

  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  SplashPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SplashPage());
  }

  static const String routeName = '/';


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppState>(
        listener: (context, state) {
          if (state.status==AppStatus.unauthenticated) {
            print('submission failure');
            AutoRouter.of(context).pushNamed('/login');
          } else if (state.status==AppStatus.authenticated) {
            print('success');
            AutoRouter.of(context).pushNamed('/home');
          }
        },
        builder: (context, state) => Scaffold(
      body: Center(child: CircularProgressIndicator()),
    ));
  }
}