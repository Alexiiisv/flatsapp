import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'functions/FirestoreHelper.dart';

class register extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return registerState();
  }

}

class registerState extends State<register>{
  //Variable
  String nom="";
  String prenom ="";
  String mail="";
  String password="";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Inscription"),
      ),
      body:Container(
        padding: EdgeInsets.all(20),
        child:  bodyPage(),
      )

    );
  }


  Widget bodyPage(){
    return Column(
      children: [
        SizedBox(height: 20,),
        TextField(
          onChanged: (value){
            setState(() {
              mail = value;
            });

          },
          decoration: InputDecoration(
              hintText: "Entrer votre adresse mail",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              )
          ),
        ),
        SizedBox(height: 20,),
        TextField(
          onChanged: (value){
            setState(() {
              password = value;
            });
          },
          obscureText: true,
          decoration: InputDecoration(
              hintText: "Entrer votre mot de passe",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              )
          ),
        ),
        SizedBox(height: 20,),
        TextField(
          onChanged: (value){
            setState(() {
              nom = value;
            });
          },
          decoration: InputDecoration(
              hintText: "Entrer nom",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              )
          ),
        ),
        SizedBox(height: 20,),
        TextField(
          onChanged: (value){
            setState(() {
              prenom = value;
            });
          },
          decoration: InputDecoration(
              hintText: "Entrer prénom",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              )
          ),
        ),
        SizedBox(height: 20,),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.amber,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                )
            ),
            onPressed: (){

              FirestoreHelper().inscription(mail: mail, password: password, prenom: prenom,nom: nom);
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                SystemNavigator.pop();
              }
            },

            child: Text("Inscription")
        ),
      ],
    );
  }

}