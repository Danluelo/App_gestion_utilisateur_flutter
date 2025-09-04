// import 'package:my_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/model/userModel.dart';


Future addUser(User user) async {
  final docUser = FirebaseFirestore.instance.collection('users').doc();
  user.id = docUser.id;
  await docUser.set(user.toJson());
}


// //-------------------------------------------------------------//
// Future updateUser(User user) async{
//   final docUser = FirebaseFirestore.instance.collection('users').doc(user.id);
//   await docUser.update(user.toJson());
// }

// //-------------------------------------------------------------//
// Future deleteUser(String id) async{
//   final docUser = FirebaseFirestore.instance.collection('users').doc(id);
//   await docUser.delete();
// }