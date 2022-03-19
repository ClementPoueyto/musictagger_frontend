import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final Function function;

  const CustomAppBar({
     Key? key,
    required this.title,
    required this.function,
}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Home'),
      actions: <Widget>[
        IconButton(
          key: const Key('homePage_logout_iconButton'),
          icon: const Icon(Icons.exit_to_app),
          onPressed: (){function();},
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
