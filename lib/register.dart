import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'functions/FirestoreHelper.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RegisterState();
  }
}

class RegisterState extends State<Register> {
  //Variable
  String nom = "";
  String prenom = "";
  String mail = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: const Text("Inscription"),
          centerTitle: true,
        ),
        body: Container(
          child: bodyPage(),
        ));
  }

  Widget bodyPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(
                    "https://firebasestorage.googleapis.com/v0/b/projet1-6f10d.appspot.com/o/image%2Fflatsapp.jpg?alt=media&token=f18b987b-f1e4-491c-84fc-e48dd9e4e236"),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            onChanged: (value) {
              setState(() {
                mail = value;
              });
            },
            decoration: InputDecoration(
                hintText: "Entrez votre adresse mail",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                )),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            onChanged: (value) {
              setState(() {
                password = value;
              });
            },
            obscureText: true,
            decoration: InputDecoration(
                hintText: "Entrez votre mot de passe",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                )),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            onChanged: (value) {
              setState(() {
                nom = value;
              });
            },
            decoration: InputDecoration(
                hintText: "Entrez votre nom",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                )),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(S
            onChanged: (value) {
              setState(() {
                prenom = value;
              });
            },
            decoration: InputDecoration(
                hintText: "Entrez votre prénom",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                )),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.amber,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
              onPressed: () {
                FirestoreHelper().inscription(
                    mail: mail, password: password, prenom: prenom, nom: nom);
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  SystemNavigator.pop();
                }
              },
              child: const Text("Inscription")),
        ],
      ),
    );
  }
}
