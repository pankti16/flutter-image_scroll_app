import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_scroll_app/components/image_overlay.dart';
import 'package:image_scroll_app/model/image_model.dart';
import 'package:image_scroll_app/utils/common_utils.dart';

class ImageItem extends StatefulWidget {
  final ImageModel imageItem;

  const ImageItem({super.key, required this.imageItem});

  @override
  State<ImageItem> createState() => _ImageItemState();
}

class _ImageItemState extends State<ImageItem> {
  bool _isError = false;

  @override
  Widget build(BuildContext context) {

    return ImageOverlay(
      isError: _isError,
      childWidget: Container(
        key: ValueKey('Container${widget.imageItem.id}'),
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          key: ValueKey('Stack${widget.imageItem.id}'),
          children: [
            CachedNetworkImage(
              key: ValueKey('CachedNetworkImage${widget.imageItem.id}'),
              imageUrl: widget.imageItem.id == '3' ? widget.imageItem.url : getDisplayUrl(widget.imageItem.downloadUrl),
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Container(
                  key: ValueKey('AuthorContainer${widget.imageItem.id}'),
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 30.0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    child: Center(
                      child: Text(
                        widget.imageItem.author,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              placeholder: (context, url) => Center(
                key: ValueKey('PlaceholderWidget${widget.imageItem.id}'),
                child: const CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) {
                bool isNetIssue = error.toString().contains('SocketException');
                return Center(
                  key: ValueKey('ErrorWidget${widget.imageItem.id}'),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error,
                        size: 30.0,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        isNetIssue
                            ? 'Error due to network'
                            : 'Error loading image',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                );
              },
              errorListener: (error) {
                if (mounted) {
                  setState(() {
                    _isError = true;
                  });
                }
              },
            ),
          ],
        ),
      ),
      imageItem: widget.imageItem,
    );
  }
}
