import 'dart:convert';

class AccountBM {
  final String name;
  final String image;
  final String payload;

  AccountBM({
    required this.name,
    required this.image,
    required this.payload,
  });

  factory AccountBM.fromJSON(dynamic json) {
    return AccountBM(name: json["name"], image: json["entityimage_url"] ?? "", payload: jsonEncode(json));
  }
}
