import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:music_tagger/widgets/loading_indicator.dart';

class Avatar extends StatelessWidget {
  const Avatar({Key? key, this.photo}) : super(key: key);

  final String? photo;

  @override
  Widget build(BuildContext context) {
    final photo = this.photo;
    return photo != null?CachedNetworkImage(
      imageUrl: photo,
      imageBuilder: (context, imageProvider) => Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      placeholder: (context, url) => const LoadingIndicator(),
      errorWidget: (context, url, dynamic error) => const Icon(Icons.error),
    ):const LoadingIndicator();
  }
}