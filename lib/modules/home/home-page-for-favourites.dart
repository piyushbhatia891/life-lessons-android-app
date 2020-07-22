import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './model/share-model.dart';
import './home-page.dart';
import '../../widgets/swiper_pagination.dart';
import '../../common/common_functions.dart';

class HomePageForFavourites extends StatefulWidget {
  final String selectedQuoteIds;
  HomePageForFavourites({this.selectedQuoteIds});
  HomePageForFavouritesState createState() =>
      HomePageForFavouritesState(selectedQuoteIds: this.selectedQuoteIds);
}

class HomePageForFavouritesState extends State<HomePageForFavourites> {
  final String selectedQuoteIds;
  bool favourite;
  List<String> quoteIds = [];
  HomePageForFavouritesState({this.selectedQuoteIds}) {
    print(this.selectedQuoteIds);
  }
  SharedPreferences preferences;
  DocumentSnapshot documentReference;
  final SwiperController _swiperController = SwiperController();
  int _pageCount;
  int _currentIndex = 0;
  ShareModel model;
  final List<Color> pageBgs = [
    Colors.blue.shade300,
    Colors.grey.shade600,
    Colors.cyan.shade300
  ];

  initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  void initState() {
    initializePreference();
    favourite = false;
    loadList();
  }

  void loadList() async {
    Firestore.instance
        .collection("quotes")
        .document(selectedQuoteIds)
        .get()
        .then((docVal) {
      setState(() {
        documentReference = docVal;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Favourites'),
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream: Stream.value(documentReference),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Container();
              }
              if (snapshot.hasError) {
                return Text("There was an error");
              }
              if (snapshot.connectionState == ConnectionState.done ||
                  snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return _buildPage(
                      title: CommonFunctions.getSubjectValueInCamelCase(
                          snapshot.data['description']),
                      pageBg: snapshot.data['imageUrl']);
                } else
                  return Center(child: Text("Loading The Favourite Item"));
              }
            }));
  }

  Widget _buildButtons() {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
            textColor: Colors.grey.shade600,
            child: Text("Back"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: IconButton(
                icon: favourite
                    ? Icon(Icons.favorite)
                    : Icon(Icons.favorite_border),
                onPressed: () {
                  setState(() {
                    favourite = !favourite;
                    if (favourite) {
                      !quoteIds.contains(model.id)
                          ? quoteIds.add(model.id)
                          : "";
                    } else
                      quoteIds.contains(model.id)
                          ? quoteIds.remove(model.id)
                          : "";
                    if (preferences.get('favourites'))
                      preferences.setStringList('favourites', quoteIds);
                    else
                      preferences.setStringList('favourites', quoteIds);
                  });
                }),
            onPressed: null,
          ),
          FlatButton(
              textColor: Colors.grey.shade600,
              child: IconButton(
                icon: Icon(Icons.share),
                onPressed: () => share(context, model),
              ),
              onPressed: () {}),
        ],
      ),
    );
  }

  share(BuildContext context, ShareModel shareModel) {
    final RenderBox box = context.findRenderObject();

    Share.share("${shareModel.name} - ${shareModel.description}",
        subject: shareModel.description,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  Widget _buildPage({String title, String pageBg}) {
    final TextStyle titleStyle = TextStyle(
        fontWeight: FontWeight.w500, fontSize: 20.0, color: Colors.white);
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5.0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.3,
            child: InkWell(
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                elevation: 10.0,
                child: CachedNetworkImage(
                    imageUrl: pageBg == ""
                        ? "https://firebasestorage.googleapis.com/v0/b/education-manner.appspot.com/o/sea.jpg?alt=media&token=028276a0-0855-4108-8b75-e89f88b5f42f"
                        : pageBg,
                    imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                    fadeInDuration: Duration(seconds: 3),
                    placeholder: (context, url) => SizedBox(
                        height: 10.0,
                        width: 10.0,
                        child: CircularProgressIndicator(strokeWidth: 1.0)),
                    errorWidget: (context, url, error) =>
                        new Icon(Icons.error)),
              ),
            ),
          ),
          SizedBox(height: 2.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(color: Colors.black, fontSize: 20.0),
            ),
          )
        ]);
  }
}
