import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_scroll_app/components/image_item.dart';
import 'package:image_scroll_app/model/image_model.dart';
import 'package:image_scroll_app/state/connectivity_provider.dart';
import 'package:image_scroll_app/state/pic_image_provider.dart';
import 'package:image_scroll_app/utils/common_utils.dart';
import 'package:provider/provider.dart';

class InfiniteScrollGridView extends StatefulWidget {
  const InfiniteScrollGridView({super.key});

  @override
  InfiniteScrollGridViewState createState() => InfiniteScrollGridViewState();
}

class InfiniteScrollGridViewState extends State<InfiniteScrollGridView> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      _loadMoreImages(false);
    });
    _scrollController.addListener(() {
      bool isFetching =
          Provider.of<PicImageProvider>(context, listen: false).isFetching;
      //If API call is not going on and we are at bottom of the list, then make api call
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !isFetching) {
        //Check if API was called too frequent or not
        if (_debounce?.isActive ?? false) _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: 300), () {
          _loadMoreImages(false);
        });
      }
    });
  }

  //Method to handle pull to refresh
  Future<void> _pullRefresh() async {
    bool isAvail = await checkInternet(context);
    if (!isAvail) {
      return;
    }
    _loadMoreImages(true);
  }

  //Method to trigger api to fetch more images
  Future<void> _loadMoreImages(bool isRefresh) async {
    setState(() {
      _isLoading = true;
    });
    bool isAvail = await checkInternet(context);
    if (!isAvail) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (mounted) {
      Provider.of<PicImageProvider>(context, listen: false)
        .fetchImages(refresh: isRefresh);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isFetching = Provider.of<PicImageProvider>(context).isFetching;
    int currentPage = Provider.of<PicImageProvider>(context).currentPage;
    int limit = Provider.of<PicImageProvider>(context).limit;
    bool isConnected = Provider.of<ConnectivityProvider>(context).getConnection;
    List<ImageModel> picImages = Provider.of<PicImageProvider>(context).images;

    return Scaffold(
        body: ClipRect(
          child: Overlay(
            initialEntries: <OverlayEntry>[
              OverlayEntry(
                builder: (BuildContext context) {
                  return RefreshIndicator(
                    onRefresh: _pullRefresh,
                    child: CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.0,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (index <
                                  Provider.of<PicImageProvider>(context)
                                      .images
                                      .length) {
                                return ImageItem(
                                  imageItem:
                                      Provider.of<PicImageProvider>(context)
                                          .images[index],
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                            childCount: Provider.of<PicImageProvider>(context)
                                .images
                                .length,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: (_isLoading || Provider.of<PicImageProvider>(context).isFetching)
                              ? const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        //Show retry button when no-internet condition
        floatingActionButton: !_isLoading &&
                !isFetching &&
                (!isConnected || (isConnected && picImages.isEmpty))
            ? FloatingActionButton(
                onPressed: () async {
                  if (currentPage * limit == picImages.length) {
                    await checkInternet(context);
                  } else {
                    _loadMoreImages(false);
                  }
                },
                child: const Icon(Icons.refresh_rounded),
              )
            : null);
  }
}
