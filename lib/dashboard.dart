import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logpage/MyWidgets/menuDrawer.dart';

import 'detail.dart';
import 'functions/FirestoreHelper.dart';
import 'model/Utilisateur.dart';

class dashBoard extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return dashBoardState();
  }

}

class dashBoardState extends State<dashBoard>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      drawer: myDrawer(),
      appBar: AppBar(
        title: Text("Connexion"),
        centerTitle: true,
      ),
      body: bodyPage(),
    );
  }
  Widget bodyPage(){
    return StreamBuilder<QuerySnapshot>(
      stream: FirestoreHelper().fire_user.snapshots(),
        builder: (context, snapshot){
        if(!snapshot.hasData){
          return CircularProgressIndicator();
        }
        else
          {
            List documents = snapshot.data!.docs;
            return ListView.builder(
              itemCount: documents.length,
                itemBuilder: (context,index){
                Utilisateur user = Utilisateur(documents[index]);
                  return ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context){
                            return detail(user: user);
                          }
                      ));
                    },
                    title:Text("${user.prenom}"),
                    trailing: IconButton(onPressed: (){}, icon: Icon(Icons.message_outlined)),
                  );



                }
            );
          }
        }
    );
  }
}