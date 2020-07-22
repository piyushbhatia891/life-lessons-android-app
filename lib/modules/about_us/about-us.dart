import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'This app is created with an intention to educate our young and growing up generation'
                    ' to learn life living quotes with basic ettiquettes and manners which will eventually help them'
                    ' to grow in their life.',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    maxLines: 10,
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
