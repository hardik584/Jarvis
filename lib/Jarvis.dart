// To parse this JSON data, do
//
//     final jarvis = jarvisFromJson(jsonString);

import 'dart:convert';

 

Jarvis jarvisFromJson(String str) => Jarvis.fromJson(json.decode(str));

String jarvisToJson(Jarvis data) => json.encode(data.toJson());

class Jarvis {
    int page;
    int perPage;
    int total;
    int totalPages;
    List<Datum> data;

    Jarvis({
        this.page,
        this.perPage,
        this.total,
        this.totalPages,
        this.data,
    });

    factory Jarvis.fromJson(Map<String, dynamic> json) => Jarvis(
        page: json["page"],
        perPage: json["per_page"],
        total: json["total"],
        totalPages: json["total_pages"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "page": page,
        "per_page": perPage,
        "total": total,
        "total_pages": totalPages,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    int id;
    String email;
    String firstName;
    String lastName;
    String avatar;

    Datum({
        this.id,
        this.email,
        this.firstName,
        this.lastName,
        this.avatar,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        avatar: json["avatar"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "avatar": avatar,
    };
    @override
  String toString() {
    
    return "$id $email";
  }
}
 