 // lib/presentation/widget/all_user.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/cubit/user_cubit.dart';
import 'package:my_app/cubit/user_state.dart';
import 'package:my_app/service/edit_user_dialog.dart';
import 'package:my_app/service/delete_user_confirm.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({super.key});

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is UserError) {
          final isNetwork =
              state.message.contains("network") || state.message.contains("host");
          final msg =
              isNetwork ? "Problème de connexion internet 🚫" : state.message;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi_off, color: Colors.red, size: 48),
                const SizedBox(height: 10),
                Text(
                  msg,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton.icon(
                  onPressed: () => context.read<UserCubit>().fetchUsers(),
                  icon: const Icon(Icons.refresh),
                  label: const Text("Réessayer"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }

        if (state is UserLoaded) {
          final users = state.users.where((user) {
            final name = user.name.toLowerCase();
            final age = user.age.toString();
            final code = user.code.toLowerCase();
            return name.contains(_searchQuery) ||
                age.contains(_searchQuery) ||
                code.contains(_searchQuery);
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: "Rechercher un utilisateur...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase().trim();
                    });
                  },
                ),
              ),
               Expanded(
                child: users.isEmpty
                    ? const Center(child: Text("Aucun utilisateur trouvé"))
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                        itemCount: users.length,
                        separatorBuilder: (context, index) => const Divider(
                          color: Color.fromARGB(255, 234, 234, 234),  // ligne grise
                          thickness: 0.8,
                          indent: 12, // marge à gauche
                          endIndent: 12, // marge à droite
                        ),
                        itemBuilder: (context, index) {
                          final user = users[index];

                          ImageProvider? imageProvider;
                          if (user.photoUrl.isNotEmpty) {
                            if (user.photoUrl.startsWith("http")) {
                              imageProvider = NetworkImage(user.photoUrl);
                            } else {
                              imageProvider = FileImage(File(user.photoUrl));
                            }
                          }

                          return ListTile(
                            dense: true,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            leading: CircleAvatar(
                              radius: 26,
                              backgroundColor: Colors.grey.shade300,
                              backgroundImage: imageProvider,
                              child: imageProvider == null
                                  ? Text(
                                      user.name.isNotEmpty
                                          ? user.name
                                              .trim()
                                              .split(" ")
                                              .take(2)
                                              .map((e) => e[0].toUpperCase())
                                              .join()
                                          : "?",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    )
                                  : null,
                            ),
                            title: Text(
                              user.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Âge : ${user.age}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                                Text(
                                  "Code : ${user.code}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit_note,
                                    color: Colors.green,
                                    size: 24,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => EditUserDialog(user: user),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_forever_rounded,
                                    color: Colors.red,
                                    size: 24,
                                  ),
                                  onPressed: () async {
                                    final confirmed = await confirmDeleteUser(context);
                                    if (confirmed == true) {
                                      context.read<UserCubit>().deleteUser(user.id);
                                    }
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              )

            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
