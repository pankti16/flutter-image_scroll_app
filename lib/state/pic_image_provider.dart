import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_scroll_app/constants/common_constants.dart';
import 'package:image_scroll_app/model/image_model.dart';
import 'package:image_scroll_app/service/image_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PicImageProvider with ChangeNotifier {
  final ImageService _imageService = ImageService();

  List<ImageModel> _images = [];
  bool _isFetching = false;
  bool _hasMore = true;
  int _currentPage = 1;
  final int _limit = 10;

  List<ImageModel> get images => _images;
  bool get isFetching => _isFetching;
  bool get hasMore => _hasMore;
  int get currentPage => _currentPage;
  int get limit => _limit;

  PicImageProvider() {
    _loadFromPrefs();
  }

  _loadFromPrefs() async {
    _isFetching = true;
    notifyListeners();

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? images = sharedPreferences.getString(kImageListKey) ?? '';
    _currentPage = sharedPreferences.getInt(kCurrentImagePage) ?? 1;

    if (images.isNotEmpty) {
      final imagesParse = json.decode(images);

      _images = imagesParse
          .map<ImageModel>(
              (json) => ImageModel.fromJSON(json))
          .toList();
    }
    _isFetching = false;
    notifyListeners();
  }

  _saveToPrefs(List<ImageModel> images, int page) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List imagesJson = images.map((image) => image.toJSON()).toList();
    await sharedPreferences.setString(kImageListKey, json.encode(imagesJson));
    await sharedPreferences.setInt(kCurrentImagePage, page);
  }

  Future<void> fetchImages({bool refresh = false}) async {
    if (_isFetching) return;
    _isFetching = true;
    notifyListeners();

    if (refresh) {
      _images = _images.sublist(0,11);
      _currentPage = 1;
      _hasMore = true;
    }

    try {
      List<ImageModel>? newImages = await _imageService.fetchImages(_currentPage, _limit);
      if (newImages == null || newImages.isEmpty) {
        _hasMore = false;
      } else {
        if (refresh) {
          _images = newImages;
        } else {
          _images.addAll(newImages);
        }

        _currentPage++;
        _saveToPrefs(_images, _currentPage);
      }
    } catch (e) {
      _hasMore = false;
    }

    _isFetching = false;
    notifyListeners();
  }
}