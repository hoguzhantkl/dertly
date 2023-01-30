class UserModel {
  UserModel({required this.userID, this.imageUrl = "", this.audioUrl = ""});

  final String userID;
  String imageUrl;
  String audioUrl;

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      userID: data['userID'],
      imageUrl: data['imageUrl'],
      audioUrl: data['audioUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
    };
  }
}