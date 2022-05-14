import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:music_tagger/utils/constants.dart';

class TagsList extends StatelessWidget {
  List<String> tags;
  TagsList({Key? key, required this.tags,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    return Tags(
      key: key,
      itemCount:tags.length,
      itemBuilder: (index) {
        final item = tags[index];

        return ItemTags(
          key: Key(index.toString()),
          index: index,
          title: item,
          elevation: 0,
          border: const Border.fromBorderSide(BorderSide.none),
          activeColor: theme.colorScheme.secondary,
          pressEnabled: false,
          textStyle:  TextStyle(
            fontSize: ((size >MOBILE_SIZE) ? 16 : 11),
          ),
        );
      },
    );
    ;
  }
}