// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i3;
import 'package:flutter/material.dart' as _i6;

import '../home/home.dart' as _i4;
import '../home/widgets/custom_bottom_app_bar.dart' as _i1;
import '../login/login.dart' as _i2;
import '../screens/screens.dart' as _i5;
import 'AuthGuard.dart' as _i7;

class AppRouter extends _i3.RootStackRouter {
  AppRouter(
      {_i6.GlobalKey<_i6.NavigatorState>? navigatorKey,
      required this.authGuard})
      : super(navigatorKey);

  final _i7.AuthGuard authGuard;

  @override
  final Map<String, _i3.PageFactory> pagesMap = {
    AutoTabsScaffoldRoute.name: (routeData) {
      return _i3.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.AutoTabsScaffoldPage());
    },
    LoginRouter.name: (routeData) {
      return _i3.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.LoginPage());
    },
    HomeRouter.name: (routeData) {
      return _i3.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i3.EmptyRouterPage());
    },
    ProfileRouter.name: (routeData) {
      return _i3.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i3.EmptyRouterPage());
    },
    HomeRoute.name: (routeData) {
      final args =
          routeData.argsAs<HomeRouteArgs>(orElse: () => const HomeRouteArgs());
      return _i3.MaterialPageX<dynamic>(
          routeData: routeData, child: _i4.HomePage(key: args.key));
    },
    ProfileScreen.name: (routeData) {
      final args = routeData.argsAs<ProfileScreenArgs>(
          orElse: () => const ProfileScreenArgs());
      return _i3.MaterialPageX<dynamic>(
          routeData: routeData, child: _i5.ProfileScreen(key: args.key));
    }
  };

  @override
  List<_i3.RouteConfig> get routes => [
        _i3.RouteConfig(AutoTabsScaffoldRoute.name, path: '/', guards: [
          authGuard
        ], children: [
          _i3.RouteConfig(HomeRouter.name,
              path: 'home',
              parent: AutoTabsScaffoldRoute.name,
              children: [
                _i3.RouteConfig(HomeRoute.name,
                    path: '', parent: HomeRouter.name, guards: [authGuard])
              ]),
          _i3.RouteConfig(ProfileRouter.name,
              path: 'profile',
              parent: AutoTabsScaffoldRoute.name,
              children: [
                _i3.RouteConfig(ProfileScreen.name,
                    path: '', parent: ProfileRouter.name, guards: [authGuard])
              ])
        ]),
        _i3.RouteConfig(LoginRouter.name, path: '/login')
      ];
}

/// generated route for
/// [_i1.AutoTabsScaffoldPage]
class AutoTabsScaffoldRoute extends _i3.PageRouteInfo<void> {
  const AutoTabsScaffoldRoute({List<_i3.PageRouteInfo>? children})
      : super(AutoTabsScaffoldRoute.name, path: '/', initialChildren: children);

  static const String name = 'AutoTabsScaffoldRoute';
}

/// generated route for
/// [_i2.LoginPage]
class LoginRouter extends _i3.PageRouteInfo<void> {
  const LoginRouter() : super(LoginRouter.name, path: '/login');

  static const String name = 'LoginRouter';
}

/// generated route for
/// [_i3.EmptyRouterPage]
class HomeRouter extends _i3.PageRouteInfo<void> {
  const HomeRouter({List<_i3.PageRouteInfo>? children})
      : super(HomeRouter.name, path: 'home', initialChildren: children);

  static const String name = 'HomeRouter';
}

/// generated route for
/// [_i3.EmptyRouterPage]
class ProfileRouter extends _i3.PageRouteInfo<void> {
  const ProfileRouter({List<_i3.PageRouteInfo>? children})
      : super(ProfileRouter.name, path: 'profile', initialChildren: children);

  static const String name = 'ProfileRouter';
}

/// generated route for
/// [_i4.HomePage]
class HomeRoute extends _i3.PageRouteInfo<HomeRouteArgs> {
  HomeRoute({_i6.Key? key})
      : super(HomeRoute.name, path: '', args: HomeRouteArgs(key: key));

  static const String name = 'HomeRoute';
}

class HomeRouteArgs {
  const HomeRouteArgs({this.key});

  final _i6.Key? key;

  @override
  String toString() {
    return 'HomeRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i5.ProfileScreen]
class ProfileScreen extends _i3.PageRouteInfo<ProfileScreenArgs> {
  ProfileScreen({_i6.Key? key})
      : super(ProfileScreen.name, path: '', args: ProfileScreenArgs(key: key));

  static const String name = 'ProfileScreen';
}

class ProfileScreenArgs {
  const ProfileScreenArgs({this.key});

  final _i6.Key? key;

  @override
  String toString() {
    return 'ProfileScreenArgs{key: $key}';
  }
}
