// lib/cubit/user_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/cubit/user_state.dart';
import 'package:my_app/model/userModel.dart';
import 'package:my_app/repository/userRepo.dart';
// import 'package:my_app/repository/user_repository.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository repository;
  UserCubit(this.repository) : super(UserInitial());

  Future<void> fetchUsers() async {
    emit(UserLoading());
    try {
      final users = await repository.getUsers();
      emit(UserLoaded(users));
    } catch (e) {
      emit(UserError("Erreur lors du chargement : $e"));
    }
  }

  Future<void> addUser(User user) async {
    try {
      await repository.addUser(user);
      await fetchUsers();
    } catch (e) {
      emit(UserError("Erreur lors de l'ajout : $e"));
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await repository.updateUser(user);
      await fetchUsers();
    } catch (e) {
      emit(UserError("Erreur lors de la mise à jour : $e"));
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      await repository.deleteUser(id);
      await fetchUsers();
    } catch (e) {
      emit(UserError("Erreur lors de la suppression : $e"));
    }
  }
}
