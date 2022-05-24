import 'package:app_music_bkav/const.dart';
import 'package:flutter/material.dart';

class customButtonWidget extends StatelessWidget {
  final double borderwidth;
  final double size;
  final String? image;
  final bool isActive;
  final VoidCallback onTap;
  final Widget? child;

  customButtonWidget(
      {this.child,
      required this.size,
      required this.onTap,
      this.borderwidth = 2,
      this.image,
      this.isActive = false});
  @override
  Widget build(BuildContext context) {
    var boxdecoration = BoxDecoration(
      borderRadius: BorderRadius.all(
        Radius.circular(200),
      ),
      border: Border.all(
        width: borderwidth,
        color: isActive ? AppColors.darkBlue : AppColors.mainColor,
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.lightBlueShadow,
          blurRadius: 10,
          offset: Offset(5, 5),
          spreadRadius: 3,
        ),
        BoxShadow(
          color: Colors.white54,
          blurRadius: 5,
          offset: Offset(5, 5),
          spreadRadius: 3,
        )
      ],
    );
    if (image != null) {
      boxdecoration = boxdecoration.copyWith(
          image: DecorationImage(
              image: ExactAssetImage(image!), fit: BoxFit.cover));
    }
    if (isActive) {
      boxdecoration = boxdecoration.copyWith(
          gradient: RadialGradient(colors: [
        AppColors.lightBlue,
        AppColors.darkBlue,
      ]));
    } else {
      boxdecoration = boxdecoration.copyWith(
          gradient: RadialGradient(colors: [
        AppColors.mainColor,
        AppColors.mainColor,
        AppColors.mainColor,
        Colors.white
      ]));
    }
    return Container(
      width: size,
      height: size,
      decoration: boxdecoration,
      child: FlatButton(
          padding: EdgeInsets.all(0),
          onPressed: onTap,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
            Radius.circular(200),
          )),
          child: child ?? Container()),
    );
  }
}
