import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_tagger/app/app.dart';
import 'package:music_tagger/home/home.dart';
import 'package:tag_repository/tag_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import '../../home/view/home_page.dart';
import '../../widgets/avatar.dart';
import '../../widgets/loading_indicator.dart';
import '../cubit/tag_cubit.dart';
import '../cubit/tag_names_cubit.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';

class TagScreen extends StatelessWidget {
  String tagId;

  TagScreen({Key? key, @PathParam('id') required this.tagId}) : super(key: key);

  static const String routeName = '/tags/:id';

  @override
  Widget build(BuildContext context) {
    final userAuth = context.select((AuthBloc bloc) => bloc.state.userAuth);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () =>
                AutoRouter.of(context).navigateNamed(HomePage.routeName)),
      ),
      body: BlocProvider(
        create: (_) => TagCubit(context.read<TagRepository>(),
            context.read<AuthenticationRepository>()),
        child: TagWidget(tagId, userAuth.id),

      ),
    );
  }
}

class TagWidget extends StatelessWidget {
  TagWidget(String this.tagId, String this.userId, {Key? key})
      : super(key: key);

  String tagId;
  String userId;

  @override
  Widget build(BuildContext context) {
    context.read<TagCubit>().fetchTag(tagId);
    context.read<TagNamesCubit>().fetchTagNames(userId);
    return BlocBuilder<TagCubit, TagState>(builder: (context, state) {
      Tag tag = Tag.empty;

      if (state is TagLoading) {
        return const LoadingIndicator();
      } else if (state is TagLoaded) {
        tag = state.tag;
        return BlocBuilder<TagNamesCubit, TagNamesState>(
            builder: (nameContext, nameState) {
          return SafeArea(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 4),
              Avatar(photo: tag.track.image),
              const SizedBox(height: 4),
              Center(child: Text(tag.track.artistName)),
              const SizedBox(height: 4),
              Center(
                  child: Text(
                tag.track.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )),
              const SizedBox(height: 4),
              Center(child: Text(tag.track.albumName)),
              const SizedBox(height: 30),
              if (nameState is TagNamesLoaded)
                _widgetTags(nameContext, nameState, tag)
              else
                const LoadingIndicator()
            ],
          ));
        });
      } else {
        return const LoadingIndicator();
      }
    });
  }

  Widget _loadingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _widgetTags(BuildContext context, TagNamesLoaded state, Tag tag) {
    return Tags(
      key: key,
      textField: TagsTextField(
        helperText: "test",
        hintText: "Aouter un tag",
        textStyle: TextStyle(
          fontSize: 12,
        ),
        constraintSuggestion: false,
        suggestions: [],
        //width: double.infinity, padding: EdgeInsets.symmetric(horizontal: 10),
        onSubmitted: (String str) async {
          if(!this.isTagNameValid(str)) return;
          if (!state.names.contains(str) && str.length < 50) {
            await _onTagSelected(context, str, tag);
            BlocProvider.of<TagNamesCubit>(context)
                .updateTags([...state.names, str]);
          }
        },
      ),
      itemCount: state.names.length,
      itemBuilder: (index) {
        final item = state.names[index];

        return ItemTags(
          key: Key(index.toString()),
          index: index,
          title: item,
          active: tag.tags.contains(item),
          textStyle: const TextStyle(
            fontSize: 16,
          ),
          onPressed: (_) => _onTagSelected(context, item, tag),
        );
      },
    );
  }

  Future _onTagSelected(BuildContext context, String name, Tag tag) async {
    print(name);
    final copy = List<String>.from(tag.tags);
    if (!tag.tags.contains(name)) {
      copy.add(name);
    } else {
      copy.remove(name);
    }
     await BlocProvider.of<TagsCubit>(context)
        .updateTag(Tag(tag.id, copy, tag.track, tag.userId));

    await BlocProvider.of<TagCubit>(context)
        .updateTag(Tag(tag.id, copy, tag.track, tag.userId));
  }

  bool isTagNameValid(String str){
    if(str.trim().isEmpty) return false;
    if(str.contains('\'')||str.contains('\"')||str.contains(',')) return false;
    return true;
  }
}
