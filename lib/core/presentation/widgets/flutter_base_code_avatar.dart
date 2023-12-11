import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_code/app/helpers/extensions/build_context_ext.dart';

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    required this.size,
    this.imageUrl,
    this.padding,
    super.key,
  });

  final String? imageUrl;
  final double size;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) => Semantics(
        image: true,
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: imageUrl != null
              ? CachedNetworkImage(
                  imageUrl: imageUrl!,
                  imageBuilder: (
                    BuildContext context,
                    ImageProvider<Object> imageProvider,
                  ) =>
                      Container(
                    decoration: BoxDecoration(
                      color: context.colorScheme.onBackground,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                      shape: BoxShape.circle,
                    ),
                    width: size,
                    height: size,
                  ),
                  errorWidget:
                      (BuildContext context, String url, dynamic error) =>
                          Icon(Icons.account_circle, size: size),
                  fit: BoxFit.cover,
                )
              : Icon(Icons.account_circle, size: size),
        ),
      );
}
