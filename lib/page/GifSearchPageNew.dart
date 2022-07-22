import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:gif_finder/helpFunctions/menu_navigator.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:transparent_image/transparent_image.dart';

import '../helpFunctions/gifData.dart';

class GifSearchPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //sets theme - dark or light mode depending on system
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      title: "Gif finder 3000",
      home: NewGifSearchPage(),
    );
  }
}

class NewGifSearchPage extends StatefulWidget {
  @override
  _NewGifSearchPageState createState() => _NewGifSearchPageState();
}

class _NewGifSearchPageState extends State<NewGifSearchPage> {



  var _streamController = StreamController<List<Gifs>>();
  var _scrollController = ScrollController();
  final TextEditingController controller = TextEditingController();

  //Timer from https://stackoverflow.com/questions/53146151/is-there-a-way-to-send-a-request-after-the-user-has-stopped-typing#comment117324213_56734097
  Timer searchTimerStop = Timer(Duration(milliseconds: 500), () {});
  String? searchValue;
  int gifoffset = 0;




  textchangeHandler(text) {
    const duration = Duration(milliseconds: 500);
    if (searchTimerStop != null) {
      setState(() => searchTimerStop.cancel());
    }
    //on new search restarts List, and next API call will be with searched value
    gifs=[];
    gifoffset = 0;
    searchValue = text;
    setState(
            () => searchTimerStop = new Timer(duration, () => search(text)));
  }

  search(text) {
  }

  List<Gifs> gifs = [];

  /************Getting information from API*******************/
  Future<List<Gifs>> _gifgGtter(List<Gifs> gifs2) async {

    http.Response res;


    if (searchValue == null || searchValue == "") {
      res = await http.get(Uri.parse(
          "https://api.giphy.com/v1/gifs/trending?api_key=hCgxcz5sh58BrJTkMGLkBFNtenDnayWL&limit=10&rating=g&offset=$gifoffset"));
    } else {
      res = await http.get(Uri.parse(
          "http://api.giphy.com/v1/gifs/search?api_key=hCgxcz5sh58BrJTkMGLkBFNtenDnayWL&limit=10&offset=$gifoffset&rating=pg&lang=&q=$searchValue"));
    }
    final result = GifDataFromJson(res.body);
    //add newly found values to List
    gifs= result.data;

    //adds new list items to current list
    var newList = [...gifs2, ...gifs].toSet().toList();
    gifs = newList;






    return gifs;
  }
/*********************************************/


  /*****************Widget to generate Gifs to grid *********************/
  Widget gifTableCreator(BuildContext context, AsyncSnapshot snapshot) {


    return GridView.builder(
        controller: _scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2
        ),
        itemCount: gifs.length,

        itemBuilder: (context, index) {
          final gif = gifs[index];

            return FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: gif.images.original.url,
              height: 200.0,
              width: 200.0,
              fit: BoxFit.cover,).p4();
          }

    ).p2();
  }
//List pagination inspired from https://stackoverflow.com/questions/54171020/flutter-futurebuilder-append-items-to-the-list

  loadMoreGifs(bool increment) {
    setState(() {
      //sets offset - if new search - API call offset will be back to 0
      if (!increment)
        gifoffset = 0;


      else
    //if not new search, adds more items to list
        gifoffset += 10;

    });
  }

  loadGifs(bool refresh) {
    if (refresh) {


      loadMoreGifs(!refresh);

    };
    // refresh whole List
  }

  @override
  void initState() {
    super.initState();
    loadGifs(false);
    //listener, which checks if user have scrolled to the bottom of the list, if it is on bottom, then more gifs will be loaded

    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels == 0)

          print('List scroll at top');
        else {

          print('List scroll at bottom');

          loadMoreGifs(true);

        }
      }
    });
  }


  var _listCursorEnd= 10;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _streamController.stream,
      builder: (BuildContext context, AsyncSnapshot<List<Gifs>> snapshot) {

        if (snapshot.hasData) {

          // This ensures that the cursor won't exceed List<Album> length
          if (_listCursorEnd > snapshot.data!.length)
            _listCursorEnd = snapshot.data!.length;
        }
        return Scaffold(
          appBar: AppBar(
            title: Text('Search for GIF'),
          ),
          drawer: menu_navigator(),
          body: Column(
              children: <Widget>[
                TextField(

                    controller: controller,
                    //for live search need to call handler, which will provoke searching
                    onChanged: textchangeHandler,
                    onSubmitted: (text) {
                      setState(() {
                        searchValue = text;
                      });
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                        labelText: "search GIFs's here",
                        suffixIcon: IconButton(
                          onPressed: () {
                            controller.clear();
                          },
                          icon: Icon(Icons.clear),
                        ))).p8(),
                Expanded(


                  child: FutureBuilder(

                    future: _gifgGtter(gifs),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        //if page is still loading or other issues, then there will be shown loading indicator
                        case ConnectionState.none:
                        case ConnectionState.waiting:

                          return Container(
                            width: 200.0,
                            height: 200.0,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                            ),

                          );

                        default:
                          if (snapshot.hasError)
                            return Container();
                          else{
                            //if after search, there is nothing found, user will get message
                              if(gifs.length==0){
                                return Text("Nothing was found");
                              }
                            return gifTableCreator(context, snapshot);
                          }
                            //if everything is good, new items will be added to grid

                      }
                    },

                  ),
                )
              ]
          ),
        );
      },
    );

  }
}
