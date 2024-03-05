import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {

  // get collection of notes
  final CollectionReference lesNotes = FirebaseFirestore.instance.collection('notes');

  // Create : ajouter une nouvelle note
  Future<void> ajouterNote(String note){
    return lesNotes.add(
      {
        'note': note,
        'timestamp': Timestamp.now()
        // 'timestamp_create': Timestamp.now()
      }
    );
  }

  // Read : recuperer les notes de la BD
  Stream<QuerySnapshot> getNotesStream (){
    final notesStream = lesNotes.orderBy('timestamp_create', descending: true).snapshots();

    return notesStream;
  }

  // Update : modifier les notes avec un doc-id
  Future<void> updateNote(String docId ,String newNote){
    return lesNotes.doc(docId).update({
      'note' : newNote,
      'timestamp': Timestamp.now()
      // 'timestamp_mod': Timestamp.now(),
    });
  }

  // Delete : supprimer une note grace a son doc-id
  Future<void> deleteNote(String docId){
    return lesNotes.doc(docId).delete();
  }
  
}