import 'package:auto_route/auto_route.dart';
import 'package:music_tagger/home/home.dart';
import 'package:music_tagger/home/widgets/custom_bottom_app_bar.dart';
import 'package:music_tagger/login/login.dart';
import 'package:music_tagger/router/AuthGuard.dart';
import 'package:music_tagger/screens/screens.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[

      AutoRoute<dynamic>(path: "/",page: AutoTabsScaffoldPage, guards: [AuthGuard],
          children: [
            AutoRoute<dynamic>(name: "HomeRouter", path : 'home',page: EmptyRouterPage,children: [
              AutoRoute<dynamic>(path: '', page: HomePage,guards: [AuthGuard], initial: true)
            ]),
            AutoRoute<dynamic>(name: "HomeRouter", path : 'home',page: EmptyRouterPage,children: [
              AutoRoute<dynamic>(path: '', page: HomePage,guards: [AuthGuard], initial: true)
            ]),
            AutoRoute<dynamic>(name: "ProfileRouter", path : 'profile',page: EmptyRouterPage, children: [
              AutoRoute<dynamic>(path: '', page: ProfileScreen, guards: [AuthGuard],)
            ])
          ]),
      AutoRoute<dynamic>(name: "LoginRouter",
          path: "/login",
          page: LoginPage),
  ],
)
class $AppRouter {}  