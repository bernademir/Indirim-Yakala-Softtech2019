import 'dart:convert';
import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:indirimyakala/core/model/brochure_model/brochure.dart';
import 'package:indirimyakala/core/model/brochure_model/brochure_image.dart';
import 'package:share/share.dart';

class BrochureDetailView extends StatefulWidget {
  final Brochure selectedBrochure;

  const BrochureDetailView({Key key, this.selectedBrochure}) : super(key: key);
  @override
  _BrochureDetailViewState createState() =>
      _BrochureDetailViewState(brochureObject: selectedBrochure);
}

class _BrochureDetailViewState extends State<BrochureDetailView> {
  Brochure brochureObject;
  _BrochureDetailViewState({@required this.brochureObject}) : super();

  List<NetworkImage> listNetworkImage = [];

  var base64String;
  @override
  Widget build(BuildContext context) {
    setState(() {
      for (var brochureImage in brochureObject.listBrochureImageUrl) {
        NetworkImage networkImage =
            NetworkImage((brochureImage as BrochureImage).url);
        listNetworkImage.add(networkImage);
        for (var i = 0; i < listNetworkImage.length; i++) {
          base64String = listNetworkImage[i];
        }
      }
    });
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.teal[700],
        title: Text(brochureObject.magazaAdi + "\n" + brochureObject.timeDesc),
        actions: <Widget>[
          IconButton(
            icon: new Icon(Icons.share, color: Colors.white),
            onPressed: () {
              final RenderBox box = context.findRenderObject();
              Share.share(base64String.url,
                  sharePositionOrigin:
                      box.localToGlobal(Offset.zero) & box.size);
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade100,
      body: new Center(
        child: new Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(10.0),
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
            images: listNetworkImage,
            autoplay: false,
          ),
        ),
      ),
    );
  }
}
