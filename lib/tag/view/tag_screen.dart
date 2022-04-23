import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_tagger/app/app.dart';
import 'package:music_tagger/widgets/tag_button.dart';
import 'package:tag_repository/tag_repository.dart';
import '../../tags/cubit/tags_cubit.dart';
import '../../widgets/avatar.dart';
import '../../widgets/tag_box.dart';
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
    BlocProvider.of<TagCubit>(context).fetchTag(tagId);
    BlocProvider.of<TagNamesCubit>(context).fetchTagNames(userAuth.id);

    return Scaffold(
      appBar: AppBar(leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => AutoRouter.of(context).pop()
      ), ),
      body: _tag(),
    );
  }

  Widget _tag() {
    return BlocBuilder<TagCubit, TagState>(builder: (context, state) {

      Tag tag = Tag.empty;
      bool isLoading = false;

      if (state is TagLoading) {
        isLoading = true;
        return _loadingIndicator();
      }
      else if (state is TagLoaded) {
        tag = state.tag;
        return BlocBuilder<TagNamesCubit, TagNamesState>(builder: (nameContext, nameState) {
          return SafeArea(child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 4),
                Avatar(photo: tag.track.image),
                const SizedBox(height: 4),
                Center(child : Text(tag.track.artistName)),
                const SizedBox(height: 4),
                Center(child : Text(tag.track.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)),
                const SizedBox(height: 4),
                Center(child : Text(tag.track.albumName)),
                const SizedBox(height: 30),
                if(nameState is TagNamesLoaded)
                  _widgetTags(nameContext, nameState, tag)
                else _loadingIndicator()
              ],
            ));});
      }
      else{
        return _loadingIndicator();
      }

    });
  }

  Widget _widgetTags(BuildContext context,TagNamesLoaded state, Tag tag) {
    return Tags(
      key: key,
        textField: TagsTextField(
        hintText: "Aouter un tag",
        textStyle: TextStyle(fontSize: 12,),
    constraintSuggestion: false,
          suggestions: [],
    //width: double.infinity, padding: EdgeInsets.symmetric(horizontal: 10),
    onSubmitted: (String str) async {
          if(!state.names.contains(str)&& str.length<50) {
            await _onTagSelected(context, str, tag);
            BlocProvider.of<TagNamesCubit>(context).updateTags([...state.names, str]);
          }
    },),
      itemCount: state.names.length,
      itemBuilder: (index) {
        final String item = state.names[index];

        return ItemTags(
          key: Key(index.toString()),
          index: index,
          title: item,
          active: tag.tags.contains(item),
          pressEnabled: true,
          textStyle: TextStyle(
            fontSize: 16,
          ),
          onPressed: (_) => _onTagSelected(context,item, tag),
        );
      },
    );
  }

  Future _onTagSelected (BuildContext context, String name, Tag tag)async{
    print(name);
    final List<String> copy = List.from(tag.tags);
    if(!tag.tags.contains(name)){
      copy.add(name);
    }
    else{
      copy.remove(name);
    }
    BlocProvider.of<TagsCubit>(context).updateTag(Tag(tag.id,copy,tag.track, tag.userId));

    await BlocProvider.of<TagCubit>(context).updateTag(Tag(tag.id,copy,tag.track, tag.userId));
  }

  Widget _loadingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

}