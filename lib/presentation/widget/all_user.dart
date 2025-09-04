// lib/presentation/widget/all_user.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/cubit/user_cubit.dart';
import 'package:my_app/cubit/user_state.dart';
import 'package:my_app/model/userModel.dart';
import 'package:my_app/service/edit_user_dialog.dart';
import 'package:my_app/service/delete_user_confirm.dart';

class AllUsers extends StatelessWidget {
  const AllUsers({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is UserError) {
          final isNetwork = state.message.contains("network") || state.message.contains("host");
          final msg = isNetwork ? "Problème de connexion internet 🚫" : state.message;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi_off, color: Colors.red, size: 48),
                const SizedBox(height: 10),
                Text(msg, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.red)),
                const SizedBox(height: 15),
                ElevatedButton.icon(
                  onPressed: () => context.read<UserCubit>().fetchUsers(),
                  icon: const Icon(Icons.refresh),
                  label: const Text("Réessayer"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                ),
              ],
            ),
          );
        }
        if (state is UserLoaded) {
          final users = state.users;
          if (users.isEmpty) {
            return const Center(child: Text("Aucun utilisateur trouvé"));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.green,
                    child: Text(
                      user.name.isNotEmpty
                          ? user.name.trim().split(" ").take(2).map((e) => e[0].toUpperCase()).join()
                          : "?",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                  subtitle: Text("Âge : ${user.age}", style: const TextStyle(fontSize: 16, color: Colors.black54)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Modifier
                      Container(
                        decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(2)),
                        child: IconButton(
                          icon: const Icon(Icons.edit_note, color: Colors.green, size: 24),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => EditUserDialog(
                                user: user,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Supprimer
                      Container(
                        decoration: BoxDecoration(color: Colors.red.withOpacity(0.1)),
                        child: IconButton(
                          icon: const Icon(Icons.delete_forever_rounded, color: Colors.red, size: 24),
                          onPressed: () async {
                            final confirmed = await confirmDeleteUser(context);
                            if (confirmed == true) {
                              // Appel Cubit
                              // ignore: use_build_context_synchronously
                              context.read<UserCubit>().deleteUser(user.id);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
