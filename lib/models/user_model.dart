class UserModel {
  final String userID;
  final String userName; // TODO: change this later to a Sound

  UserModel({required this.userID, required this.userName});

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      userID: data['userID'],
      userName: data['userName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'userName': userName,
    };
  }
}