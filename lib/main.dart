import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logpage/register.dart';

import 'dashboard.dart';
import 'functions/FirestoreHelper.dart';

void main() async{
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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String mail="";
  String password ="";

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: const Text("B2_C"),
        backgroundColor: Colors.red,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child:Center(
          child: bodyPage(),
        ) ,
      )
      
    // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


  popUp(){
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Erreur !!!"),
            actions: [
              ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("OK")
              )
            ],
          );
        }
    );
  }

  Widget bodyPage(){
    return Column(

      children: [
        //Afficher un logo
        Container(
          width: 150,
          height: 150,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage("https://voitures.com/wp-content/uploads/2017/06/Kodiaq_079.jpg.jpg"),
            ),

          ),
        ),
        SizedBox(height: 20,),

        //Utilisateur tape son adresse mail
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
        //Utilisateur
        //tape son mot de passe
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
        //Bouton de connexion
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.amber,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
            )
          ),
            onPressed: (){

              print("Je  suis connecté");
              FirestoreHelper().Connect(mail: mail, password: password).then((value){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context){
                      return dashBoard();
                    }
                ));
              }).catchError((error){
                popUp();
              });
            },
            child: Text("Connexion")
        ),
        SizedBox(height: 20,),
        // Lien vers une page Inscription
        InkWell(
          onTap: (){
            print("J'ai appuyé sur l'inscription");
            Navigator.push(context, MaterialPageRoute(
                builder: (context){
                  return register();
                }
            ));
          },
          child: Text("Inscription",style: TextStyle(color: Colors.blue),),
        )


      ],
    );









    //Image.network("https://voitures.com/wp-content/uploads/2017/06/Kodiaq_079.jpg.jpg",);
      
      /*const Text(
        "Je suis un nouveau Widget",
      style: TextStyle(
          color: Colors.yellow,
          fontSize: 35,
      ),
    )*/
    
  }

}
