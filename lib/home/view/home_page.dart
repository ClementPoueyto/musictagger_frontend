import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_tagger/app/app.dart';
import 'package:music_tagger/tags/cubit/tags_cubit.dart';
import 'package:music_tagger/widgets/tag_box.dart';
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
          BlocProvider.of<TagsCubit>(context).fetchTags(userId);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userAuth = context.select((AuthBloc bloc) => bloc.state.userAuth);
    setupScrollController(context, userAuth.id);

    print(userAuth);
    return Scaffold(
      appBar: CustomAppBar(
          title: 'Home',
          function: () async => {
                AutoRouter.of(context).push(LoginRouter()),
                context.read<AuthBloc>().add(AuthLogoutRequested())
              }),
      body: Align(alignment: const Alignment(0, -1 / 3), child: _tagList(userAuth.id)),
    );
  }

  Widget _tagList(String userId) {
    return BlocBuilder<TagsCubit, TagsState>(builder: (context, state) {
      if (state is TagsLoading && state.isFirstFetch) {
        return _loadingIndicator();
      }

      List<Tag> tags = [];
      bool isLoading = false;

      if (state is TagsLoading) {
        tags = state.oldTags;
        isLoading = true;
      } else if (state is TagsLoaded) {
        tags = state.tags;
      }

      return RefreshIndicator(
          onRefresh: (){return _onRefresh(context,userId);},
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

                return _loadingIndicator();
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
    BlocProvider.of<TagsCubit>(context).refreshTags(userId);

  }

  Widget _loadingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _tag(Tag tag, int index, BuildContext context) {
    return InkWell(
      onTap: (){AutoRouter.of(context).pushNamed(tag.id.toString());},
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
                    child: Image.network(
                      tag.track.image!,
                      loadingBuilder: (context, widget, imageChunkEvent) {
                        return imageChunkEvent == null
                            ? widget
                            : CircularProgressIndicator();
                      },
                    ),
                  ),
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
              child: Wrap(
                direction: Axis.horizontal,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                children: [for (String tag in tag.tags) TagBox(tag: tag, size :12)],
              ),
            ),
            Expanded(flex: 1, child: Center(child: Icon(Icons.chevron_right))),
          ],
        ),
      ),
    );
  }
}
