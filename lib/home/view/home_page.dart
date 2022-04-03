import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:music_tagger/app/app.dart';
import 'package:music_tagger/home/home.dart';
import 'package:music_tagger/spotify/api_path.dart';
import 'package:music_tagger/spotify/spotify_auth_api.dart';
import 'package:music_tagger/widgets/widgets.dart';
import 'package:tag_repository/tag_repository.dart';
import '../../router/routes.gr.dart';



class HomePage extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  HomePage({Key? key}) : super(key: key);

  static const String routeName = '/home';


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final userAuth = context.select((AuthBloc bloc) => bloc.state.userAuth);
    print(userAuth);
    return Scaffold(
      appBar: CustomAppBar(title:"Home", function: () async => {
        await AutoRouter.of(context).push(LoginRouter()),
        context.read<AuthBloc>().add(AuthLogoutRequested())}),
      body: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Avatar(photo: userAuth.photo),
            const SizedBox(height: 4),
            Text(userAuth.email ?? '', style: textTheme.headline6),
            const SizedBox(height: 4),
            Text(userAuth.name ?? '', style: textTheme.headline5),
            ElevatedButton(
                child: const Text('spotify auth'),
                onPressed: () =>{
                  authenticate(Theme.of(context).platform==TargetPlatform.android?dotenv.env['REDIRECT_URL_MOBILE'].toString():dotenv.env['REDIRECT_URL_WEB'].toString(),
                Theme.of(context).platform==TargetPlatform.android?dotenv.env['CALLBACK_URL_MOBILE'].toString():dotenv.env['CALLBACK_URL_WEB'].toString(),
                  User.empty)}
            ),
          ],
        ),
      ),
    );
  }




  Future<void> authenticate(String redirect, String callback, User user) async {
    final state = _getRandomString(6);
    String clientId = dotenv.env['CLIENT_ID']!;
    String clientSecret = dotenv.env['CLIENT_SECRET']!;
    try {
      final result = await FlutterWebAuth.authenticate(
        url: APIPath.requestAuthorization(clientId, redirect, state),
        callbackUrlScheme: callback,
      );
      print(result);
      // Validate state from response
      final returnedState = Uri.parse(result).queryParameters['state'];
      if (state != returnedState) throw HttpException('Invalid access');

      final code = Uri.parse(result).queryParameters['code'];
      final tokens = await SpotifyAuthApi.getAuthTokens(code!, redirect);

      print(tokens.refreshToken);
      print(tokens.accessToken);
      TagRepository tagRepository = new TagRepository();
      SpotifyUser spotifyUser = new SpotifyUser(tokens.accessToken, tokens.refreshToken);

      //userRepository.connectSpotify();
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
