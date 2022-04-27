import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';

class TagsList extends StatelessWidget {
  List<String> tags;

  TagsList({Key? key, required this.tags,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tags(
      key: key,
      itemCount:tags.length,
      itemBuilder: (index) {
        final item = tags[index];

        return ItemTags(
          key: Key(index.toString()),
          index: index,
          title: item,
          pressEnabled: false,
          textStyle: const TextStyle(
            fontSize: kIsWeb ? 16 : 11,
          ),
        );
      },
    );
    ;
  }
}