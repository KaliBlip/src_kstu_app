
import 'dart:convert';

Announcement announcementFromJson(String str) => Announcement.fromJson(json.decode(str));

String announcementToJson(Announcement data) => json.encode(data.toJson());

class Announcement {
    int id;
    String featuredImage;
    String featuredImageMin;
    String title;
    int status;
    int views;
    int adminId;
    int categoryId;
    String createdAt;

    String createdAtFormatted;
    String updatedAt;

    int likesCount;
    
    String likesCountFormatted;
    String viewsCountFormatted;
    bool likedByAuthUser;
    List<dynamic> likedUsers;

    Announcement({
        required this.id,
        required this.featuredImage,
        required this.featuredImageMin,
        required this.title,
        required this.status,
        required this.views,
        required this.adminId,
        required this.categoryId,
        required this.createdAt,
        required this.createdAtFormatted,
        required this.updatedAt,
        required this.likesCount,
        required this.likesCountFormatted,
        required this.viewsCountFormatted,
        required this.likedByAuthUser,
        required this.likedUsers,
    });

    factory Announcement.fromJson(Map<dynamic, dynamic> json) => Announcement(
        id: json["id"],
        featuredImage: json["featured_image"],
        featuredImageMin: json["featured_image_min"],
        title: json["title"],
        status: json["status"],
        views: json["views"],
        adminId: json["admin_id"],
        categoryId: json["category_id"],
        createdAt:json["created_at"] ?? '',
        createdAtFormatted:json["created_at_formatted"] ?? '',
        
        updatedAt: json["updated_at"],
        likesCount: json["likes_count"],
        likesCountFormatted: json["likes_count_formatted"],
        viewsCountFormatted: json["views_count_formatted"],
        likedByAuthUser: json["liked_by_auth_user"],
        likedUsers: List<dynamic>.from(json["liked_users"].map((x) => x)),
    );

    Map<dynamic, dynamic> toJson() => {
        "id": id,
        "featured_image": featuredImage,
        "featured_image_min": featuredImageMin,
        "title": title,
        "status": status,
        "views": views,
        "admin_id": adminId,
        "category_id": categoryId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "likes_count": likesCount,
        "likes_count_formatted": likesCountFormatted,
        "views_count_formatted": viewsCountFormatted,
        "liked_by_auth_user": likedByAuthUser,
        "liked_users": List<dynamic>.from(likedUsers.map((x) => x)),
    };
}