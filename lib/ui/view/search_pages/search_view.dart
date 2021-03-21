import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:indirimyakala/core/model/search_result.dart';
import 'package:indirimyakala/ui/view/search_pages/search_detail_view.dart';

class SearchView extends StatefulWidget {
  final String searchText;

  const SearchView({Key key, this.searchText}) : super(key: key);
  @override
  _SearchViewState createState() => _SearchViewState(searchingText: searchText);
}

class _SearchViewState extends State<SearchView> {
  List<SearchResult> listSearch = [];
  var isLoading = false;
  var isCalledService = false;

  String searchingText;

  _SearchViewState({@required this.searchingText}) : super();

  Future<dynamic> dataFetch() async {
    setState(() {
      isLoading = true;
    });
    var body = jsonEncode({'productText': searchingText});
    Uri myUri = Uri.parse(
        "https://9dtypdb65d.execute-api.us-east-1.amazonaws.com/Prod/searchproduct");
    final response = await http.post(myUri,
        headers: {"Content-Type": "application/json"}, body: body);
    if (response.statusCode == 200) {
      setState(() {
        List jsonResponse = json.decode(response.body);
        listSearch =
            jsonResponse.map((m) => new SearchResult.fromJson(m)).toList();
        print(listSearch.length);
        isCalledService = true;
        isLoading = false;
      });
    } else {
      throw Exception("Failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isCalledService) dataFetch();

    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.teal[700],
      ),
      backgroundColor: Colors.grey.shade100,
      body: new Center(
        child: GridView.count(
          primary: false,
          padding: EdgeInsets.all(10.0),
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 5.0,
          crossAxisCount: 2,
          children: listSearch.map((brosur) {
            return GestureDetector(
              child: Card(
                color: Colors.white,
                child: new Container(
                  margin: EdgeInsets.all(10.0),
                  padding: EdgeInsets.all(5.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(brosur.url),
                    ),
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SearchDetailView(listSearching: listSearch)));
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
