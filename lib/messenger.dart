import 'package:flutter/material.dart';

import 'model/Utilisateur.dart';

class messenger extends StatefulWidget{
  Utilisateur user;
  messenger({required Utilisateur this.user});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return messengerState();
  }

}

class messengerState extends State<messenger>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("${widget.user.prenom}  ${widget.user.nom}"),
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

    );
  }
}