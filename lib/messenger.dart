import 'package:flutter/material.dart';

import 'functions/FirestoreHelper.dart';
import 'model/Discussion.dart';
import 'model/Utilisateur.dart';

class messenger extends StatefulWidget{
  Utilisateur userReceiver;
  messenger({required Utilisateur this.userReceiver});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return messengerState();
  }

}

class messengerState extends State<messenger>{
  late Utilisateur myUser;
  late String uid;
  Discussion? discussion;

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
            uid = FirestoreHelper().getSameUidDiscussion(myUser, user);
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
          title: Text("${widget.userReceiver.prenom}  ${widget.userReceiver.nom}"),
          centerTitle: true,
        ),
        body: Container(
            child: Center(
              child: bodyPage(),
            )
        )
    );
  }
  Widget bodyPage(){
    return Column(
      children: [
        Text("${discussion?.message}"),
      ],
    );
  }
}