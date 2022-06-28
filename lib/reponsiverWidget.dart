import 'package:flutter/material.dart';
class ReponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget tab;
  const ReponsiveWidget({Key? key, required this.mobile, required this.tab, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,constraints){
      if(constraints.maxWidth<600){
        return mobile;
      }else {
        return tab;
      }
    });
  }
}
