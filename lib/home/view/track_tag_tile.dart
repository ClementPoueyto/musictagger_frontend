import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:music_tagger/utils/constants.dart';
import 'package:music_tagger/widgets/widgets.dart';
import 'package:tag_repository/tag_repository.dart';

class TrackTagTile extends StatelessWidget {
  Tag tag;
  int index;

  TrackTagTile({Key? key, required this.tag,required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        AutoRouter.of(context).pushNamed(tag.id.toString());
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: size>MOBILE_SIZE ? 4 : 10,
              child: Row(
                children: [
                  if (size>MOBILE_SIZE)
                     Padding(padding: const EdgeInsets.only(right: 3.0),
                     child :Text(
                        '${index + 1}',
                        style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),),
                    
                  Expanded(
                      flex: 5,
                      child: CachedNetworkImage(
                        imageUrl: tag.track.image!,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                            const LoadingIndicator(),
                        errorWidget: (context, url, dynamic error) =>
                            const Icon(Icons.error),
                      )),
                  const SizedBox(width: 10,),
                  Expanded(
                    flex: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tag.track.name,
                          overflow: TextOverflow.ellipsis,
                          style:  TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: size>MOBILE_SIZE?14:12
                          ),

                        ),
                        const SizedBox(height: 10),
                        Text(
                          tag.track.artistName,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (size>MOBILE_SIZE)
              Expanded(
                flex: 2,
                child: Text(tag.track.albumName),
              ),
            Expanded(
                flex: 10,
                child:
                tag.tags.isNotEmpty ? TagsList(tags: tag.tags) : const SizedBox.shrink()),
            const Expanded(flex: 1, child: Center(child: Icon(Icons.chevron_right))),
          ],
        ),
      ),
    );
  }
}