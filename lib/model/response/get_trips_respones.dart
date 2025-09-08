// To parse this JSON data, do
//
//     final getTripsRespones = getTripsResponesFromJson(jsonString);

import 'dart:convert';

List<GetTripsRespones> getTripsResponesFromJson(String str) => List<GetTripsRespones>.from(json.decode(str).map((x) => GetTripsRespones.fromJson(x)));

String getTripsResponesToJson(List<GetTripsRespones> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetTripsRespones {
    int idx;
    String name;
    String country;
    String coverimage;
    String detail;
    int price;
    int duration;
    String destinationZone;

    GetTripsRespones({
        required this.idx,
        required this.name,
        required this.country,
        required this.coverimage,
        required this.detail,
        required this.price,
        required this.duration,
        required this.destinationZone,
    });

    factory GetTripsRespones.fromJson(Map<String, dynamic> json) => GetTripsRespones(
        idx: json["idx"],
        name: json["name"],
        country: json["country"],
        coverimage: json["coverimage"],
        detail: json["detail"],
        price: json["price"],
        duration: json["duration"],
        destinationZone: json["destination_zone"],
    );

    Map<String, dynamic> toJson() => {
        "idx": idx,
        "name": name,
        "country": country,
        "coverimage": coverimage,
        "detail": detail,
        "price": price,
        "duration": duration,
        "destination_zone": destinationZone,
    };
}
