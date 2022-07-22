import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../main.dart';

import '../page/GifSearchPageNew.dart';
/******************************************************************/
//Navigator inspired from https://www.youtube.com/watch?v=ts9n211n8ZU&ab_channel=JohannesMilke
class menu_navigator extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return Drawer(


      child: Material(

        //color: ,
        child: ListView(
          children: <Widget>[
Text("Menu", style: TextStyle(fontSize: 40),).px20().py20(),
            menu_item(
              item_text:'Home',
              item_icon: Icons.home,
              onClicked: ()=> clicked_item(context,0),
            ),
            menu_item(
              item_text:'Search Gifs',
              item_icon: Icons.search,
              onClicked: ()=> clicked_item(context,1),
            )
          ],
        ).py32(),
      ),
    );
  }
  Widget menu_item({
    required String item_text,
    required IconData item_icon,
    VoidCallback? onClicked,
  }){
    return ListTile(
      leading: Icon(item_icon),
      title: Text(item_text,
      style: TextStyle(fontSize: 20),),
      onTap: onClicked,
    );

  }
  void clicked_item(BuildContext context, int index){
    Navigator.of(context).pop();
    switch(index){
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context)=> MyApp(),
        )
        );
        break;

      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context)=> GifSearchPage2(),
        ));
        break;
    }
  }
}


/***************************************************/