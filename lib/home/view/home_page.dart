import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart' as X;
import 'package:music_tagger/app/app.dart';
import 'package:music_tagger/home/home.dart';
import 'package:music_tagger/tag/cubit/tag_names_cubit.dart';
import 'package:music_tagger/widgets/widgets.dart';
import 'package:tag_repository/tag_repository.dart';

import '../../utils/constants.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  final scrollController = ScrollController();
  final _controller = TextEditingController();
  final debouncer =
      Debouncer<String>(const Duration(milliseconds: 500), initialValue: '');
  HomePage({Key? key}) : super(key: key) {
    _controller.addListener(() {
      debouncer.value = _controller.text;
    });
  }

  static const String routeName = '/tags';

  void setupScrollController(BuildContext context, String userId) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0 &&
            context.read<TagsCubit>().state is! TagsLoading) {
          BlocProvider.of<TagsCubit>(context).fetchTags(userId, null, null);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size.width;
    final userAuth = context.select((AuthBloc bloc) => bloc.state.userAuth);
    context.read<TagNamesCubit>().fetchTagNames(userAuth.id);
    debouncer.values
        .listen((search) => debounceTick(context, userAuth.id, search));

    setupScrollController(context, userAuth.id);

    print(userAuth);
    return Scaffold(body:
        BlocBuilder<TagsCubit, TagsState>(builder: (contextTags, stateTags) {
      if (stateTags is TagsLoaded) {
        _controller.text = stateTags.search;
      }

      return Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          children: [
            BlocBuilder<TagNamesCubit, TagNamesState>(
                builder: (contextTagNames, stateTagNames) {
              return Row(
                children: [
                  Expanded(
                    flex: 9,
                    child: Container(
                      margin: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: const Icon(Icons.search),
                          hintText:
                              "nom de musique, d'artiste, d'album",
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          suffixIcon: _controller.text.isNotEmpty
                              ? IconButton(
                                  onPressed: _controller.clear,
                                  icon: Icon(Icons.clear),
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          if (stateTagNames is TagNamesLoaded &&
                              stateTags is TagsLoaded) {
                            openFilterDialog(contextTagNames, userAuth.id,
                                stateTagNames, stateTags);
                          }
                        },
                        icon: const Icon(
                          // <-- Icon
                          Icons.filter_list,
                          size: 24,
                        ),
                      ),
                    ),
                  )
                ],
              );
            }),
            if (stateTags is TagsLoaded)
              Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 15),
                  child: X.Tags(
                    key: key,
                    itemCount:stateTags.filters.length,
                    itemBuilder: (index) {
                      final item = stateTags.filters[index];

                      return X.ItemTags(
                        key: Key(index.toString()),
                        index: index,
                        title: item,
                        elevation: 0,
                        activeColor: Colors.white,
                        textActiveColor: Colors.black,
                        border: const Border.fromBorderSide(BorderSide.none),
                        combine: X.ItemTagsCombine.withTextBefore,
                        removeButton: X.ItemTagsRemoveButton(
                          onRemoved: (){
                            final list = List.of(stateTags.filters);
                            list.removeAt(index);
                            context.read<TagsCubit>().fetchTags(userAuth.id, null, list);
                            return true;
                          },
                        ), //
                        textStyle:  TextStyle(
                          fontSize: ((size >MOBILE_SIZE) ? 16 : 11),
                          color: Colors.black
                        ),
                      );
                    },
                  ),),
            Expanded(child: _tagList(context, userAuth.id, stateTags)),
          ],
        ),
      );
    }));
  }

  void debounceTick(BuildContext context, String userId, String value) {
    context.read<TagsCubit>().fetchTags(userId, value, null);
  }

  Widget _tagList(BuildContext context, String userId, TagsState state) {
    if (state is TagsLoading && state.pageIndex == 0) {
      return const LoadingIndicator();
    }

    var tags = <Tag>[];
    var isLoading = false;

    if (state is TagsLoading) {
      tags = state.oldTags;
      isLoading = true;
      if (state.pageIndex == 0) return const LoadingIndicator();
    } else if (state is TagsLoaded) {
      tags = state.tags;
      if (tags.isEmpty) {
        return const Center(
          child: Text('Aucun résultat'),
        );
      }
    }

    return RefreshIndicator(
        onRefresh: () {
          return _onRefresh(context, userId);
        },
        child: ListView.separated(
          controller: scrollController,
          itemBuilder: (context, index) {
            if (index < tags.length) {
              return TrackTagTile(tag: tags[index], index: index);
            } else {
              Timer(const Duration(milliseconds: 500), () {
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
  }

  Future<void> _onRefresh(BuildContext context, String userId) async {
    await BlocProvider.of<TagsCubit>(context).refreshTags(userId);
  }

  Future<void> openFilterDialog(BuildContext context, String userId,
      TagNamesLoaded stateTagNames, TagsLoaded stateTags) async {
    await FilterListDialog.display<String>(
      context,
      listData: stateTagNames.names,
      hideheader: true,
      hideSearchField: true,
      selectedListData: stateTags.filters,
      choiceChipLabel: (tag) => tag!,
      validateSelectedItem: (list, val) => list!.contains(val),
      selectedItemsText: 'tags sélectionnés',
      allButtonText: 'Tous',
      resetButtonText: 'Réinitialiser',
      applyButtonText: 'Appliquer',
      onItemSearch: (tag, query) {
        return tag.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) async {
        context.read<TagsCubit>().fetchTags(userId, null, list);
        await AutoRouter.of(context).pop();
      },
    );
  }
}
