class SearchResult {
  final String url;
  final String products;
  final String storeName;
  final String desc;
  final String timeDesc;
  final String title;

  SearchResult(
      {this.url,
      this.products,
      this.storeName,
      this.desc,
      this.timeDesc,
      this.title});

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return new SearchResult(
      url: json['url'].toString(),
      products: json['products'].toString(),
      storeName: json['storeName'].toString(),
      desc: json['desc'].toString(),
      timeDesc: json['timeDesc'].toString(),
      title: json['title'].toString(),
    );
  }
}
