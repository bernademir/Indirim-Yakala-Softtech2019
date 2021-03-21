import 'brochure_image.dart';

class Brochure {
  final List listBrochureImageUrl;
  final String timeDesc;
  final String brochureUrl;
  final String backgorundImgUrl;
  final String createdAt;
  final String magazaAdi;
  final String id;
  final String title;
  final String desc;

  Brochure({
    this.timeDesc,
    this.listBrochureImageUrl,
    this.brochureUrl,
    this.backgorundImgUrl,
    this.createdAt,
    this.magazaAdi,
    this.id,
    this.title,
    this.desc,
  });

  factory Brochure.fromJson(Map<String, dynamic> json) {
    return new Brochure(
        listBrochureImageUrl: json['listBrochureImageUrl']
            .map((m) => new BrochureImage.fromJson(m))
            .toList(),
        timeDesc: json['timeDesc'].toString(),
        brochureUrl: json['brochureUrl'].toString(),
        backgorundImgUrl: json['backgorundImgUrl'].toString(),
        createdAt: json['createdAt'].toString(),
        magazaAdi: json['magazaAdi'].toString(),
        id: json['id'].toString(),
        title: json['title'].toString(),
        desc: json['desc'].toString());
  }
}
