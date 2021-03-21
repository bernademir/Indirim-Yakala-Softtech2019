class BrochureImage {
  final String url;
  final String products;

  BrochureImage({this.url, this.products});

  factory BrochureImage.fromJson(Map<String, dynamic> json) {
    return new BrochureImage(
        url: json['url'].toString(), products: json['products'].toString());
  }
}
