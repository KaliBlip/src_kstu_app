import 'dart:convert';

AnnouncementKeyMoments announcementKeyMomentsFromJson(String str) => AnnouncementKeyMoments.fromJson(json.decode(str));

String announcementKeyMomentsToJson(AnnouncementKeyMoments data) => json.encode(data.toJson());

class AnnouncementKeyMoments {
    int id;
    int announcementId;
    String imageSubTitle;
    String image;
    String imageDescription;
    DateTime createdAt;
    DateTime updatedAt;

    AnnouncementKeyMoments({
        required this.id,
        required this.announcementId,
        required this.imageSubTitle,
        required this.image,
        required this.imageDescription,
        required this.createdAt,
        required this.updatedAt,
    });

    factory AnnouncementKeyMoments.fromJson(Map<String, dynamic> json) => AnnouncementKeyMoments(
        id: json["id"],
        announcementId: json["announcement_id"],
        imageSubTitle: json["image_sub_title"] ?? '',
        image: json["image"] ?? '',
        imageDescription: json["image_description"] ?? '',
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "announcement_id": announcementId,
        "image_sub_title": imageSubTitle,
        "image": image,
        "image_description": imageDescription,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
