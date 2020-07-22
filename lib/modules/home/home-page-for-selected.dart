import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './model/share-model.dart';
import './home-page-for-favourites.dart';
import '../../widgets/swiper_pagination.dart';
import '../../common/common_functions.dart';

class HomePageForSelected extends StatefulWidget {
  final List<dynamic> selectedQuoteIds;
  HomePageForSelected({this.selectedQuoteIds});
  HomePageForSelectedState createState() =>
      HomePageForSelectedState(selectedQuoteIds: this.selectedQuoteIds);
}

class HomePageForSelectedState extends State<HomePageForSelected> {
  final List<dynamic> selectedQuoteIds;
  bool favourite;
  List<String> quoteIds = [];
  HomePageForSelectedState({this.selectedQuoteIds}){
    print(this.selectedQuoteIds);
  }
  SharedPreferences preferences;
  List<DocumentSnapshot> documentReference;
  final SwiperController _swiperController = SwiperController();
  int _pageCount;
  int _currentIndex = 0;
  ShareModel model;
  final List<Color> pageBgs = [
    Colors.blue.shade300,
    Colors.grey.shade600,
    Colors.cyan.shade300
  ];

  initializePreference() async{
    preferences=await SharedPreferences.getInstance();
  }
  void initState() {
    initializePreference();
    favourite = false;
    loadList();
    }

  void  loadList() async{
    List<DocumentSnapshot> list=[];
    selectedQuoteIds.forEach((val) => {
        Firestore.instance
        .collection("quotes")
        .document(val)
        .get()
        .then((docVal) {
          list.add(docVal);
          setState(() {
            this.documentReference=list;
          });
    })
  });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourites'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: (){
                print("clearing the list");
                setState(() {
                  preferences.clear();
                  documentReference.clear();
                });

            }
          )
        ],
      ),
      
      body:StreamBuilder(
                  stream: Stream.value(documentReference),
                  builder: (BuildContext context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                    if(snapshot.connectionState!=ConnectionState.done){
                      return Container();
                    }
                    if(snapshot.hasError){
                      return Text("There was an error");
                    }
                    if(snapshot.connectionState==ConnectionState.done || snapshot.connectionState==ConnectionState.active) {
                      List<DocumentSnapshot> documents = snapshot.data ?? [];
                      if (documents.length > 0) {
                        return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return _buildPage(
                                  title: CommonFunctions
                                      .getSubjectValueInCamelCase(
                                      snapshot.data[index]['description']),
                                  pageBg: snapshot.data[index]['imageUrl'],
                                  id: snapshot.data[index].documentID,
                              category:snapshot.data[index]['category']);
                            }

                        );
                      }
                      else
                        return Center(child: Text("No favourites as of now."));
                    }
                    })



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

  Widget _buildPage({String title, String pageBg,String id,String category}) {
    final TextStyle titleStyle = TextStyle(
        fontWeight: FontWeight.w500, fontSize: 20.0, color: Colors.white);
    return ListTile(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePageForFavourites(
                    selectedQuoteIds: id,
                )));

      },
      title: Text(
        title,
        style: TextStyle(color: Colors.black, fontSize: 16.0),
      ),
      subtitle: Text(
      '${category[0].toUpperCase()}${category.substring(1)}'
      ),
      leading: CircleAvatar(
          child: CachedNetworkImage(
              imageUrl: pageBg == ""
                  ? "https://firebasestorage.googleapis.com/v0/b/education-manner.appspot.com/o/sea.jpg?alt=media&token=028276a0-0855-4108-8b75-e89f88b5f42f"
                  : pageBg,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              fadeInDuration: Duration(seconds: 2),
              placeholder: (context, url) => SizedBox(
                  height: 10.0,
                  width: 10.0,
                  child: CircularProgressIndicator(strokeWidth: 1.0)),
              errorWidget: (context, url, error) =>
              new Icon(Icons.error))
      ),
    );
  }
}
