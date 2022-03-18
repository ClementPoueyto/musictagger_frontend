import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:music_tagger/app/app.dart';
import 'package:music_tagger/spotify/api_path.dart';
import 'package:music_tagger/spotify/spotify_auth_api.dart';
import 'package:user_repository/user_repository.dart';
import '../../app/router/root_router_delegate.dart';
import '../../app/router/root_router_parser.dart';
import '../../app/router/router_cubit.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  HomePage({Key? key}) : super(key: key);

  static Page page() => MaterialPage<void>(child: HomePage());

  Widget get _router => BlocBuilder<RouterCubit, RouterState>(
    builder: (context, state) => MaterialApp.router(
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ).copyWith(secondary: Colors.yellow),
      ),
      routerDelegate: RootRouterDelegate(
        navigatorKey,
        context.read<RouterCubit>(),
      ),
      routeInformationParser: const RootRouterParser(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final user = context.select((AppBloc bloc) => bloc.state.user);
    print("TTTTTEEEEEEEEEESSSSSSSSSTTTTTTTT");
    print(user);
    return _router;/*Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: <Widget>[
          IconButton(
            key: const Key('homePage_logout_iconButton'),
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => context.read<AppBloc>().add(AppLogoutRequested()),
          )
        ],
      ),
      body: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Avatar(photo: user.photo),
            const SizedBox(height: 4),
            Text(user.email ?? '', style: textTheme.headline6),
            const SizedBox(height: 4),
            Text(user.name ?? '', style: textTheme.headline5),
            ElevatedButton(
                child: const Text('spotify auth'),
                onPressed: () {
                  authenticate(Theme.of(context).platform==TargetPlatform.android?dotenv.env['REDIRECT_URL_MOBILE'].toString():dotenv.env['REDIRECT_URL_WEB'].toString());}
            ),
          ],
        ),
      ),
    );*/
  }




  Future<void> authenticate(String redirect) async {
    final state = _getRandomString(6);
    String clientId = dotenv.env['CLIENT_ID']!;
    String clientSecret = dotenv.env['CLIENT_SECRET']!;
    try {
      print( dotenv.env["CALLBACK_URL"]);
      final result = await FlutterWebAuth.authenticate(
        url: APIPath.requestAuthorization(clientId, redirect, state),
        callbackUrlScheme: dotenv.env["CALLBACK_URL"]!,
      );
      print(result);
      // Validate state from response
      final returnedState = Uri.parse(result).queryParameters['state'];
      if (state != returnedState) throw HttpException('Invalid access');

      final code = Uri.parse(result).queryParameters['code'];
      final tokens = await SpotifyAuthApi.getAuthTokens(code!, redirect);

      print(tokens.refreshToken);
      print(tokens.accessToken);
      UserRepository userRepository = new UserRepository();
      SpotifyUser spotifyUser = new SpotifyUser(tokens.accessToken, tokens.refreshToken);
      userRepository.updateSpotifyUser(spotifyUser);
    } on Exception catch (e) {
      print(e);
      rethrow;
    }
  }

  static String _getRandomString(int length) {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }
}
