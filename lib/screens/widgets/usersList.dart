// import 'package:flutter/material.dart';
// import 'package:my_app/model/userModel.dart';
// // import 'package:my_app/repository/userRepo.dart';

// class Listusers extends StatefulWidget {
//   final List<User> users;

//   const Listusers({super.key, required this.users});

//   @override
//   _ListusersState createState() => _ListusersState();
// }

// class _ListusersState extends State<Listusers> {
//   late List<User> allusers;

//   @override
//   void initState() {
//     super.initState();
//     allusers = widget.users;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: allusers.length,
//       itemBuilder: (context, index) {
//         final user = allusers[index];
//         final ctrName = TextEditingController(text: user.name);
//         final ctrAge = TextEditingController(text: user.age.toString());

//         return Card(
//           child: ListTile(
//             leading: CircleAvatar(
//               backgroundColor: Colors.blue,
//               child: Text(
//                 () {
//                   String initials = "?";
//                   final name = user.name;
//                   if (name.isNotEmpty) {
//                     initials = name.length >= 2
//                         ? name.substring(0, 2).toUpperCase()
//                         : name[0].toUpperCase();
//                   }
//                   return initials;
//                 }(),
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             title: Text(user.name),
//             subtitle: Text("Âge: ${user.age}"),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // ---------- EDIT ----------
//                 IconButton(
//                   icon: const Icon(Icons.edit, size: 28, color: Colors.green),
//                   onPressed: () {
//                     showDialog(
//                       context: context,
//                       builder: (context) => AlertDialog(
//                         title: Text("Modifier: ${user.name}"),
//                         content: SingleChildScrollView(
//                           child: Column(
//                             children: [
//                               TextField(
//                                 controller: ctrName,
//                                 style: const TextStyle(
//                                     fontSize: 22, color: Colors.blue),
//                                 decoration: const InputDecoration(
//                                   labelText: 'Nom',
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.all(
//                                         Radius.circular(40)),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 20),
//                               TextField(
//                                 controller: ctrAge,
//                                 keyboardType: TextInputType.number,
//                                 style: const TextStyle(
//                                     fontSize: 22, color: Colors.blue),
//                                 decoration: const InputDecoration(
//                                   labelText: 'Âge',
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.all(
//                                         Radius.circular(40)),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         actions: [
//                           ElevatedButton(
//                             onPressed: () async {
//                               final updatedUser = User(
//                                 id: allusers[index].id,
//                                 name: ctrName.text,
//                                 age: int.parse(ctrAge.text),
//                               );

//                               await updateUser(updatedUser);

//                               setState(() {
//                                 allusers[index] = updatedUser;
//                               });

//                               Navigator.pop(context); // Fermer le dialogue
//                             },
//                             child: const Text("Mettre à jour"),
//                           ),
//                           ElevatedButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             child: const Text('Annuler'),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),

//                 // ---------- DELETE ----------
//                 IconButton(
//                   icon: const Icon(Icons.delete, size: 28, color: Colors.red),
//                   onPressed: () {
//                     showDialog(
//                       context: context,
//                       builder: (content) => AlertDialog(
//                         title: Text(
//                             'Voulez-vous vraiment supprimer ${allusers[index].name}?'),
//                         actions: [
//                           ElevatedButton(
//                             onPressed: () async {
//                               await deleteUser(allusers[index].id);

//                               setState(() {
//                                 allusers.removeAt(index);
//                               });

//                               Navigator.pop(context);
//                             },
//                             child: const Text('Oui'),
//                           ),
//                           ElevatedButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             child: const Text('Annuler'),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
