import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_tagger/app/app.dart';
import 'package:music_tagger/widgets/tag_button.dart';
import 'package:tag_repository/tag_repository.dart';
import '../../widgets/avatar.dart';
import '../../widgets/tag_box.dart';
import '../cubit/tag_cubit.dart';
import '../cubit/tag_names_cubit.dart';

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
      List<String> names = [];
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
                Avatar(photo: tag.track.image),
                const SizedBox(height: 4),
                Center(child : Text(tag.track.artistName)),
                const SizedBox(height: 4),
                Center(child : Text(tag.track.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)),
                const SizedBox(height: 4),
                Center(child : Text(tag.track.albumName)),
                const SizedBox(height: 15),
                Wrap(
                  direction: Axis.horizontal,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  children: [for (String tag in tag.tags) TagBox(tag: tag, size :18)],
                ),
                const SizedBox(height: 30),
                if(nameState is TagNamesLoaded)
                  Wrap(
                  direction: Axis.horizontal,
                  spacing: 20,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  children: [for (String name in nameState.names)
                    TagButton(tag: name, pressed: tag.tags.contains(name), function: ()=>_onTagSelected(nameContext,name, tag),)],
                 )
                 else _loadingIndicator()
              ],
            ));});
      }
      else{
        return _loadingIndicator();
      }

    });
  }

  void _onTagSelected(BuildContext context, String name, Tag tag){
    print(name);
    final List<String> copy = List.from(tag.tags);
    if(!tag.tags.contains(name)){
      copy.add(name);
    }
    else{
      copy.remove(name);
    }
    BlocProvider.of<TagCubit>(context).updateTags(Tag(tag.id,copy,tag.track));
  }

  Widget _loadingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

}