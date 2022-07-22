import 'package:flutter/material.dart';
import 'package:gif_finder/page/GifSearchPageNew.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:http/http.dart';

import '../helpFunctions/menu_navigator.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage>{

  @override

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Awesome Gif finder"),

      ),

      drawer: Drawer(
          child: menu_navigator()
      ),

      body:Column(

          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                "Welcome to GIF search App",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 30,
                )).centered(),
            FlatButton(
              color: Colors.black,
                shape: RoundedRectangleBorder(side: BorderSide(
                    color: Colors.blue,
                    width: 1,
                    style: BorderStyle.solid
                ), borderRadius: BorderRadius.circular(5)),
                onPressed: () {    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>GifSearchPage2())); },
                child: Text("SearchGiffs",
                style: TextStyle(fontSize: 20))).py20(),
            Text("made by Arvīds Dambenieks",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10,
                ) ).centered()
          ]
      ),
    );


  }

}

Widget appbar