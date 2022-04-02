import 'package:cloud_firestore/cloud_firestore.dart';

class Utilisateur {
  //Attributs
  String id = "";
  String prenom = "";
  String nom = "";
  String mail = "";
  Timestamp? birthday;
  String? avatar;
  List messages = [];

  Utilisateur(DocumentSnapshot snapshot) {
    id = snapshot.id;
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    prenom = toCamelCase(map["PRENOM"]);
    nom = toCamelCase(map["NOM"]);
    mail = map["MAIL"];
    birthday = map["BIRTHDAY"];
    avatar = map["AVATAR"];
    messages = map["MESSAGES"];
  }

  String toCamelCase(String str) {
    return str
        .split(" ")
        .map((element) => element[0].toUpperCase() + element.substring(1))
        .join(" ");
  }
}
