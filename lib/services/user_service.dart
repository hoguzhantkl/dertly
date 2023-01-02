import 'package:cloud_firestore/cloud_firestore.dart';

class UserService{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<SnapshotMetadata> getUserData() async{
    // TODO: Get user data from Firestore
    const userID = '123456789';
    return await firestore.collection('users').doc(userID).get().then((value) => value.metadata);
  }
}