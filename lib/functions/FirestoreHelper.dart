
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logpage/model/Discussion.dart';
import 'package:nanoid/non_secure.dart';


import '../model/Utilisateur.dart';

class FirestoreHelper{
  //Attributs
  final auth = FirebaseAuth.instance;
  final fire_user = FirebaseFirestore.instance.collection("Utilisateurs");
  final fire_discussion = FirebaseFirestore.instance.collection("Discussion");
  final fire_storage = FirebaseStorage.instance;


  //Inscription dans l'authentification
  Future inscription({required String mail, required String password,required String prenom,required String nom}) async{
    UserCredential result = await auth.createUserWithEmailAndPassword(email: mail, password: password);
    User? user = result.user;
    String uid = user!.uid;
    Map<String,dynamic> map ={
      "NOM":nom,
      "MAIL":mail,
      "PRENOM":prenom,
      "MESSAGES":[]
    };
    addUser(uid, map);
  }

  //connection a un compte
  Future Connect({required String mail, required String password}) async {
    UserCredential result = await auth.signInWithEmailAndPassword(email: mail, password: password);
  }

  //ajouter un utilisateur a la base de donnée
  addUser(String uid,Map<String,dynamic> map){
    fire_user.doc(uid).set(map);
  }

  //Récupèrer l'uuid de la partie authentification
  Future <String> getIdentifiant() async{
    String id = auth.currentUser!.uid;
    return id;
  }

  //mettre a jour un utilisateur
  updateUser(String uid,Map<String,dynamic> map) {
    fire_user.doc(uid).update(map);
  }

  //Construire un utilisateur de type utilisateur
  Future <Utilisateur> getUtilisateur(String uid) async{
    DocumentSnapshot snapshot = await fire_user.doc(uid).get();
    return Utilisateur(snapshot);
  }

  //sauvegarder une image dans firebase
  Future <String> savePic(String name, Uint8List data) async {
    TaskSnapshot download = await fire_storage.ref("image/$name").putData(data);
    String urlDownload = await download.ref.getDownloadURL();
    return urlDownload;
  }

  //Recupere l'uid de la discussion entre 2 utilisateurs
  String getSameUidDiscussion(Utilisateur u1, Utilisateur u2) {
    print(u1.messages);
    print(u2.messages);
    for (String element in u1.messages) {
      print(u2.messages.contains(element));
      if (u2.messages.contains(element)) return element;
    }
    var uid = nanoid(15);
    Map<String, dynamic> map = {
      "FLATTER1":u1.id,
      "FLATTER2":u2.id
    };
    createDiscussion(uid, map);
    return "";
  }

  //recupérer les informations d'une discussion
  Future <Discussion> getDiscussion(String uid) async {
    DocumentSnapshot snapshot = await fire_discussion.doc(uid).get();

    return Discussion(snapshot);
  }

  Future createDiscussion(String uid, Map<String, dynamic> map) async {
    fire_discussion.doc(uid).set(map);
  }
}