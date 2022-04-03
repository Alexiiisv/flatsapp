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
  final fieldTextemail = TextEditingController();
  final fieldTextpassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
          const Text("Flatsapp"),
          centerTitle: true,
        ),
        body: Center(
          child: bodyPage(),
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
            title: const Text("Erreur de connexion.\nVeuillez vérifier l'adresse mail et le mot de passe."),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Connexion"))
            ],
          );
        });
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
            controller: fieldTextemail,
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
          TextField(
            controller: fieldTextpassword,
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
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.amber,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
              onPressed: () {
                FirestoreHelper()
                    .connect(mail: mail, password: password)
                    .then((value) {
                  setState(() {
                    myProfil = value;
                  });
                  fieldTextemail.clear();
                  fieldTextpassword.clear();
                  mail = "";
                  password = "";
                  Navigator.push(context, MaterialPageRoute(
                      settings: RouteSettings(name: "/connection"),
                      builder: (context) {
                    return const DashBoard();
                  }));
                }).catchError((error) {
                  popUp();
                });
              },
              child: const Text("Connexion")),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const Register();
              }));
            },
            child: const Text(
              "Inscription",
              style: TextStyle(color: Colors.blue),
            ),
          )
        ],
      ),
    );
  }
}
