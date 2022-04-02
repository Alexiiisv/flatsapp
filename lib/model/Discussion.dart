import 'package:cloud_firestore/cloud_firestore.dart';

class Discussion {
  String id = "";
  String flatter1 = "";
  String flatter2 = "";
  List? message;

  Discussion.vide();

  Discussion(DocumentSnapshot snapshot) {
    id = snapshot.id;
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    flatter1 = map["FLATTER1"];
    flatter2 = map["FLATTER2"];
    message = map["MESSAGES"];

  }
}