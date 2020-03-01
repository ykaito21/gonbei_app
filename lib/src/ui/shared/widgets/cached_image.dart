import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../global/extensions.dart';

class CachedImage extends StatelessWidget {
  final imageUrl;

  const CachedImage({
    Key key,
    @required this.imageUrl,
  })  : assert(imageUrl != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => Icon(
        Icons.error,
        color: context.accentColor,
      ),
    );
  }
}
