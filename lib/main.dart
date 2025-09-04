// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_app/cubit/user_cubit.dart';
import 'package:my_app/repository/userRepo.dart';
// import 'package:my_app/repository/user_repository.dart';
// import 'package:my_app/presentation/widget/controle_page.dart'; // ou pages/controle_page.dart
import 'package:my_app/screens/constrolPage.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = UserRepository();

    return BlocProvider(
      create: (_) => UserCubit(repo)..fetchUsers(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const ControlePage(),
      ),
    );
  }
}
