import 'package:flutter/material.dart';
import 'package:gif_finder/page/GifSearchPageNew.dart';
import 'package:gif_finder/page/mainPage.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:velocity_x/velocity_x.dart';
import 'helpFunctions/menu_navigator.dart';
import 'package:http/http.dart';

/***********************************************************************
 *
 * List pagination - included
 * Live search - included
 * Results Displayer - in grid
 * Simple UI
 *
 * included dark and light theme
 *
 *
 *
 *

 */

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      //https://www.youtube.com/watch?v=VUCRmHgrs0g&ab_channel=LearnFlutterwithMe - theme settings
      //removes debug banner
      debugShowCheckedModeBanner: false,
      //sets theme - dark or light mode depending on system
        theme: ThemeData(
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark
        ),

        themeMode: ThemeMode.system,
        title: "Gif finder",
        home: HomePage(),


    );
  }
}


