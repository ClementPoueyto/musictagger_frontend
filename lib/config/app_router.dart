import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:music_tagger/home/home.dart';
import 'package:music_tagger/login/login.dart';
import 'package:music_tagger/screens/screens.dart';
import 'package:music_tagger/sign_up/view/sign_up_page.dart';

import '../app/bloc/app_bloc.dart';
import '../screens/profile/profile_screen.dart';


class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    print('The Route is: ${settings.name}');


      switch (settings.name) {
        case '/':
          return SplashPage.route();
        case HomePage.routeName:
          return HomePage.route();
        case ProfileScreen.routeName:
          return ProfileScreen.route();
        case LoginPage.routeName:
          return LoginPage.route();
        case SignUpPage.routeName:
          return SignUpPage.route();
        default:
          return _errorRoute();
      }

  }

  static Route _errorRoute() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => Scaffold(appBar: AppBar(title: Text('error'))),
      settings: RouteSettings(name: '/error'),
    );
  }


}
