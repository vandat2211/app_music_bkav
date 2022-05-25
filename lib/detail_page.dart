import 'package:app_music_bkav/resource/Color_manager.dart';
import 'package:app_music_bkav/Widget/custom_button_widge.dart';
import 'package:app_music_bkav/custom_progress_widget.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Column(
        children: <Widget>[
          SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
              customButtonWidget(
                size: 50,
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.styleColor,
                ),
              ),
              Text(
                "PLAYING NOW",
                style: TextStyle(
                    color: AppColors.styleColor, fontWeight: FontWeight.bold),
              ),
              customButtonWidget(
                size: 50,
                onTap: () {

                },
                child: Icon(
                  Icons.menu,
                  color: AppColors.styleColor,
                ),
              )
            ]),
          ),
          customButtonWidget(
            image: "assets/logo.jpg",
            size: MediaQuery.of(context).size.width* .7,
            borderwidth: 5,
            onTap: (){
            },
          ),
          Text("Name song",style: TextStyle(
            color: AppColors.styleColor,fontSize: 32,fontWeight: FontWeight.bold,height: 2
          ),),
          Text("Singer",style: TextStyle(
            color: AppColors.styleColor.withAlpha(90),fontSize: 20,
          ),),
          SizedBox(height: 50),


          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                customButtonWidget(
                  size: 60,
                  onTap: () {

                  },
                  child: Icon(
                    Icons.fast_rewind,
                    color: AppColors.styleColor,
                  ),
                  borderwidth: 5,
                ),
                customButtonWidget(
                  size: 70,
                  onTap: () {

                  },
                  child: Icon(
                    Icons.pause,
                    color: Colors.white,

                  ),
                  isActive: true,
                  borderwidth: 5,
                ),
                customButtonWidget(
                  size: 60,
                  onTap: () {

                  },
                  child: Icon(
                    Icons.fast_forward,
                    color: AppColors.styleColor,
                  ),
                  borderwidth: 5,
                ),
              ],
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
