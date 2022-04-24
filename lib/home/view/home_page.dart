import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart' as Tags_X;
import 'package:music_tagger/app/app.dart';
import 'package:music_tagger/tags/cubit/tags_cubit.dart';
import 'package:music_tagger/widgets/widgets.dart';
import '../../router/routes.gr.dart';
import 'package:tag_repository/tag_repository.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  final scrollController = ScrollController();

  HomePage({Key? key}) : super(key: key);

  static const String routeName = '/tags';

  void setupScrollController(BuildContext context, String userId) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          BlocProvider.of<TagsCubit>(context).fetchTags(userId, null);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userAuth = context.select((AuthBloc bloc) => bloc.state.userAuth);
    final debouncer =
        Debouncer<String>(const Duration(milliseconds: 500), initialValue: '');
    debouncer.values
        .listen((search) => debounceTick(context, userAuth.id, search));
    setupScrollController(context, userAuth.id);

    print(userAuth);
    return Scaffold(
        appBar: CustomAppBar(
          title: 'Home',
        ),
        body: Align(
            alignment: const Alignment(0, -1 / 3),
            child: Column(children: [
              Container(
                margin: EdgeInsets.all(16),
                child: TextField(
                  onChanged: (value) => {
                    debouncer.value = value,
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.search),
                    hintText:
                        "rechercher par nom de musique, d'artiste, d'album",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.blue)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),

                  ),
                ),
              ),
              Expanded(child: _tagList(userAuth.id)),
            ],),),);
  }

  void debounceTick(BuildContext context, String userId, String value) {
    context.read<TagsCubit>().fetchTags(userId, value);
  }

  Widget _tagList(String userId) {
    return BlocBuilder<TagsCubit, TagsState>(builder: (context, state) {
      if (state is TagsLoading && state.pageIndex == 0) {
        return const LoadingIndicator();
      }

      List<Tag> tags = [];
      bool isLoading = false;

      if (state is TagsLoading) {
        tags = state.oldTags;
        isLoading = true;
        return const LoadingIndicator();
      } else if (state is TagsLoaded) {
        tags = state.tags;
        if(tags.isEmpty) return const Center(child: Text("Aucun résultat"),);
      }

      return RefreshIndicator(
          onRefresh: () {
            return _onRefresh(context, userId);
          },
          child: ListView.separated(
            controller: scrollController,
            itemBuilder: (context, index) {
              if (index < tags.length) {
                return _tag(tags[index], index, context);
              } else {
                Timer(const Duration(milliseconds: 30), () {
                  scrollController
                      .jumpTo(scrollController.position.maxScrollExtent);
                });

                return const LoadingIndicator();
              }
            },
            separatorBuilder: (context, index) {
              return Divider(
                color: Colors.grey[400],
              );
            },
            itemCount: tags.length + (isLoading ? 1 : 0),
          ));
    });
  }

  Future<void> _onRefresh(BuildContext context, String userId) async {
    await BlocProvider.of<TagsCubit>(context).refreshTags(userId);
  }

  Widget _tag(Tag tag, int index, BuildContext context) {
    return InkWell(
      onTap: () {
        AutoRouter.of(context).pushNamed(tag.id.toString());
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: kIsWeb ? 2 : 10,
              child: Row(
                children: [
                  if (kIsWeb)
                    Expanded(
                      flex: 1,
                      child: Text(
                        "${index + 1}",
                        style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  Expanded(
                      flex: 5,
                      child: CachedNetworkImage(
                        imageUrl: tag.track.image!,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                LoadingIndicator(),
                        errorWidget: (context, url, dynamic error) =>
                            Icon(Icons.error),
                      )),
                  Expanded(
                    flex: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tag.track.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          tag.track.artistName,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (kIsWeb)
              Expanded(
                flex: 1,
                child: Text(tag.track.albumName),
              ),
            Expanded(
                flex: 5,
                child:
                    tag.tags.length > 0 ? _widgetTags(tag) : SizedBox.shrink()),
            Expanded(flex: 1, child: Center(child: Icon(Icons.chevron_right))),
          ],
        ),
      ),
    );
  }

  Widget _widgetTags(Tag tag) {
    return Tags_X.Tags(
      key: key,
      itemCount: tag.tags.length,
      itemBuilder: (index) {
        final String item = tag.tags[index];

        return Tags_X.ItemTags(
          key: Key(index.toString()),
          index: index,
          title: item,
          pressEnabled: false,
          textStyle: TextStyle(
            fontSize: kIsWeb ? 16 : 11,
          ),
        );
      },
    );
  }
}
