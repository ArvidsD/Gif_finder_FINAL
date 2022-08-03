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

  Timer searchTimerStop = Timer(Duration(milliseconds: 500), () {});
  final TextEditingController controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Gifs> gifs = []; //will save loaded gifs list
  bool loading = false;
  bool all_loaded = false;
  String? searchValue;
  int gifoffset = 0;
  int totalgifs = 0;

  //function for scrolling up
  void ScrollUp() {
    _scrollController.animateTo(
      0.0,
      duration: Duration(seconds: 1),
      curve: Curves.easeIn,
    );
  }
  //Timer from https://stackoverflow.com/questions/53146151/is-there-a-way-to-send-a-request-after-the-user-has-stopped-typing#comment117324213_56734097 and modified
  //for my needs
  textchangeHandler(text) {
    const duration = Duration(milliseconds: 500);
    if (searchTimerStop != null) {
      setState(() => searchTimerStop.cancel());
    }
    //on new search restarts List, and next API call will be with searched value
    gifs = [];
    gifoffset = 0;
    searchValue = text;

    setState(() => searchTimerStop = new Timer(duration, () => search(text)));
  }

  search(text) {
    //calls gif loading on new searched text values
    gifLoader();
  }


  //influence from https://www.youtube.com/watch?v=EXJboDdIpEA&t=109s&ab_channel=RetroPortalStudio
  gifLoader() async {


    setState(() {
      loading = true;
    });

    //await Future.delayed(Duration(milliseconds: 500));

    http.Response res;
    List<Gifs> newgifs;
//API calls for results - 1 for trending and other for searched results
    if (searchValue == null || searchValue == "") {
      res = await http.get(Uri.parse(
          "https://api.giphy.com/v1/gifs/trending?api_key=hCgxcz5sh58BrJTkMGLkBFNtenDnayWL&limit=10&rating=g&offset=$gifoffset"));
    } else {
      res = await http.get(Uri.parse(
          "http://api.giphy.com/v1/gifs/search?api_key=hCgxcz5sh58BrJTkMGLkBFNtenDnayWL&limit=10&offset=$gifoffset&rating=pg&lang=&q=$searchValue"));
    }
    final result = GifDataFromJson(res.body);
    newgifs = result.data;
    totalgifs = result.pagination.totalCount;
    if (newgifs.isNotEmpty) {
      gifs.addAll(newgifs);
    }
    setState(() {
      //sets state that it is loading no longer, and clears new gif list, so it would be empty next time
      loading = false;
      all_loaded = newgifs.isEmpty;
    });
  }
//state which calls when need to load gifs (on page opening, and on scrolling
  @override
  void initState() {
    super.initState();
    gifLoader();
    //loads more gifs, when scrolled to bottom.
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent &&
          !loading) {
        //changes offset value, so on API request there would be other gifs
        gifoffset = gifoffset + 10;
        gifLoader();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search for GIF'),
      ),
      drawer: menu_navigator(),
      //button so can navigate from bottom to top
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.arrow_upward),
        onPressed: ScrollUp,
      ),
      body: Column(children: <Widget>[
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
        Expanded(child: LayoutBuilder(builder: (context, constraints) {
          if (gifs.isNotEmpty) {
            return GridView.builder(
              controller: _scrollController,
              gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),

              itemBuilder: (context, index) {
                //if index reaches total gif count, then in last tile will be message
                if (index == totalgifs) {
                  return Container(
                      child: Center(
                        child: Text("No more gifs to load :("),
                      ));
                }
                final gif = gifs[index];

                return Stack(
                  children: <Widget>[
                    const Center(child: CircularProgressIndicator()),
                    Center(
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: gif.images.original.url,
                        height: 200.0,
                        width: 200.0,
                        fit: BoxFit.cover,
                      ).p4(),
                    )
                  ],
                );
              },
              //item count will be as long as gifs.length, but if all gifs are loaded, then it will update value with 1 more)
              itemCount: gifs.length + (all_loaded ? 1 : 0),
            ).p2();
          } else {
            //if still loading or nothing is found, there will be loading indicator. Place for improvement - if still loading - then indicator, if not - message that nothibg
            //was found
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        }))
      ]),
    );
  }
}
