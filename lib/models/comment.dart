
class UserComment{
  String? comment;
  String? name;
  String? profile_url;
  String? datePosted;
  String? userId;
  int likes;
  
  UserComment({required this.comment, this.name, this.profile_url, this.datePosted, required this.userId, required this.likes});
}