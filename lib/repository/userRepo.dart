// lib/repository/user_repository.dart
import 'package:my_app/model/userModel.dart';
// import 'package:my_app/data/user_api.dart';
import 'package:my_app/service/user_api.dart';

class UserRepository {
  Future<List<User>> getUsers() => UserApi.getUsers();
  Future<void> addUser(User user) => UserApi.addUser(user);
  Future<void> updateUser(User user) => UserApi.updateUser(user);
  Future<void> deleteUser(String id) => UserApi.deleteUser(id);
  // Future<void> search(String id) => UserApi.deleteUser(id);
}
