import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logpage/Library/lib.dart';
import 'package:logpage/MyWidgets/menuDrawer.dart';
import 'package:logpage/addContact.dart';
import 'package:logpage/messenger.dart';

import 'detail.dart';
import 'functions/FirestoreHelper.dart';
import 'model/Utilisateur.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DashBoardState();
  }
}

class DashBoardState extends State<DashBoard> {
  late Utilisateur myUser;
  late String uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text("Mes conversations"),
        centerTitle: true,
      ),
      body: bodyPage(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.group_add,
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const AddContact();
          })).then((_) {
            setState(() {
              FirestoreHelper()
                  .getUtilisateur(myProfil.id)
                  .then((Utilisateur user) {
                myProfil = user;
              });
            });
          });
        },
      ),
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
                  if (FirestoreHelper().getSameUidDiscussion(myProfil, user) ==
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return Messenger(userReceiver: user);
                              }));
                            },
                            icon: const Icon(Icons.message_outlined)),
                        IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                        "Voulez vous supprimer la conversation avec ${user.prenom}?"),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.blue,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "Annuler",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.red,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            FirestoreHelper()
                                                .deleteDiscussionFromUser(
                                                    myProfil, user);
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Valider"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                      ],
                    ),
                  );
                });
          }
        });
  }
}
