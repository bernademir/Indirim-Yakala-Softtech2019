import 'package:flutter/material.dart';
import 'package:indirimyakala/core/model/store.dart';
import 'package:indirimyakala/ui/view/search_pages/search_view.dart';

import 'brochure_pages/brochure_view.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Widget appBarTitle = new Text(
    "Ürün Ara",
    style: new TextStyle(color: Colors.white),
  );

  Icon icon = new Icon(
    Icons.search,
    color: Colors.white,
  );

  final globalKey = new GlobalKey<ScaffoldState>();
  final TextEditingController controller = new TextEditingController();

  String searchText = "";
  bool isSearching;
  List searchResult = [];
  List<dynamic> list;

  _HomeViewState() {
    controller.addListener(() {
      if (controller.text.isEmpty) {
        setState(() {
          isSearching = false;
          searchText = "";
        });
      } else {
        setState(() {
          isSearching = true;
          searchText = controller.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    isSearching = false;
    Store();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: buildAppBar(context),
      backgroundColor: Colors.grey.shade100,
      body: new Center(
        child: GridView.count(
          primary: false,
          padding: EdgeInsets.all(10.0),
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 5.0,
          crossAxisCount: 2,
          children: listStore.map((storeObject) {
            return GestureDetector(
                child: Card(
                  color: Colors.white,
                  child: new Container(
                    margin: EdgeInsets.all(10.0),
                    padding: EdgeInsets.all(5.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(storeObject.url),
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              BrochureView(selectedStore: storeObject)));
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
      ],
    );
  }

  void _handleSearchStart() {
    setState(() {
      isSearching = true;
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
      isSearching = false;
      controller.clear();
    });
  }

  void searchOperation(String searchText) {
    searchResult.clear();
    if (isSearching != null) {
      for (int i = 0; i < list.length; i++) {
        String data = list[i];
        if (data.toLowerCase().contains(searchText.toLowerCase())) {
          searchResult.add(data);
        }
      }
    }
  }
}
