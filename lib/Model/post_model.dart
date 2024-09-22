class ItemPostModel {
  ItemPostModel({
  required this.uid,
    required this.image,
  required this.description,
  required this.exchange,
  required this.location,
    required this.userName,
    required this.profilePic,
  });
  late String uid;
  late String image;
  late String description;
  late String exchange;
  late String location;
  late String userName;
  late String profilePic;

  ItemPostModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'] ?? '';
    image = json['image'] ?? '';
    description = json['description'] ?? '';
    exchange = json['exchange'] ?? '';
    location = json['location'] ?? '';
    userName = json['userName'] ?? '';
    profilePic = json['profilePic'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['uid'] = uid;
    data['image'] = image;
    data['description'] = description;
    data['exchange'] = exchange;
    data['location'] = location;
    data['userName'] = userName;
    data['profilePic'] = profilePic;
    return data;
  }
}