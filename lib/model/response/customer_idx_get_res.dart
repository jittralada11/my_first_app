// To parse this JSON data, do
//
//     final getCustomerRespones = getCustomerResponesFromJson(jsonString);

import 'dart:convert';

GetCustomerRespones getCustomerResponesFromJson(String str) => GetCustomerRespones.fromJson(json.decode(str));

String getCustomerResponesToJson(GetCustomerRespones data) => json.encode(data.toJson());

class GetCustomerRespones {
    int idx;
    String fullname;
    String phone;
    String email;
    String image;

    GetCustomerRespones({
        required this.idx,
        required this.fullname,
        required this.phone,
        required this.email,
        required this.image,
    });

    factory GetCustomerRespones.fromJson(Map<String, dynamic> json) => GetCustomerRespones(
        idx: json["idx"],
        fullname: json["fullname"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "idx": idx,
        "fullname": fullname,
        "phone": phone,
        "email": email,
        "image": image,
    };
}
