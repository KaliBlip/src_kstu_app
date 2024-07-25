
import 'dart:convert';

LandmarkModel landmarkModelFromJson(String str) => LandmarkModel.fromJson(json.decode(str));

String landmarkModelToJson(LandmarkModel data) => json.encode(data.toJson());

class LandmarkModel {
    int id;
    String name;
    int status;
    String landmark_id;
    String created_at;
    String updatedAt;

    LandmarkModel({
        required this.id,
        required this.name,
        required this.status,
        required this.landmark_id,
        required this.created_at,
        required this.updatedAt,
    });

    factory LandmarkModel.fromJson(Map<dynamic, dynamic> json) => LandmarkModel(
        id: json["id"],
        name: json["name"],
        status: json["status"],
        landmark_id: json["landmark_id"],
        created_at:json["created_at"] ?? '',
        updatedAt: json["updated_at"],
    );

    Map<dynamic, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
        "campus_id": landmark_id,
        "created_at": created_at,
        "updated_at": updatedAt,
    };
}