import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_tagger/app/app.dart';
import 'package:music_tagger/router/routes.gr.dart';
import 'package:music_tagger/tags/cubit/tags_cubit.dart';
import 'package:music_tagger/widgets/widgets.dart';

class TagsScreen extends StatelessWidget {
  TagsScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: CustomAppBar(title:"Generation", function: () async => {
        AutoRouter.of(context).replace(LoginRouter())
        ,
        context.read<AuthBloc>().add(AuthLogoutRequested())}),
      body: Column(children: [
        BlocBuilder<TagsCubit, TagsState>(
          builder: (context, state) {
            if(state is TagsLoading){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if(state is TagsLoaded){
              return Text('Something went good.');

            }
            else{
              return Text('Something went wrong.');
            }
          },
        )
      ],),


    );
  }
}
