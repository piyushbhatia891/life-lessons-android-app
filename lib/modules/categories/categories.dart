import 'package:flutter/material.dart';
import '../home/home-page.dart';

class Categories extends StatefulWidget {
  CategoriesPageState createState() => CategoriesPageState();
}

class CategoriesPageState extends State<Categories> {
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Text('Life Lessons',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0
                              )),
                        ),

                      ],
                    )),
                decoration: BoxDecoration(color: Colors.blue.shade300),
              ),
              ListTile(
                leading: Icon(Icons.category),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                  size: 14.0,
                ),
                title: Center(
                  child: Text('Rate us'),
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
        body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                    expandedHeight: 150.0,
                    floating: false,
                    pinned: true,
                    backgroundColor: Colors.blue,
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
                        icon: Icon(
                          Icons.settings
                        ),
                        onPressed: (){
                          
                        },
                      )
                    ],
                )
              ];
            },
            body: Container(
              color: Colors.white,
              child: ListView(
                children: <Widget>[
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: cardContainer('Respect elders', 'assets/images/respect.jpg',
                              "respect"),
                        ),
                        Expanded(
                          child: cardContainer(
                              'Manners', 'assets/images/life_manners.jpg', "manners")
                        )

                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: cardContainer('Road Walking',
                              'assets/images/road_manners.jpg', "road"),
                        ),
                        Expanded(
                          child: cardContainer(
                              'Lessons for Life', 'assets/images/life_lessons.jpg', "lessons"),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                    child:     cardContainer('Motivating',
                        'assets/images/motivation.jpg', "motivation"),
                    )

                      ],
                    ),
                  )
                ],
              ),
            )
        ),
        /*body: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    cardContainer('Respect elders', 'assets/images/respect.jpg',
                        "respect"),
                    cardContainer(
                        'Manners', 'assets/images/life_manners.jpg', "manners")
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    cardContainer('Road Walking',
                        'assets/images/road_manners.jpg', "road"),
                    cardContainer(
                        'Manners', 'assets/images/life_manners.jpg', "manners")
                  ],
                ),
              )
            ],
          ),
        )*/
    );
  }

  Column cardContainer(String title, String imageUrl, String category) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10.0),
          height: 150.0,
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(title: category)));
            },
            child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              //color: Colors.blue,
              elevation: 10.0,
              child: Image.asset(
                imageUrl,
                fit: BoxFit.fill,
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
