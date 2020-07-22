import 'package:flutter/material.dart';
import '../home/home-page.dart';
import '../home/home-page-for-selected.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'dart:async';
import '../../common/NetworkCheck.dart';
import '../about_us/about-us.dart';
import '../test/test.dart';
import '../../shared/widgets/rowWidgets.dart';
import '../../shared/models/categories.dart';

class Categories extends StatefulWidget {
  CategoriesPageState createState() => CategoriesPageState();
}

class CategoriesPageState extends State<Categories> {
  StreamSubscription _connectionChangeStream;
  SharedPreferences preferences;
  bool isOffline = false;
  BannerAd bannerAd;
  List<CategoriesModel> categoriesList1=[new CategoriesModel(title:'Respect elders',
      imageUrl:'assets/images/respect.jpg', category:"respect",level: ''),new CategoriesModel(title:'Manners',
      imageUrl:'assets/images/life_manners.jpg', category:"manners",level: '')];
  List<CategoriesModel> categoriesList2=[new CategoriesModel(title:'Lessons for Life',
  imageUrl:'assets/images/life_lessons.jpg', category:"lessons",level: ''),new CategoriesModel(title:'Road Walking',
  imageUrl:'assets/images/road_manners.jpg', category:"road",level: '')];
  List<CategoriesModel> categoriesList3=[new CategoriesModel(title:'Motivating',
      imageUrl:'assets/images/motivation.jpg', category:"motivation",level: '')];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  getPreferencesInstance() async {
    preferences = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: "ca-app-pub-6604466631381658~5087830442").then((response){
      // myBanner..load()..show();
    });
    getPreferencesInstance();
    ConnectionStatusSingleton connectionStatus =
    ConnectionStatusSingleton.getInstance();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);
  }

  void dispose(){
    super.dispose();
    /*myBanner?.dispose();
    myInterstitial.dispose();*/
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
      print("connection changed to " + isOffline.toString());
      if (isOffline) {
        _scaffoldKey.currentState.showSnackBar(new SnackBar(
            backgroundColor: Colors.red,
            content: new Text("Internet not connected")));
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 100.0,
                  floating: false,
                  pinned: true,
                  backgroundColor: Colors.green,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    centerTitle: true,
                    title: Text("Categories List",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        )),
                  ),
                  actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.favorite),
                        onPressed: () {
                          if (preferences.get('favourites') != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePageForSelected(
                                        selectedQuoteIds:
                                        preferences.get('favourites'))));
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Favourites List"),
                                  content: Text("Your Favourites List is empty."),
                                  actions: [
                                    FlatButton(
                                      child: Text("OK"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        })
                  ],
                )
              ];
            },
            body: Container(
              color: Colors.white,
              child: ListView(
                children: <Widget>[
                  RowWidget(model: categoriesList1),
                  RowWidget(model: categoriesList2),
                  RowWidget(model: categoriesList3)
                ],
              ),
            )));
  }

  Column cardContainer(String title, String imageUrl, String category) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10.0),
          height: 150.0,
          child: InkWell(
            onTap: () {
              //myInterstitial..load()..show();
              if(category=="quiz")
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TestPage()));
              else
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(title: category)));
            },
            child: imageUrl!=""? Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              //color: Colors.blue,
              elevation: 10.0,
              child: Image.asset(
                imageUrl,
                fit: BoxFit.fill,
              ),
            ):
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)
              ),
              elevation: 10.0,
              child: Container(
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.green,
                  )
              ),
            ),
          ),
        ),
        SizedBox(height: 2.0),
        Text(
          title,
          style: TextStyle(color: Colors.black, fontSize: 20.0),
        )
      ],
    );
  }
}

MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  keywords: <String>['quotes', 'motivating'],
  childDirected: true,
  testDevices: <String>[], // Android emulators are considered test devices
);
/*

BannerAd myBanner = BannerAd(
  // Replace the testAdUnitId with an ad unit id from the AdMob dash.
  // https://developers.google.com/admob/android/test-ads
  // https://developers.google.com/admob/ios/test-ads
  adUnitId: "ca-app-pub-6604466631381658/4896258759",
  size: AdSize.smartBanner,
  targetingInfo: targetingInfo,
  listener: (MobileAdEvent event) {
    print("BannerAd event is $event");
  },
);

InterstitialAd myInterstitial = InterstitialAd(
  // Replace the testAdUnitId with an ad unit id from the AdMob dash.
  // https://developers.google.com/admob/android/test-ads
  // https://developers.google.com/admob/ios/test-ads
  adUnitId: "ca-app-pub-6604466631381658/9490109887",
  targetingInfo: targetingInfo,
  listener: (MobileAdEvent event) {
    print("InterstitialAd event is $event");
  },
);*/
