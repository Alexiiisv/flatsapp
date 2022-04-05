import 'package:flutter/material.dart';
import 'package:logpage/Library/constant.dart';
import 'package:logpage/functions/FirestoreHelper.dart';

import 'messenger.dart';
import 'model/Utilisateur.dart';

class Detail extends StatefulWidget {
  Utilisateur user;

  Detail({Key? key, required this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DetailState();
  }
}

class DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("${widget.user.prenom} ${widget.user.nom}"),
          centerTitle: true,
        ),
        body: Center(
          child: bodyPage(),
        ));
  }

  Widget bodyPage() {
    return Column(
      children: [
        const SizedBox(
          height: 50,
        ),
          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: (widget.user.avatar == null)
                      ? NetworkImage(initialPP)
                      : NetworkImage(widget.user.avatar!),
                )),
          ),
        const SizedBox(
          height: 30,
        ),
        Text(
          "${widget.user.prenom} ${widget.user.nom}",
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          "Addresse mail:",
        ),
        Text(widget.user.mail),
        const SizedBox(
          height: 20,
        ),
        const Text(
          "Date de naissance:",
        ),
        Text((widget.user.birthday == null)
            ? "Non renseigné"
            : "${widget.user.birthday!.toDate().day.toString()}-${widget.user.birthday!.toDate().month.toString()}-${widget.user.birthday!.toDate().year.toString()}"),
        const SizedBox(
          height: 20,
        ),
        (FirestoreHelper().getSameUidDiscussion(myProfil, widget.user) == "")
            ? Text("Vous n'avez jamais discuter avec ${widget.user.prenom}")
            : Column(
                children: [
                  Text("Vous avez déjà discuter avec ${widget.user.prenom}"),
                  InkWell(
                    child: const Text(
                      "Voir la discussion",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Messenger(userReceiver: widget.user);
                      }));
                    },
                  )
                ],
              ),
      ],
    );
  }
}
