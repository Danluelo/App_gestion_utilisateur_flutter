 import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> updateMessagesWithParticipants() async {
  final CollectionReference messagesRef =
      FirebaseFirestore.instance.collection('messages');

  final QuerySnapshot snapshot = await messagesRef.get();

  for (var doc in snapshot.docs) {
    final data = doc.data() as Map<String, dynamic>;
    final sender = data['senderEmail'] as String?;
    final receiver = data['receiverEmail'] as String?;

    if (sender != null && receiver != null) {
      final participants = [sender, receiver];

      // Mettre à jour uniquement si le champ 'participants' est manquant
      if (data['participants'] == null) {
        await doc.reference.update({'participants': participants});
        print('Message ${doc.id} mis à jour avec participants: $participants');
      }
    }
  }

  print('Tous les messages ont été mis à jour avec le champ participants.');
}
