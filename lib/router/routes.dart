import 'package:auto_route/auto_route.dart';
import 'package:music_tagger/home/home.dart';
import 'package:music_tagger/login/login.dart';
import 'package:music_tagger/playlists_generation/playlists_generation.dart';
import 'package:music_tagger/profile/view/profile_screen.dart';
import 'package:music_tagger/router/AuthGuard.dart';
import 'package:music_tagger/sign_up/sign_up.dart';
import 'package:music_tagger/widgets/widgets.dart';
import 'package:music_tagger/tag/tag.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[

      AutoRoute<dynamic>(path: '/',page: AutoTabsScaffoldPage, guards: [AuthGuard],
          children: [
            AutoRoute<dynamic>(name: 'HomeRouter', path : 'tags',page: EmptyRouterPage,children: [
              AutoRoute<dynamic>(path: '', page: HomePage,guards: [AuthGuard], initial: true,),
              AutoRoute<dynamic>(path: ':id', page: TagScreen,guards: [AuthGuard],)
            ]),
            AutoRoute<dynamic>(name: 'TagRouter', path : 'generate',page: EmptyRouterPage,children: [
              AutoRoute<dynamic>(path: '', page: PlaylistGenerationScreen,guards: [AuthGuard], initial: true)
            ]),
            AutoRoute<dynamic>(name: 'ProfileRouter', path : 'profile',page: EmptyRouterPage, children: [
              AutoRoute<dynamic>(path: '', page: ProfileScreen, guards: [AuthGuard],)
            ])
          ]),
      AutoRoute<dynamic>(name: 'LoginRouter',
          path: '/login',
          page: LoginPage),
    AutoRoute<dynamic>(name: 'SignupRouter',
        path: '/signup',
        page: SignUpPage),
  ],
)
class $AppRouter {}  