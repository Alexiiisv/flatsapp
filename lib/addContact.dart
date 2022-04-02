// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logpage/Library/lib.dart';

import 'detail.dart';
import 'functions/FirestoreHelper.dart';
import 'messenger.dart';
import 'model/Utilisateur.dart';

class AddContact extends StatefulWidget {
  const AddContact({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddContactState();
  }
}


class AddContactState extends State<AddContact> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter des contacts"),
        centerTitle: true,
      ),
      body: bodyPage(),
    );
  }

  Widget bodyPage() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirestoreHelper().fireUser.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            List documents = snapshot.data!.docs;
            return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  Utilisateur user = Utilisateur(documents[index]);
                  if (user.id == myProfil.id) {
                    return Container();
                  }
                  if (FirestoreHelper().getSameUidDiscussion(myProfil, user) !=
                      "") {
                    return Container();
                  }
                  return ListTile(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return Detail(user: user);
                          }));
                    },
                    title: Text(user.prenom),
                    trailing: IconButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return Messenger(userReceiver: user);
                              }));
                        },
                        icon: const Icon(Icons.person_add_rounded)),
                  );
                });
          }
        });
  }
}
