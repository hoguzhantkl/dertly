class UserModel {
  UserModel({required this.userID, this.imageUrl = "", this.audioUrl = "",
            this.totalEntries = 0, this.totalAnswers = 0, this.totalFollowers = 0, this.totalFollowing = 0});

  String userID;
  String imageUrl;
  String audioUrl;

  int totalEntries;
  int totalAnswers;
  int totalFollowers;
  int totalFollowing;

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      userID: data['userID'],
      imageUrl: data['imageUrl'],
      audioUrl: data['audioUrl'],
      totalEntries: data['totalEntries'],
      totalAnswers: data['totalAnswers'],
      totalFollowers: data['totalFollowers'],
      totalFollowing: data['totalFollowing'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
      'totalEntries': totalEntries,
      'totalAnswers': totalAnswers,
      'totalFollowers': totalFollowers,
      'totalFollowing': totalFollowing,
    };
  }
}