import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_tagger/widgets/widgets.dart';

import '../../home/cubit/tags_cubit.dart';

class TagsScreen extends StatelessWidget {
  TagsScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: const CustomAppBar(title:"Generation",),
      body: Column(children: [
        BlocBuilder<TagsCubit, TagsState>(
          builder: (context, state) {
            if(state is TagsLoading){
              return const Center(
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
