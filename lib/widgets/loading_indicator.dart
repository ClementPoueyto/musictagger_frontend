import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return  Padding(
      padding: const EdgeInsets.all(8),
      child: Center(child: CircularProgressIndicator(
        color: theme.primaryColor,
      )),
    );
  }
}
