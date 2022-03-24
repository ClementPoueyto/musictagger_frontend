import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_tagger/app/app.dart';
import 'package:music_tagger/router/routes.gr.dart';
import '../../home/widgets/custom_app_bar.dart';

class Tags extends StatelessWidget {
  Tags({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: CustomAppBar(title:"Tags", function: () async => {
        AutoRouter.of(context).replace(LoginRouter())
        ,
        context.read<AppBloc>().add(AppLogoutRequested())}),
      body: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 4),
            Text("text", style: textTheme.headline6),
            const SizedBox(height: 4),
            Text("test", style: textTheme.headline5),
          ],
        ),
      ),
    );
  }
}
