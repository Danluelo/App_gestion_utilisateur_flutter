import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_app/data/user_api.dart';
import 'package:my_app/service/user_api.dart' hide UserApi;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:my_app/model/userModel.dart';
// import 'package:my_app/service/userApi.dart'; // ✅ pour getUserByCode

// 🔹 Page principale (affiche mon QR + bouton scan)
class ScanPage extends StatelessWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mon QR Code")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ✅ Ici tu peux remplacer "pa25" par le code de l'utilisateur connecté
            QrImageView(
              data: "pa25", 
              version: QrVersions.auto,
              size: 220.0,
            ),
            const SizedBox(height: 20),

            // 🔹 Bouton clair pour scanner
            ElevatedButton.icon(
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text("Scanner un utilisateur"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QrCameraPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// 🔹 Page qui ouvre la caméra et détecte le QR
class QrCameraPage extends StatefulWidget {
  const QrCameraPage({super.key});

  @override
  State<QrCameraPage> createState() => _QrCameraPageState();
}

class _QrCameraPageState extends State<QrCameraPage> {
 
  bool _scanned = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scanner un code")),
      body: Stack(
        children: [
          MobileScanner(
            // allowDuplicates: false,
            onDetect: (capture) async {
              if (_scanned) return;
              _scanned = true;

              final code = capture.barcodes.first.rawValue;
              if(code == null) return;
              // debugPrintStack("✅ QR Code détecté: $code");
              setState(() => _isLoading = true);
              await Future.delayed(const Duration(seconds: 2));

              try {
                final user = await UserApi.getUserByCode(code);
                if (!mounted) return;
                setState(() => _isLoading = false);
                showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text("Utilisateur: ${user.name}"),
                content: Column(
                  mainAxisSize: MainAxisSize.min, // pour que le dialog ne soit pas trop grand
                  children: [
                    // Affiche la photo si elle existe
                    user.photoUrl.isNotEmpty
                        ? CircleAvatar(
                            radius: 40,
                            backgroundImage: user.photoUrl.startsWith("http")
                                ? NetworkImage(user.photoUrl)
                                : FileImage(File(user.photoUrl)) as ImageProvider,
                          )
                        : const CircleAvatar(
                            radius: 40,
                            child: Icon(Icons.person, size: 40),
                          ),
                    const SizedBox(height: 10),
                    Text("Code: ${user.code}"),
                    Text("Âge: ${user.age}"),
                  ],
                ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("OK"),
                    ),
                  ],
                ),
              );


              } catch (e) {
                if (!mounted) return;
                setState(() => _isLoading = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Erreur: $e")),
                );
              }
               Future.delayed(const Duration(seconds: 1), () {
                if (mounted) _scanned = false;
              });
            },
          ),
          if (_isLoading)
            Container(
              color: Colors.black45,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.green),
              ),
            ),
        ],
      ),
       
    );
  }
}

// 🔹 Page qui affiche les infos d’un utilisateur scanné
class UserDetailPage extends StatelessWidget {
  final User user;

  const UserDetailPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profil de ${user.name}")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            user.photoUrl.isNotEmpty
                ? CircleAvatar(
                    radius: 50,
                    backgroundImage: user.photoUrl.startsWith("http")
                        ? NetworkImage(user.photoUrl)
                        : FileImage(File(user.photoUrl)) as ImageProvider,
                  )
                : const CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person, size: 50),
                  ),
            const SizedBox(height: 20),
            Text("Nom: ${user.name}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            Text("Âge: ${user.age}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
            Text("Code: ${user.code}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
          ],
        ),
      ),
    );
  }
}
