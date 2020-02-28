import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';

import './Utility.dart';

class OpenImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var image64String = ModalRoute.of(context).settings.arguments as String;
    return Container(
        child: PhotoView(
      imageProvider: MemoryImage(
        Utility.dataFromBase64String(image64String),
      ),
      minScale: PhotoViewComputedScale.contained * 0.8,
      maxScale: PhotoViewComputedScale.covered * 1.8,
      initialScale: PhotoViewComputedScale.contained,
    ));
  }
}
