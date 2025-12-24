import 'package:flutter/material.dart';
import 'package:movigo/data/services/constant/api_constants.dart';

class ImageHelper {
  static ImageProvider getImage(String? posterPath, String posterSize) {
    if (posterPath != null && posterPath.isNotEmpty) {
      return NetworkImage(
        '${ApiConstants.imageBaseUrl}/$posterSize$posterPath',
      );
    } else {
      return const AssetImage('assets/img/no-image.jpg');
    }
  }
}
