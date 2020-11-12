class UserData {
  String id;
  String path;
  final String userId;
  final String name;
  final String email;

  UserData({this.userId, this.name, this.email}) : super();

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
      userId: json["userId"], name: json["name"], email: json["email"]);

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "name": name,
        "email": email,
      };
}
