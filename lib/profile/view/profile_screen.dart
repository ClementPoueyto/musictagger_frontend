import 'dart:math';
import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_tagger/app/app.dart';
import 'package:music_tagger/profile/cubit/profile_cubit.dart';
import 'package:music_tagger/router/routes.gr.dart';
import 'package:music_tagger/spotify/api_path.dart';
import 'package:music_tagger/spotify/spotify_auth_api.dart';
import 'package:music_tagger/tag/cubit/tag_names_cubit.dart';
import 'package:tag_repository/tag_repository.dart';
import 'package:music_tagger/widgets/widgets.dart';

import '../../tags/cubit/tags_cubit.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile';
  ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final user = context.select((AuthBloc bloc) => bloc.state.userAuth);

    print(user);
    return Scaffold(
      appBar: CustomAppBar(
        title: "Profile",
      ),
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
                    Text(user.email ?? '', style: textTheme.headline6),
                    const SizedBox(height: 4),
                    Text(user.name ?? '', style: textTheme.headline5),
                    Center(
                      child: Text(
                          isConnectedToSpotify ? "Connecté" : "Non Connecté"),
                    ),
                    ElevatedButton(
                        child: const Text('spotify auth'),
                        onPressed: () async => {
                              updateUser(
                                  context,
                                  state,
                                  await authenticate(
                                    Theme.of(context).platform ==
                                            TargetPlatform.android
                                        ? dotenv.env['REDIRECT_URL_MOBILE']
                                            .toString()
                                        : dotenv.env['REDIRECT_URL_WEB']
                                            .toString(),
                                    Theme.of(context).platform ==
                                            TargetPlatform.android
                                        ? dotenv.env['CALLBACK_URL_MOBILE']
                                            .toString()
                                        : dotenv.env['CALLBACK_URL_WEB']
                                            .toString(),
                                  ))
                            }),
                    const SizedBox(
                      height: 4,
                    ),
                    if (isConnectedToSpotify)
                      ElevatedButton(
                          child: const Text('importer mes musiques'),
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
                        child: const Text('Se déconnecter'),
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
    await AutoRouter.of(context).push(const LoginRouter());
    context.read<AuthBloc>().add(AuthLogoutRequested());
    BlocProvider.of<ProfileCubit>(context).emit(ProfileInitial());
    BlocProvider.of<TagsCubit>(context).emit(TagsInitial());
    BlocProvider.of<TagNamesCubit>(context).emit(TagNamesInitial());


  }
  Future<void> updateUser(BuildContext context, ProfileLoaded state,
      SpotifyUser spotifyUser) async {
    final user = User(state.user.id, spotifyUser);
    await context.read<ProfileCubit>().connectSpotify(user);
  }

  Future<SpotifyUser> authenticate(String redirect, String callback) async {
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
      return new SpotifyUser(tokens.accessToken, tokens.refreshToken);
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
