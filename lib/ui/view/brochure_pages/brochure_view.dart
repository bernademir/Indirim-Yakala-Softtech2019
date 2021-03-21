import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:indirimyakala/core/model/brochure_model/brochure.dart';
import 'package:indirimyakala/core/model/store.dart';
import 'package:http/http.dart' as http;
import 'package:indirimyakala/ui/view/brochure_pages/brochure_detail_view.dart';
import 'package:indirimyakala/ui/view/search_pages/search_view.dart';

class BrochureView extends StatefulWidget {
  final Store selectedStore;

  const BrochureView({Key key, this.selectedStore}) : super(key: key);
  @override
  _BrochureViewState createState() =>
      _BrochureViewState(storeObject: selectedStore);
}

class _BrochureViewState extends State<BrochureView> {
  List<Brochure> listBrochure = [];
  var isLoading = false;
  var isCalledService = false;

  Widget appBarTitle = new Text(
    "Ürün Ara",
    style: new TextStyle(color: Colors.white),
  );

  Icon icon = new Icon(
    Icons.search,
    color: Colors.white,
  );

  final globalkey = new GlobalKey<ScaffoldState>();
  final TextEditingController controller = new TextEditingController();

  String searchText2 = "";
  bool isSearching2;
  List searchResult2 = [];
  List<dynamic> list2;

  Store storeObject;

  _BrochureViewState({@required this.storeObject}) : super() {
    controller.addListener(() {
      if (controller.text.isEmpty) {
        setState(() {
          isSearching2 = false;
          searchText2 = "";
        });
      } else {
        setState(() {
          isSearching2 = true;
          searchText2 = controller.text;
        });
      }
    });
  }

  Future<dynamic> fetchData() async {
    Uri myUri = Uri.parse(
        "https://9dtypdb65d.execute-api.us-east-1.amazonaws.com/Prod/brochure/" +
            storeObject.name);

    setState(() {
      isLoading = true;
    });
    final response = await http.get(myUri, headers: {
      "Content-Type": "application/json;charset=utf-8",
      'Accept': 'application/json;charset=utf-8'
    });
    if (response.statusCode == 200) {
      setState(() {
        List responseJson = json.decode(utf8.decode(response.bodyBytes));
        listBrochure =
            responseJson.map((m) => new Brochure.fromJson(m)).toList();
        print(listBrochure.length);
        isCalledService = true;
        isLoading = false;
      });
    } else {
      throw Exception("Failed");
    }
  }

  @override
  void initState() {
    super.initState();
    isSearching2 = false;
    Store();
  }

  @override
  Widget build(BuildContext context) {
    if (!isCalledService) fetchData();

    return Scaffold(
      key: globalkey,
      appBar: buildAppBar(context),
      backgroundColor: Colors.grey.shade100,
      body: new Center(
        child: GridView.count(
          primary: false,
          padding: EdgeInsets.all(10.0),
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 5.0,
          crossAxisCount: 2,
          children: listBrochure.map((brochure) {
            return GestureDetector(
                child: Card(
                  color: Colors.white,
                  child: Container(
                    margin: EdgeInsets.all(0),
                    padding: EdgeInsets.all(0),
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(brochure.backgorundImgUrl),
                      ),
                    ),
                    child: new Container(
                      margin: EdgeInsets.only(
                          top: 100.0, bottom: 0, left: 0, right: 0),
                      height: 60,
                      decoration: new BoxDecoration(
                        color: Colors.black.withOpacity(0.9),
                        border: new Border.all(color: Colors.black),
                      ),
                      child: new Text(
                        brochure.desc,
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              BrochureDetailView(selectedBrochure: brochure)));
                });
          }).toList(),
        ),
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(
      backgroundColor: Colors.teal[700],
      title: appBarTitle,
      actions: <Widget>[
        new IconButton(
          alignment: Alignment.centerLeft,
          icon: icon,
          onPressed: () {
            setState(() {
              if (this.icon.icon == Icons.search) {
                this.icon = new Icon(
                  Icons.close,
                  color: Colors.white,
                );
                this.appBarTitle = new TextField(
                  controller: controller,
                  onSubmitted: (value) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SearchView(searchText: value)));
                  },
                  style: new TextStyle(
                    color: Colors.white,
                  ),
                  decoration: new InputDecoration(
                    hintText: "Ara",
                    hintStyle: new TextStyle(color: Colors.white),
                  ),
                  onChanged: searchOperation,
                );
                TextFormField(textInputAction: TextInputAction.done);
                _handleSearchStart();
              } else {
                _handleSearchEnd();
              }
            });
          },
        ),
        IconButton(
          icon: new Icon(Icons.add_alert, color: Colors.white),
          onPressed: () {
            warning(context);
          },
        ),
      ],
    );
  }

  void _handleSearchStart() {
    setState(() {
      isSearching2 = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.icon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        "Ürün Ara",
        style: new TextStyle(color: Colors.white),
      );
      isSearching2 = false;
      controller.clear();
    });
  }

  void searchOperation(String searchText) {
    searchResult2.clear();
    if (isSearching2 != null) {
      for (int i = 0; i < list2.length; i++) {
        String data = list2[i];
        if (data.toLowerCase().contains(searchText.toLowerCase())) {
          searchResult2.add(data);
        }
      }
    }
  }

  void warning(context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Uyarı"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                      "Bu marketi takip ederseniz marketin yeni broşurü yayınlandığında size bildirim gelir."),
                  Text("Takip etmek istediğinize emin misiniz?"),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(primary: Colors.white),
                child: Text(
                  "Evet",
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () {},
              ),
              TextButton(
                  style: TextButton.styleFrom(primary: Colors.white),
                  child: Text(
                    "Hayır",
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }
}
