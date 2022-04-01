import 'package:flutter/material.dart';

import 'functions/FirestoreHelper.dart';
import 'model/Discussion.dart';
import 'model/Utilisateur.dart';

class messenger extends StatefulWidget {
  Utilisateur userReceiver;

  messenger({required Utilisateur this.userReceiver});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return messengerState();
  }
}

class messengerState extends State<messenger> {
  late Utilisateur myUser;
  late String uid;
  Discussion? discussion;
  String message = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirestoreHelper().getIdentifiant().then((String identifiant) {
      setState(() {
        uid = identifiant;
        FirestoreHelper().getUtilisateur(uid).then((Utilisateur user) {
          setState(() {
            myUser = user;
            uid = FirestoreHelper()
                .createSameUidDiscussion(myUser, widget.userReceiver);
            FirestoreHelper().getDiscussion(uid).then((value) {
              setState(() {
                discussion = value;
              });
            });
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title:
            Text("${widget.userReceiver.prenom}  ${widget.userReceiver.nom}"),
        centerTitle: true,
      ),
      body: bodyPage(),
    );
  }

  Widget bodyPage() {
    return Stack(children: [
      ListView(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.only(
                left: 10.0,
                top: 10,
                bottom: 10,
                right: MediaQuery.of(context).size.width / 5),
            width: MediaQuery.of(context).size.width,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: Text("Bonjour"),
              padding: EdgeInsets.all(10),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 5,
                top: 10,
                bottom: 10,
                right: 10.0),
            width: MediaQuery.of(context).size.width,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: Text("Bonjour\nComment allez-vous?"),
              padding: EdgeInsets.all(10),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 5,
                top: 10,
                bottom: 10,
                right: 10.0),
            width: MediaQuery.of(context).size.width,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: Text("Comment vont les enfants?\nToujours en maternelle?"),
              padding: EdgeInsets.all(10),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.only(
                left: 10.0,
                top: 10,
                bottom: 10,
                right: MediaQuery.of(context).size.width / 5),
            width: MediaQuery.of(context).size.width,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: Text(
                  "Ils sont mort.\nDans un accident de voiture.\nHeureusement ils n'ont pas souffert.\nIls sont mort sur le coup"),
              padding: EdgeInsets.all(10),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 5,
                top: 10,
                bottom: 10,
                right: 10.0),
            width: MediaQuery.of(context).size.width,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: Text("Ah zut"),
              padding: const EdgeInsets.all(10),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            padding: EdgeInsets.only(
                left: 10.0,
                top: 10,
                bottom: 10,
                right: MediaQuery.of(context).size.width / 5),
            height: 150,
            width: MediaQuery.of(context).size.width,
            child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            padding: EdgeInsets.only(
                left: 10.0,
                top: 10,
                bottom: 10,
                right: MediaQuery.of(context).size.width / 5),
            height: 150,
            width: MediaQuery.of(context).size.width,
            child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 5,
                top: 10,
                bottom: 10,
                right: 10.0),
            height: 150,
            width: MediaQuery.of(context).size.width,
            child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            padding: EdgeInsets.only(
                left: 10.0,
                top: 10,
                bottom: 10,
                right: MediaQuery.of(context).size.width / 5),
            height: 150,
            width: MediaQuery.of(context).size.width,
            child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 100.0,
          )
        ],
      ),
      Positioned(
        left: 0,
        bottom: 0,
        child: Center(
          child: Container(
              height: 80,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Colors.green,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          message = value;
                        });
                      },
                      decoration: InputDecoration(
                          hintText: "Entrez votre message...",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                    ),
                  ),
                  const SizedBox(width: 20), // give it width
                  InkWell(
                    onTap: () {
                      print("Message envoyé");
                      FirestoreHelper().sendMessageToDiscussion(discussion!, message, myUser);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      height: 50,
                      width: 50,
                      child: const Center(
                        child: Icon(
                          Icons.send,
                        ),
                      ),
                    ),
                  )
                ],
              )),
        ),
      ),
    ]);
  }
}
