// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i4;
import 'package:flutter/material.dart' as _i9;

import '../home/home.dart' as _i5;
import '../login/login.dart' as _i2;
import '../playlists_generation/playlists_generation.dart' as _i7;
import '../profile/view/profile_screen.dart' as _i8;
import '../sign_up/sign_up.dart' as _i3;
import '../tag/tag.dart' as _i6;
import '../widgets/widgets.dart' as _i1;
import 'AuthGuard.dart' as _i10;

class AppRouter extends _i4.RootStackRouter {
  AppRouter(
      {_i9.GlobalKey<_i9.NavigatorState>? navigatorKey,
      required this.authGuard})
      : super(navigatorKey);

  final _i10.AuthGuard authGuard;

  @override
  final Map<String, _i4.PageFactory> pagesMap = {
    AutoTabsScaffoldRoute.name: (routeData) {
      return _i4.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.AutoTabsScaffoldPage());
    },
    LoginRouter.name: (routeData) {
      return _i4.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.LoginPage());
    },
    SignupRouter.name: (routeData) {
      return _i4.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i3.SignUpPage());
    },
    HomeRouter.name: (routeData) {
      return _i4.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i4.EmptyRouterPage());
    },
    TagRouter.name: (routeData) {
      return _i4.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i4.EmptyRouterPage());
    },
    ProfileRouter.name: (routeData) {
      return _i4.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i4.EmptyRouterPage());
    },
    HomeRoute.name: (routeData) {
      final args =
          routeData.argsAs<HomeRouteArgs>(orElse: () => const HomeRouteArgs());
      return _i4.MaterialPageX<dynamic>(
          routeData: routeData, child: _i5.HomePage(key: args.key));
    },
    TagScreen.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<TagScreenArgs>(
          orElse: () => TagScreenArgs(tagId: pathParams.getString('id')));
      return _i4.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i6.TagScreen(key: args.key, tagId: args.tagId));
    },
    PlaylistGenerationScreen.name: (routeData) {
      final args = routeData.argsAs<PlaylistGenerationScreenArgs>(
          orElse: () => const PlaylistGenerationScreenArgs());
      return _i4.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i7.PlaylistGenerationScreen(key: args.key));
    },
    ProfileScreen.name: (routeData) {
      final args = routeData.argsAs<ProfileScreenArgs>(
          orElse: () => const ProfileScreenArgs());
      return _i4.MaterialPageX<dynamic>(
          routeData: routeData, child: _i8.ProfileScreen(key: args.key));
    }
  };

  @override
  List<_i4.RouteConfig> get routes => [
        _i4.RouteConfig(AutoTabsScaffoldRoute.name, path: '/', guards: [
          authGuard
        ], children: [
          _i4.RouteConfig(HomeRouter.name,
              path: 'tags',
              parent: AutoTabsScaffoldRoute.name,
              children: [
                _i4.RouteConfig(HomeRoute.name,
                    path: '', parent: HomeRouter.name, guards: [authGuard]),
                _i4.RouteConfig(TagScreen.name,
                    path: ':id', parent: HomeRouter.name, guards: [authGuard])
              ]),
          _i4.RouteConfig(TagRouter.name,
              path: 'generate',
              parent: AutoTabsScaffoldRoute.name,
              children: [
                _i4.RouteConfig(PlaylistGenerationScreen.name,
                    path: '', parent: TagRouter.name, guards: [authGuard])
              ]),
          _i4.RouteConfig(ProfileRouter.name,
              path: 'profile',
              parent: AutoTabsScaffoldRoute.name,
              children: [
                _i4.RouteConfig(ProfileScreen.name,
                    path: '', parent: ProfileRouter.name, guards: [authGuard])
              ])
        ]),
        _i4.RouteConfig(LoginRouter.name, path: '/login'),
        _i4.RouteConfig(SignupRouter.name, path: '/signup')
      ];
}

/// generated route for
/// [_i1.AutoTabsScaffoldPage]
class AutoTabsScaffoldRoute extends _i4.PageRouteInfo<void> {
  const AutoTabsScaffoldRoute({List<_i4.PageRouteInfo>? children})
      : super(AutoTabsScaffoldRoute.name, path: '/', initialChildren: children);

  static const String name = 'AutoTabsScaffoldRoute';
}

/// generated route for
/// [_i2.LoginPage]
class LoginRouter extends _i4.PageRouteInfo<void> {
  const LoginRouter() : super(LoginRouter.name, path: '/login');

  static const String name = 'LoginRouter';
}

/// generated route for
/// [_i3.SignUpPage]
class SignupRouter extends _i4.PageRouteInfo<void> {
  const SignupRouter() : super(SignupRouter.name, path: '/signup');

  static const String name = 'SignupRouter';
}

/// generated route for
/// [_i4.EmptyRouterPage]
class HomeRouter extends _i4.PageRouteInfo<void> {
  const HomeRouter({List<_i4.PageRouteInfo>? children})
      : super(HomeRouter.name, path: 'tags', initialChildren: children);

  static const String name = 'HomeRouter';
}

/// generated route for
/// [_i4.EmptyRouterPage]
class TagRouter extends _i4.PageRouteInfo<void> {
  const TagRouter({List<_i4.PageRouteInfo>? children})
      : super(TagRouter.name, path: 'generate', initialChildren: children);

  static const String name = 'TagRouter';
}

/// generated route for
/// [_i4.EmptyRouterPage]
class ProfileRouter extends _i4.PageRouteInfo<void> {
  const ProfileRouter({List<_i4.PageRouteInfo>? children})
      : super(ProfileRouter.name, path: 'profile', initialChildren: children);

  static const String name = 'ProfileRouter';
}

/// generated route for
/// [_i5.HomePage]
class HomeRoute extends _i4.PageRouteInfo<HomeRouteArgs> {
  HomeRoute({_i9.Key? key})
      : super(HomeRoute.name, path: '', args: HomeRouteArgs(key: key));

  static const String name = 'HomeRoute';
}

class HomeRouteArgs {
  const HomeRouteArgs({this.key});

  final _i9.Key? key;

  @override
  String toString() {
    return 'HomeRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i6.TagScreen]
class TagScreen extends _i4.PageRouteInfo<TagScreenArgs> {
  TagScreen({_i9.Key? key, required String tagId})
      : super(TagScreen.name,
            path: ':id',
            args: TagScreenArgs(key: key, tagId: tagId),
            rawPathParams: {'id': tagId});

  static const String name = 'TagScreen';
}

class TagScreenArgs {
  const TagScreenArgs({this.key, required this.tagId});

  final _i9.Key? key;

  final String tagId;

  @override
  String toString() {
    return 'TagScreenArgs{key: $key, tagId: $tagId}';
  }
}

/// generated route for
/// [_i7.PlaylistGenerationScreen]
class PlaylistGenerationScreen
    extends _i4.PageRouteInfo<PlaylistGenerationScreenArgs> {
  PlaylistGenerationScreen({_i9.Key? key})
      : super(PlaylistGenerationScreen.name,
            path: '', args: PlaylistGenerationScreenArgs(key: key));

  static const String name = 'PlaylistGenerationScreen';
}

class PlaylistGenerationScreenArgs {
  const PlaylistGenerationScreenArgs({this.key});

  final _i9.Key? key;

  @override
  String toString() {
    return 'PlaylistGenerationScreenArgs{key: $key}';
  }
}

/// generated route for
/// [_i8.ProfileScreen]
class ProfileScreen extends _i4.PageRouteInfo<ProfileScreenArgs> {
  ProfileScreen({_i9.Key? key})
      : super(ProfileScreen.name, path: '', args: ProfileScreenArgs(key: key));

  static const String name = 'ProfileScreen';
}

class ProfileScreenArgs {
  const ProfileScreenArgs({this.key});

  final _i9.Key? key;

  @override
  String toString() {
    return 'ProfileScreenArgs{key: $key}';
  }
}
