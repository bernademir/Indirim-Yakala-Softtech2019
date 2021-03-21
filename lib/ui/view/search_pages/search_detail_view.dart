import 'dart:convert';
import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:indirimyakala/core/model/search_result.dart';
import 'package:share/share.dart';

class SearchDetailView extends StatefulWidget {
  final List<SearchResult> listSearching;

  const SearchDetailView({Key key, this.listSearching}) : super(key: key);
  @override
  _SearchDetailViewState createState() =>
      _SearchDetailViewState(listSearch: listSearching);
}

class _SearchDetailViewState extends State<SearchDetailView> {
  List<SearchResult> listSearch;

  _SearchDetailViewState({@required this.listSearch}) : super();

  List<NetworkImage> listNetworkImage2 = [];
  var base64String;
  @override
  Widget build(BuildContext context) {
    setState(() {
      for (var searchImage in listSearch) {
        NetworkImage networkImage2 = NetworkImage((searchImage).url);
        listNetworkImage2.add(networkImage2);
        for (var i = 0; i < listNetworkImage2.length; i++) {
          base64String = listNetworkImage2[i];
        }
      }
    });
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.teal[700],
        actions: <Widget>[
          IconButton(
              icon: new Icon(Icons.share, color: Colors.white),
              onPressed: () {
                final RenderBox box = context.findRenderObject();
                Share.share(base64String.url,
                    sharePositionOrigin:
                        box.localToGlobal(Offset.zero) & box.size);
              }),
        ],
      ),
      backgroundColor: Colors.grey.shade100,
      body: new Center(
        child: new Container(
          padding: const EdgeInsets.all(10.0),
          margin: EdgeInsets.all(10.0),
          height: 470,
          color: Colors.white,
          child: Carousel(
            onImageChange: (prevInt, nextInt) {
              (() async {
                http.Response response = (await HttpClient()
                    .getUrl(Uri.parse(base64String))) as http.Response;
                if (mounted) {
                  setState(() {
                    base64String = base64.encode(response.bodyBytes);
                  });
                }
              })();
            },
            boxFit: BoxFit.cover,
            images: listNetworkImage2,
            autoplay: false,
          ),
        ),
      ),
    );
  }
}
