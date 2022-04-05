import 'package:flutter/material.dart';
import 'package:logpage/Library/constant.dart';

import 'detail.dart';
import 'functions/FirestoreHelper.dart';
import 'model/Discussion.dart';
import 'model/Utilisateur.dart';

class Messenger extends StatefulWidget {
  Utilisateur userReceiver;

  Messenger({Key? key, required this.userReceiver}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MessengerState();
  }
}

class MessengerState extends State<Messenger> {
  late Utilisateur myUser;
  late String uid;
  Discussion? discussion;
  String message = "";
  final fieldText = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirestoreHelper().getIdentifiant().then((String identifiant) {
      setState(() {
        uid = identifiant;
        FirestoreHelper().getUtilisateur(uid).then((Utilisateur user) {
          setState(() {
            myUser = user;
            uid = FirestoreHelper()
                .createSameUidDiscussion(myUser, widget.userReceiver);
            FirestoreHelper().getDiscussion(uid).then((value) {
              setState(() {
                discussion = value;
                FirestoreHelper()
                    .getUtilisateur(myProfil.id)
                    .then((Utilisateur user) {
                  myProfil = user;
                });
              });
            });
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: messengerAppBar(),
        centerTitle: true,
      ),
      body: bodyPage(),
    );
  }

  Widget messengerAppBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: (widget.userReceiver.avatar == null)
                    ? NetworkImage(initialPP)
                    : NetworkImage(widget.userReceiver.avatar!),
              )),
        ),
        const SizedBox(
          width: 20,
        ),
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Detail(user: widget.userReceiver);
            }));
          },
          child:
              Text("${widget.userReceiver.prenom} ${widget.userReceiver.nom}"),
        ),
        const SizedBox(width: 45,)
      ],
    );
  }

  Widget bodyPage() {
    return Stack(children: [
      Container(
        child: ListView.builder(
          itemCount: discussion!.message?.length,
          itemBuilder: (context, index) {
            String message = discussion!.message?[index];
            int indicator = int.parse(message[0]);
            message = message.substring(1, message.length);
            bool isSender =
                (indicator == 1 && myProfil.id == discussion!.flatter2) ||
                    (indicator == 0 && myProfil.id == discussion!.flatter1);

            return Container(
              margin: const EdgeInsets.all(10),
              padding: EdgeInsets.only(
                left: (isSender) ? MediaQuery.of(context).size.width / 5 : 10,
                right:
                    (isSender) ? 10.0 : MediaQuery.of(context).size.width / 5,
                top: 10,
                bottom: 10,
              ),
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.only(
                      bottomLeft: (isSender)
                          ? const Radius.circular(10)
                          : const Radius.circular(0),
                      topLeft: const Radius.circular(10),
                      topRight: const Radius.circular(10),
                      bottomRight: (isSender)
                          ? const Radius.circular(0)
                          : const Radius.circular(10)),
                ),
                child: Text(
                  message,
                ),
                padding: const EdgeInsets.all(10),
              ),
            );
          },
        ),
        margin: const EdgeInsets.only(
          bottom: 80,
        ),
      ),
      Positioned(
        left: 0,
        bottom: 0,
        child: Center(
          child: Container(
              height: 80,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Colors.green,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: fieldText,
                      onChanged: (value) {
                        setState(() {
                          message = value;
                        });
                      },
                      decoration: InputDecoration(
                          hintText: "Entrez votre message...",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                    ),
                  ),
                  const SizedBox(width: 20), // give it width
                  InkWell(
                    onTap: () {
                      FirestoreHelper().sendMessageToDiscussion(
                          discussion!, message, myUser);
                      FirestoreHelper().getDiscussion(uid).then((value) {
                        setState(() {
                          discussion = value;
                        });
                      });
                      fieldText.clear();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      height: 50,
                      width: 50,
                      child: const Center(
                        child: Icon(
                          Icons.send,
                        ),
                      ),
                    ),
                  )
                ],
              )),
        ),
      ),
    ]);
  }
}
