import 'dart:math';
import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_tagger/app/app.dart';
import 'package:music_tagger/home/home.dart';
import 'package:music_tagger/login/login.dart';
import 'package:music_tagger/login/view/view.dart';
import 'package:music_tagger/router/routes.gr.dart';
import 'package:music_tagger/spotify/api_path.dart';
import 'package:music_tagger/spotify/spotify_auth_api.dart';
import 'package:user_repository/user_repository.dart';



class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile';

  static Route route() {
    return MaterialPageRoute<dynamic>(
      settings: RouteSettings(name: routeName),
      builder: (context) => ProfileScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final user = context.select((AppBloc bloc) => bloc.state.user);
    print(user);
    return Scaffold(
      appBar: CustomAppBar(title:"Profile", function: () async => {
        AutoRouter.of(context).replace(LoginRouter())
        ,
        context.read<AppBloc>().add(AppLogoutRequested())}),
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
                onPressed: () => {
                  authenticate(Theme.of(context).platform==TargetPlatform.android?dotenv.env['REDIRECT_URL_MOBILE'].toString():dotenv.env['REDIRECT_URL_WEB'].toString(),
                      Theme.of(context).platform==TargetPlatform.android?dotenv.env['CALLBACK_URL_MOBILE'].toString():dotenv.env['CALLBACK_URL_WEB'].toString())}
            ),
          ],
        ),
      ),
    );
  }


  Future<void> authenticate(String redirect, String callback) async {
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

class TitleWithIcon extends StatelessWidget {
  final String title;
  final IconData icon;

  const TitleWithIcon({
    Key? key,
    required this.title,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline3,
        ),
        IconButton(
          icon: Icon(icon),
          onPressed: () {},
        ),
      ],
    );
  }

}
