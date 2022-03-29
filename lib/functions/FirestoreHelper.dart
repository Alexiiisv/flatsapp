
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../model/Utilisateur.dart';

class FirestoreHelper{
  //Attributs
  final auth = FirebaseAuth.instance;
  final fire_user = FirebaseFirestore.instance.collection("Utilisateurs");
  final fire_storage = FirebaseStorage.instance;

  //Constructeur

  //Methode
  Future inscription({required String mail, required String password,required String prenom,required String nom}) async{
    UserCredential result = await auth.createUserWithEmailAndPassword(email: mail, password: password);
    User? user = result.user;
    String uid = user!.uid;
    Map<String,dynamic> map ={
      "NOM":nom,
      "MAIL":mail,
      "PRENOM":prenom
    };
    addUser(uid, map);
  }

  Future Connect({required String mail, required String password}) async {
    UserCredential result = await auth.signInWithEmailAndPassword(email: mail, password: password);
  }

  addUser(String uid,Map<String,dynamic> map){
    fire_user.doc(uid).set(map);
  }

  //Récupèrer l'uuid de la partie authentification
  Future <String> getIdentifiant() async{
    String id = auth.currentUser!.uid;
    return id;
  }

  updateUser(String uid,Map<String,dynamic> map) {
    fire_user.doc(uid).update(map);
  }

  //Construire un utilisateur de type utilisateur
  Future <Utilisateur> getUtilisateur(String uid) async{
    DocumentSnapshot snapshot = await fire_user.doc(uid).get();
    return Utilisateur(snapshot);
  }

  Future <String> savePic(String name, Uint8List data) async {
    TaskSnapshot download = await fire_storage.ref("image/$name").putData(data);
    String urlDownload = await download.ref.getDownloadURL();
    return urlDownload;
  }
}