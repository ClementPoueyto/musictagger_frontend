import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:music_tagger/app/bloc/auth_bloc.dart';
import 'package:music_tagger/playlists_generation/cubit/playlists_generation_cubit.dart';
import 'package:music_tagger/tag/cubit/tag_names_cubit.dart';
import 'package:music_tagger/widgets/widgets.dart';

class PlaylistGenerationScreen extends StatelessWidget {
  const PlaylistGenerationScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userAuth = context.select((AuthBloc bloc) => bloc.state.userAuth);
    BlocProvider.of<TagNamesCubit>(context).fetchTagNames(userAuth.id);
    final theme = Theme.of(context);

    return Scaffold(
        body: BlocBuilder<TagNamesCubit, TagNamesState>(
            builder: (tagsContext, tagsState) {
          if (tagsState is TagNamesLoaded) {
            return BlocBuilder<PlaylistsGenerationCubit,
                    PlaylistsGenerationState>(
                builder: (playlistContext, playlistState) {
              if (playlistState is PlaylistsGenerationLoaded) {
                return Padding(padding: EdgeInsets.all(15), child :ListView(children: [
                  SafeArea(
                      child: Center(
                          child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(height: 30),
                      Tags(
                        key: key,
                        itemCount: tagsState.names.length,
                        itemBuilder: (index) {
                          final item = tagsState.names[index];

                          return ItemTags(
                            key: Key(index.toString()),
                            index: index,
                            title: item,
                            elevation: 0,
                            border: const Border.fromBorderSide(BorderSide.none),
                            activeColor: theme.colorScheme.secondary,
                            active: playlistState.selected.contains(item),
                            onPressed: (_) => {
                              context
                                  .read<PlaylistsGenerationCubit>()
                                  .updateSelectedTag(item)
                            },
                            textStyle: const TextStyle(
                              fontSize: 16,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 30),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: theme.primaryColor),
                          child: const Text('Generer playlist'),
                          onPressed: () async => {
                            await context.read<PlaylistsGenerationCubit>().generatePlaylist(userAuth.id, playlistState.selected)

                        }),
                    ],
                  )))
                ]));
              } else {
                return const LoadingIndicator();
              }
            });
          } else {
            return LoadingIndicator();
          }
        }));
  }
}
