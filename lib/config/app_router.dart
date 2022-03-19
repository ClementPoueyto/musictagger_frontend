import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:music_tagger/home/home.dart';
import 'package:music_tagger/login/view/login_page.dart';

import '../app/bloc/app_bloc.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/user/user_screen.dart';


class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    print('The Route is: ${settings.name}');


      switch (settings.name) {
        case '/':
          return HomePage.route();
        case HomePage.routeName:
          return HomePage.route();
        case UsersScreen.routeName:
          return UsersScreen.route(user: settings.arguments as User);
        case ProfileScreen.routeName:
          return ProfileScreen.route();

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
