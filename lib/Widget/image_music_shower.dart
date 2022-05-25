import 'package:flutter/material.dart';
import 'custom_button_widge.dart';
class ImageMusicShow extends StatelessWidget {
  const ImageMusicShow({
    Key? key,
    required this.imageOfMusic,
    required this.size,
  }) : super(key: key);
  final Image? imageOfMusic;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "ImageTag",
      child: SizedBox(
        height: size,
        width: size,
        child: imageOfMusic == null
            ?  customButtonWidget(
          size: 150,
          borderwidth: 5,
          image:"assets/logo.jpg",
        )
            : ClipRRect(
          child: imageOfMusic,
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }
}