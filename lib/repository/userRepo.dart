// // import 'package:my_app/models/user.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:my_app/model/userModel.dart';

// lib/repository/user_repository.dart
import 'package:my_app/model/userModel.dart';
import 'package:my_app/service/user_api.dart';

class UserRepository {
  Future<List<User>> getUsers() => UserApi.getUsers();
  Future<void> addUser(User user) => UserApi.addUser(user);
  Future<void> updateUser(User user) => UserApi.updateUser(user);
  Future<void> deleteUser(String id) => UserApi.deleteUser(id);
}

// Future addUser(User user) async {
//   final docUser = FirebaseFirestore.instance.collection('users').doc();
//   user.id = docUser.id;
//   await docUser.set(user.toJson());
// }


// // //-------------------------------------------------------------//
// // Future updateUser(User user) async{
// //   final docUser = FirebaseFirestore.instance.collection('users').doc(user.id);
// //   await docUser.update(user.toJson());
// // }

// // //-------------------------------------------------------------//
// // Future deleteUser(String id) async{
// //   final docUser = FirebaseFirestore.instance.collection('users').doc(id);
// //   await docUser.delete();
// // }