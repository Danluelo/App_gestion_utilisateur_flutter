// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:my_app/model/userModel.dart';
// import 'package:my_app/screens/widgets/usersList.dart';
// // import 'package:my_app/widgets/listusers.dart';

// class AllUsers extends StatefulWidget {
//   const AllUsers({super.key});

//   @override
//   State<AllUsers> createState() => _AllUsersState();
// }

// class _AllUsersState extends State<AllUsers> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Liste des utilisateurs")),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('users')
//             .orderBy('name')
//             .snapshots(),
//         builder: (context, snp) {
//           if (snp.hasError) {
//             return Center(
//               child: Text("❌ Erreur : ${snp.error}"),
//             );
//           }

//           if (snp.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snp.hasData || snp.data!.docs.isEmpty) {
//             return const Center(child: Text("Aucun utilisateur trouvé"));
//           }

//           final allUsers = snp.data!.docs
//               .map((doc) => User.fromJson(doc.data() as Map<String, dynamic>))
//               .toList();

//           return Listusers(users: allUsers); // ✅ utilisation de ton widget
//         },
//       ),
//     );
//   }
// }
