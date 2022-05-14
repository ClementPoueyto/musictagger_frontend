import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;

  const CustomAppBar({
     Key? key,
    required this.title,
}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.colorScheme.primary ,
      title:  Text(title),
      automaticallyImplyLeading: false,

    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
