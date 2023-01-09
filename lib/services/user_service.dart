import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dertly/models/user_model.dart';

class UserService{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<bool> checkIfUserDocExists(String uid) async{
    try{
      var userCollectionRef = firestore.collection("users");
      var userDoc = await userCollectionRef.doc(uid).get();

      return userDoc.exists;
    } catch(e)
    {
      return false;
    }
  }

  Future<void> createUserData(UserModel userModel) async{
    try {
      var userCollectionRef = firestore.collection("users");
      await userCollectionRef.doc(userModel.userID).set(userModel.toJson());
    } catch (e) {
      e.toString();
    }
  }

  Future getUserData(String uid) async{
    var userCollectionRef = firestore.collection("users");
    var userDoc = await userCollectionRef.doc(uid).get();

    if (userDoc.exists){
      return userDoc.data();
    }
    else {
      return null;
    }
  }
}