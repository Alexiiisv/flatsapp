import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logpage/Library/lib.dart';
import 'package:logpage/register.dart';

import 'dashboard.dart';
import 'functions/FirestoreHelper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String mail = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("B2_C"),
          backgroundColor: Colors.red,
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: bodyPage(),
          ),
        )

        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  popUp() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Erreur !!!"),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"))
            ],
          );
        });
  }

  Widget bodyPage() {
    return Column(
      children: [
        //Afficher un logo
        Container(
          width: 150,
          height: 150,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(
                  "https://voitures.com/wp-content/uploads/2017/06/Kodiaq_079.jpg.jpg"),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),

        //Utilisateur tape son adresse mail
        TextField(
          onChanged: (value) {
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
              )),
        ),
        const SizedBox(
          height: 20,
        ),
        //Utilisateur
        //tape son mot de passe
        TextField(
          onChanged: (value) {
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
              )),
        ),
        const SizedBox(
          height: 20,
        ),
        //Bouton de connexion
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.amber,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
            onPressed: () {
              FirestoreHelper()
                  .Connect(mail: mail, password: password)
                  .then((value) {
                    setState(() {
                      myProfil = value;
                    });
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return dashBoard();
                }));
              }).catchError((error) {
                popUp();
              });
            },
            child: const Text("Connexion")),
        const SizedBox(
          height: 20,
        ),
        // Lien vers une page Inscription
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return register();
            }));
          },
          child: const Text(
            "Inscription",
            style: TextStyle(color: Colors.blue),
          ),
        )
      ],
    );
  }
}
