class UserModel {
  UserModel({
    required this.id,
    required this.userName,
    required this.phone,
    required this.email,
    required this.about,
    required this.profilePic,
  });
  late String id;
  late String userName;
  late String phone;
  late String email;
  late String about;
  late String profilePic;

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    userName = json['userName'] ?? '';
    phone = json['phone'] ?? '';
    email = json['email'] ?? '';
    about = json['about'] ?? '';
    profilePic = json['profilePic'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['userName'] = userName;
    data['phone'] = phone;
    data['email'] = email;
    data['about'] = about;
    data['profilePic'] = profilePic;
    return data;
  }
}