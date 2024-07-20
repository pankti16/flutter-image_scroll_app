import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_scroll_app/model/image_model.dart';

class ImageService {
  static const String baseUrl = 'https://picsum.photos/v2/list';

  Future<List<ImageModel>?> fetchImages(int page, int limit) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl?page=$page&limit=$limit'));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => ImageModel.fromJson(data)).toList();
      } else {
        Fluttertoast.showToast(msg: "Error fetching, error status code: ${response.statusCode}");
        return null;
      }
    } catch(e) {
      Fluttertoast.showToast(msg: "Error fetching images");
    }
  }
}