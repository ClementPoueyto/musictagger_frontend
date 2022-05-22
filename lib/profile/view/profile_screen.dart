import 'dart:math';
import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_tagger/app/app.dart';
import 'package:music_tagger/home/cubit/tags_cubit.dart';
import 'package:music_tagger/profile/cubit/profile_cubit.dart';
import 'package:music_tagger/router/routes.gr.dart';
import 'package:music_tagger/secret.dart';
import 'package:music_tagger/spotify/api_path.dart';
import 'package:music_tagger/spotify/spotify_auth_api.dart';
import 'package:music_tagger/tag/cubit/tag_names_cubit.dart';
import 'package:tag_repository/tag_repository.dart';
import 'package:music_tagger/widgets/widgets.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile';
  ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = context.select((AuthBloc bloc) => bloc.state.userAuth);

    print(user);
    return Scaffold(
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ProfileLoaded) {
            final isConnectedToSpotify = (state.user.spotifyUser != null &&
                state.user.spotifyUser.spotifyRefreshToken != null);
            return Align(
                alignment: const Alignment(0, -1 / 3),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Avatar(photo: user.photo),
                    const SizedBox(height: 4),
                    Text(user.email ?? '', style: theme.textTheme.headline6),
                    const SizedBox(height: 4),
                    Text(user.name ?? '', style: theme.textTheme.headline5),
                    Center(
                      child: Text(
                          isConnectedToSpotify ? "Connecté" : "Non Connecté"),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: theme.primaryColor
                        ),
                        child: const Text('Spotify'),
                        onPressed: () async => {
                              updateUser(
                                  context,
                                  state,
                                  await authenticate(
                                    kIsWeb
                                        ? REDIRECT_URL_WEB.toString()
                                        :REDIRECT_URL_MOBILE.toString(),
                                    kIsWeb
                                        ? CALLBACK_URL_WEB
                                        .toString():CALLBACK_URL_MOBILE
                                            .toString(),

                                  ))
                            }),
                    const SizedBox(
                      height: 4,
                    ),
                    if (isConnectedToSpotify)
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: theme.primaryColor,
                          ),
                          child:  Text('importer mes musiques',
                              ),
                          onPressed: () async => {
                                await BlocProvider.of<ProfileCubit>(context)
                                    .importTracksFromSpotify(state.user.id),
                                await BlocProvider.of<TagsCubit>(context)
                                    .refreshTags(state.user.id)
                              }),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                        ),
                        child: Text('Se déconnecter', style: TextStyle(color: theme.primaryColor),),
                        onPressed: () async => {
                          logout(context)
                        }),


                  ],
                ));
          }
          if (state is ProfileError) {
            return Text('Something went wrong.' + state.error);
          } else {
            return Text('Something went wrong.');
          }
        },
      ),
    );
  }

  Future<void> logout(BuildContext context)async {
    context.read<AuthBloc>().add(AuthLogoutRequested());
    await AutoRouter.of(context).push(const LoginRouter());


  }
  Future<void> updateUser(BuildContext context, ProfileLoaded state,
      SpotifyUser spotifyUser) async {
    final user = User(state.user.id, spotifyUser);
    await context.read<ProfileCubit>().connectSpotify(user);
  }

  Future<SpotifyUser> authenticate(String redirect, String callback) async {
    final state = _getRandomString(6);
    String clientId = CLIENT_ID;
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
      return SpotifyUser(tokens.accessToken, tokens.refreshToken);
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
