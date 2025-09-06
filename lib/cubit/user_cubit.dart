// lib/cubit/user_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/cubit/user_state.dart';
import 'package:my_app/model/userModel.dart';
import 'package:my_app/repository/userRepo.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository repository;

  UserCubit(this.repository) : super(UserInitial());

  /// 🔹 Charger tous les utilisateurs
  Future<void> fetchUsers() async {
    emit(UserLoading());
    try {
      final users = await repository.getUsers();
      emit(UserLoaded(users));
    } catch (e) {
      emit(UserError("Erreur lors du chargement : ${e.toString()}"));
    }
  }

  /// 🔹 Recherche parmi les utilisateurs déjà chargés
  void searchUsers(String query) {
    // On prend toujours la liste complète comme base
    List<User> allUsers = [];
    if (state is UserLoaded) {
      allUsers = (state as UserLoaded).users;
    } else if (state is UserSearch) {
      // Si déjà en mode recherche, on repart de la liste complète
      allUsers = (state as UserSearch).filteredUsers;
    }

    final filtered = allUsers.where(
      (u) => u.name.toLowerCase().contains(query.toLowerCase()),
    ).toList();

    emit(UserSearch(filtered));
  }

  /// 🔹 Ajouter un utilisateur
  Future<void> addUser(User user) async {
    try {
      await repository.addUser(user);
      await fetchUsers();
    } catch (e) {
      emit(UserError("Erreur lors de l'ajout : ${e.toString()}"));
    }
  }

  /// 🔹 Modifier un utilisateur
  Future<void> updateUser(User user) async {
    try {
      await repository.updateUser(user);
      await fetchUsers();
    } catch (e) {
      emit(UserError("Erreur lors de la mise à jour : ${e.toString()}"));
    }
  }

  /// 🔹 Supprimer un utilisateur
  Future<void> deleteUser(String id) async {
    try {
      await repository.deleteUser(id);
      await fetchUsers();
    } catch (e) {
      emit(UserError("Erreur lors de la suppression : ${e.toString()}"));
    }
  }
}
