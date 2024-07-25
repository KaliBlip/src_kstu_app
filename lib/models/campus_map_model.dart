
import 'dart:convert';

CampusMapModel campusMapModelFromJson(String str) => CampusMapModel.fromJson(json.decode(str));

String campusMapModelToJson(CampusMapModel data) => json.encode(data.toJson());

class CampusMapModel {
    int id;
    String image;
    String name;
    String latitude;
    String longitude;
    int status;
    int campus_id;
    String created_at;
    String updatedAt;
    String campus;

    CampusMapModel({
        required this.id,
        required this.image,
        required this.name,
        required this.status,
        required this.campus_id,
        required this.campus,
        required this.latitude,
        required this.longitude,
        required this.created_at,
        required this.updatedAt,
    });

    factory CampusMapModel.fromJson(Map<dynamic, dynamic> json) => CampusMapModel(
        id: json["id"],
        image: json["img"],
        name: json["name"],
        status: json["status"],
        campus_id: json["campus_id"],
        campus: json["campus"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        created_at:json["created_at"] ?? '',
        updatedAt: json["updated_at"],
    );

    Map<dynamic, dynamic> toJson() => {
        "id": id,
        "img": image,
        "name": name,
        "status": status,
        "campus_id": campus_id,
        "campus": campus,
        "created_at": created_at,
        "updated_at": updatedAt,
        "latitude": latitude,
        "longitude": longitude,
    };
}