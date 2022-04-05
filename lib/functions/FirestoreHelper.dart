// ignore: file_names
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logpage/Library/constant.dart';
import 'package:logpage/model/Discussion.dart';
import 'package:nanoid/non_secure.dart';

import '../model/Utilisateur.dart';

class FirestoreHelper {
  //Attributs
  final auth = FirebaseAuth.instance;
  final fireUser = FirebaseFirestore.instance.collection("Utilisateurs");
  final fireDiscussion = FirebaseFirestore.instance.collection("Discussion");
  final fireStorage = FirebaseStorage.instance;

  //Inscription dans l'authentification
  Future inscription(
      {required String mail,
      required String password,
      required String prenom,
      required String nom}) async {
    UserCredential result = await auth.createUserWithEmailAndPassword(
        email: mail, password: password);
    User? user = result.user;
    String uid = user!.uid;
    Map<String, dynamic> map = {
      "NOM": nom,
      "MAIL": mail,
      "PRENOM": prenom,
      "MESSAGES": []
    };
    addUser(uid, map);
  }

  //connection a un compte
  Future<Utilisateur> connect(
      {required String mail, required String password}) async {
    UserCredential result =
        await auth.signInWithEmailAndPassword(email: mail, password: password);
    User? user = result.user;
    String uid = user!.uid;
    return getUtilisateur(uid);
  }

  //ajouter un utilisateur a la base de donnée
  addUser(String uid, Map<String, dynamic> map) {
    fireUser.doc(uid).set(map);
  }

  //Récupèrer l'uid de la partie authentification
  Future<String> getIdentifiant() async {
    String id = auth.currentUser!.uid;
    return id;
  }

  //mettre a jour un utilisateur
  updateUser(String uid, Map<String, dynamic> map) {
    fireUser.doc(uid).update(map);
  }

  //Construire un utilisateur de type utilisateur
  Future<Utilisateur> getUtilisateur(String uid) async {
    DocumentSnapshot snapshot = await fireUser.doc(uid).get();
    return Utilisateur(snapshot);
  }

  //sauvegarder une image dans firebase
  Future<String> savePic(String name, Uint8List data) async {
    TaskSnapshot download = await fireStorage.ref("image/$name").putData(data);
    String urlDownload = await download.ref.getDownloadURL();
    return urlDownload;
  }

  //Recupere l'uid de la discussion entre 2 utilisateurs
  String getSameUidDiscussion(Utilisateur u1, Utilisateur u2) {
    for (String element in u1.messages) {
      if (u2.messages.contains(element)) return element;
    }
    return "";
  }

  //Recupere l'uid de la discussion entre 2 utilisateurs
  String createSameUidDiscussion(Utilisateur u1, Utilisateur u2) {
    if (getSameUidDiscussion(u1, u2) != "") {
      return getSameUidDiscussion(u1, u2);
    }
    var uid = nanoid(15);
    Map<String, dynamic> map = {
      "FLATTER1": u1.id,
      "FLATTER2": u2.id,
      "MESSAGES": ["0${myProfil.prenom} a démarré une conversation!"]
    };
    createDiscussion(uid, map);
    updateUserMessages(uid, u1, u2);

    return uid;
  }

  //update l'information des conversations a laquelle l'utilisateur participe
  updateUserMessages(String uid, Utilisateur u1, Utilisateur u2) {
    List<dynamic> u1mess = u1.messages;
    u1mess.add(uid);

    List<dynamic> u2mess = u2.messages;
    u2mess.add(uid);

    fireUser.doc(u1.id).set(
        {"MESSAGES": u1mess},
        SetOptions(
          merge: true,
        ));

    fireUser.doc(u2.id).set(
        {"MESSAGES": u2mess},
        SetOptions(
          merge: true,
        ));
  }

  //recupérer les informations d'une discussion
  Future<Discussion> getDiscussion(String uid) async {
    DocumentSnapshot snapshot = await fireDiscussion.doc(uid).get();

    return Discussion(snapshot);
  }

  //créer une discussion
  Future createDiscussion(String uid, Map<String, dynamic> map) async {
    fireDiscussion.doc(uid).set(map);
  }

  //envoie le message dans la bdd
  Future sendMessageToDiscussion(Discussion disc, String messages, Utilisateur utilisateur) async {
    if (messages != "") {
      messages = disc.flatter1 == utilisateur.id ? "0" + messages : "1" + messages;

      List<dynamic> mess = disc.message!;
      mess.add(messages);

      fireDiscussion.doc(disc.id).set(
        {"MESSAGES": mess},
        SetOptions(merge: true),
      );
    }
  }

  //delete un utilisateur et toutes les discussions a laquelle il participe
  Future deleteUser(String uid) async {
    List discussions = [];

    for (var element in myProfil.messages) {
      await fireDiscussion.doc(element).get().then((value) => {
            discussions.addAll([
              element,
              value.data()!["FLATTER1"],
              value.data()!["FLATTER2"]
            ]),
          });
    }
    for (int i = 0; i != discussions.length; i = i + 3) {
      //discussions.getRange() == les informations d'une seule discussion
      deleteDiscussionFromUid(discussions.getRange(i, i + 3), uid);
    }
    auth.currentUser!.delete();
    fireUser.doc(uid).delete();
  }

  //delete une discussion par rapport a son uid
  Future deleteDiscussionFromUid(Iterable<dynamic> discussions, String uid) async {
    List discussion = [];
    discussion.addAll(discussions);

    for (var info in discussion) {
      if (info != uid && info != discussion[0]) {
        Utilisateur utilisateur = await getUtilisateur(info);
        utilisateur.messages.remove(discussion[0]);
        updateUser(utilisateur.id, {"MESSAGES": utilisateur.messages});
      }
    }
    fireDiscussion.doc(discussion[0]).delete();
    discussion.clear();
  }

  //delete une discussion entre 2 utilisateurs
  Future deleteDiscussionFromUser(Utilisateur u1, Utilisateur u2) async {
    String uidDiscussion = getSameUidDiscussion(u1, u2);
    fireDiscussion.doc(uidDiscussion).delete();

    u1.messages.remove(uidDiscussion);
    updateUser(u1.id, {"MESSAGES": u1.messages});

    u2.messages.remove(uidDiscussion);
    updateUser(u2.id, {"MESSAGES": u2.messages});
  }
}
