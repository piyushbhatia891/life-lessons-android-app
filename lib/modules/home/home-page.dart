import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share/share.dart';
import './model/share-model.dart';
import '../../widgets/swiper_pagination.dart';
import '../../widgets/assets.dart';

class HomePage extends StatefulWidget {
  final String title;
  HomePage({this.title});
  HomePageState createState() => HomePageState(title: this.title);
}

class HomePageState extends State<HomePage> {
  final String title;
  HomePageState({this.title});
  final SwiperController _swiperController = SwiperController();
  int _pageCount;
  int _currentIndex = 0;
  final List<ShareModel> titles = [
    ShareModel(
        name: 'first quote',
        description:
            "Lorem ipsum dolor \nsit amet, consectetur adipiscing \n elit placerat. ",
        imageUrl: 'assets/images/mountain-1.jpg'),
    ShareModel(
        name: 'second quote',
        description:
            "Aliquam eget justo \n nec arcu ultricies elementum \n id at metus. ",
        imageUrl: 'assets/images/nature-1.jpg'),
    ShareModel(
        name: 'third quote',
        description:
            "Nulla facilisi. \nFusce non tempus risus.\n Sed ultrices scelerisque sem",
        imageUrl: 'assets/images/sea.jpg'),
  ];
  final List<Color> pageBgs = [
    Colors.blue.shade300,
    Colors.grey.shade600,
    Colors.cyan.shade300
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          /*Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://images.unsplash.com/photo-1517030330234-94c4fb948ebc?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1275&q=80'),
                  fit: BoxFit.cover,
                ),
              )
          ),*/
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: StreamBuilder(
                      stream: Firestore.instance
                          .collection('quotes')
                          .where("category", isEqualTo: title)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: Text("Loading"));
                        }
                        if (snapshot.hasData) {
                          _pageCount=snapshot.data.documents.length;
                          return Swiper(
                            index: _currentIndex,
                            controller: _swiperController,
                            itemCount: snapshot.data.documents.length,
                            onIndexChanged: (index) {
                              setState(() {
                                _currentIndex = index;
                              });
                            },
                            loop: false,
                            itemBuilder: (context, index) {
                              return _buildPage(
                                  title: snapshot.data.documents[index]
                                      ['description'],
                                  pageBg: snapshot.data.documents[index]
                                      ['imageUrl']);
                            },
                            pagination: SwiperPagination(
                                builder: CustomPaginationBuilder(
                                    activeSize: Size(10.0, 20.0),
                                    size: Size(10.0, 15.0),
                                    color: Colors.grey.shade600)),
                          );
                        } else {
                          return Center(
                              child: Text(
                            "Coming soon",
                            style: TextStyle(color: Colors.black),
                          ));
                        }
                      })),
              _buildButtons()
            ],
          ),

          /*Positioned(
            child: AppBar(
              title: Text(title),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {},
                  tooltip: 'Share',
                ),
              ],
            ),
          )*/
        ],
      ),
    );
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
            textColor: Colors.grey.shade600,
            child: IconButton(
              icon: Icon(Icons.share),
              onPressed: () => share(context, titles[_currentIndex]),
            ),
            onPressed: (){}
          ),
          /*FlatButton(
              textColor: Colors.grey.shade600,
              child: IconButton(
                icon: Icon(_currentIndex < _pageCount - 1
                    ? Icons.arrow_forward_ios
                    : FontAwesomeIcons.check),
                onPressed: () async {
                  if (_currentIndex < _pageCount - 1) _swiperController.next();
                }
              ),
              onPressed:(){}
          ),*/

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
    /*return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              height: 200.0,
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.all(10.0),
              child: Center(
                child:
                Text(title, textAlign: TextAlign.center, style: titleStyle),
              ),
              decoration: BoxDecoration(
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(40.0),
                      topRight: const Radius.circular(40.0)),
                  image: DecorationImage(
                      image: NetworkImage(pageBg), fit: BoxFit.contain)),
            ),
          )
        ],
      ),
    )*/
    print(title);
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5.0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*0.3,
            child: InkWell(
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                //color: Colors.blue,
                elevation: 10.0,
                child: CachedNetworkImage(
                    imageUrl: pageBg,
                  fit: BoxFit.fill,
                  fadeInDuration: Duration(seconds: 3),
                    placeholder: (context, url) => SizedBox(
                        height: 10.0,
                        width: 10.0,
                        child:
                        CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.blue),
                            strokeWidth: 5.0)
                    ),
                    errorWidget: (context, url, error) => new Icon(Icons.error)
                ),
                /*child: Image.network(
                  pageBg,
                  fit: BoxFit.fill,
                ),*/
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
