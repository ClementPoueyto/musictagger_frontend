import 'package:auto_route/auto_route.dart';
import 'package:music_tagger/home/home.dart';
import 'package:music_tagger/login/login.dart';
import 'package:music_tagger/profile/view/profile_screen.dart';
import 'package:music_tagger/router/AuthGuard.dart';
import 'package:music_tagger/tags/tags.dart';
import 'package:music_tagger/widgets/widgets.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[

      AutoRoute<dynamic>(path: "/",page: AutoTabsScaffoldPage, guards: [AuthGuard],
          children: [
            AutoRoute<dynamic>(name: "HomeRouter", path : 'home',page: EmptyRouterPage,children: [
              AutoRoute<dynamic>(path: '', page: HomePage,guards: [AuthGuard], initial: true)
            ]),
            AutoRoute<dynamic>(name: "TagRouter", path : 'tags',page: EmptyRouterPage,children: [
              AutoRoute<dynamic>(path: '', page: TagsScreen,guards: [AuthGuard], initial: true)
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