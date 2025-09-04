// import 'package:flutter/material.dart';
// import 'package:my_app/model/userModel.dart';
// import 'package:my_app/repository/userRepo.dart';

// class UserAdd extends StatelessWidget {
//   const UserAdd({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final TextEditingController nameController = TextEditingController();
//     final TextEditingController ageController = TextEditingController();

//     return Scaffold(
//       body: Container(
//         margin: const EdgeInsets.all(10),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(height: 20),
//               TextField(
//                 controller: nameController,
//                 decoration: const InputDecoration(
//                   labelText: 'Name',
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: ageController,
//                 decoration: const InputDecoration(
//                   labelText: 'Age',
//                 ),
//                 keyboardType: TextInputType.number,
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () async {
//                   try {
//                     final user = User(name: nameController.text, age: int.parse(ageController.text));
//                     addUser(user);
//                     nameController.clear();
//                     ageController.clear();

//                     print("✅ Utilisateur ajouté : ${user.name}, ${user.age}");
//                   } catch (e) {
//                     print("❌ Erreur lors de l'ajout : $e");
//                   }
//                 },
//                 child: const SizedBox(
//                   width: double.infinity,
//                   child: Icon(Icons.add),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
