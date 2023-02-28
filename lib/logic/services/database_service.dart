import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zem_auth/logic/models/auth_detail_model.dart';
import 'package:zem_auth/logic/models/user_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  addUserData(UserModel userData) async {
    await _db.collection("Users").doc(userData.uid).set(userData.toMap());
  }
   
  addGoogleUserData(AuthenticationDetailModel userData) async {
    await _db.collection("Users").doc(userData.uid).set(userData.toMap());
  }
  Future<List<UserModel>> retrieveUserData() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("Users").get();
    return snapshot.docs
        .map((docSnapshot) => UserModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<bool?> retrieveUser(UserModel user) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("Users").doc(user.uid).get();
    if (snapshot.data() != null) {
      return snapshot.data()!['isVerified'];
    }
    return null;
  }

  // Future<DocumentSnapshot<Map<String, dynamic>>> getCurrentUserData(UserDetailModel user) async {
  //   var userData = await _db.collection("Users").doc(user.uid).get();

  //   return userData;
    
 // }
}
