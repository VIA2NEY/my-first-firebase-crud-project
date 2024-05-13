import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_first_firebase_project/services/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final TextEditingController textcontroller = TextEditingController();

  final FirestoreService firestoreService = FirestoreService();

  // Ouvrir une boite de dialogue pour ajouter une note
  void openNoteDialog ({String? docID}){
  showDialog(
    context: context,

    builder: (context) => AlertDialog(
      content: TextField(
        controller: textcontroller,
      ),

      actions: [
        ElevatedButton(
          child: Text("Ajouter"),
          onPressed: (){
            // Ajout d'une nouvele note
            docID == null ? firestoreService.ajouterNote(textcontroller.text) : firestoreService.updateNote(docID, textcontroller.text);

            // Vider le textfield de ce qui est ecrit 
            textcontroller.clear();

            // Fermer le dialog
            Navigator.pop(context);
          },
        )
      ],

    )
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: firestoreService.getNotesStream(),
          builder: (context, snapshot) {

            // si on a des donnes recuperons tout les docs de la snapshot.
            if (snapshot.hasData) {
              List notesList = snapshot.data!.docs;

              return ListView.builder(
                itemCount: notesList.length,
                itemBuilder: (context, index){

                  // recuperons les documents
                  DocumentSnapshot document = notesList[index];
                  String docID = document.id;

                  // Recuperer le contenue des notes de chaque doc
                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                  String noteText = data['note'];

                  return Card(
                    child: ListTile(
                      title: Text(noteText,style: TextStyle(color: Colors.black),),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.settings),
                            onPressed: (){
                              openNoteDialog(docID:docID);
                            }
                          ),

                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: (){
                              firestoreService.deleteNote(docID);
                            }
                          ),
                        ],
                      ),
                    ),
                  );
                }
              );

            // Si il y'a pas de donnée
            } else {
              return Text("Aucune Notes");
            }
          }
        ),
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: (){
          openNoteDialog(docID: null);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}