import 'dart:typed_data';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logpage/Library/lib.dart';

import 'functions/FirestoreHelper.dart';
import 'model/Utilisateur.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SettingsState();
  }
}

class SettingsState extends State<Settings> {
  late Utilisateur myUser;
  late String uid;
  late Uint8List? bytesData;
  late String fileName;
  late String urlImage;
  String firstName = myProfil.prenom;
  String lastName = myProfil.nom;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Réglages"),
        centerTitle: true,
      ),
      body: Center(
        child: bodyPage(),
      ),
    );
  }

  Widget bodyPage() {
    return Column(
      children: [
        const SizedBox(
          height: 50,
        ),
        SizedBox(
          height: 70,
          width: MediaQuery.of(context).size.width / 2,
          child: const Text(
            "Appuyez sur les éléments que vous souhaitez modifier",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        InkWell(
          child: Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: (myProfil.avatar == null)
                      ? const NetworkImage(
                          "https://voitures.com/wp-content/uploads/2017/06/Kodiaq_079.jpg.jpg")
                      : NetworkImage(myProfil.avatar!),
                )),
          ),
          onTap: () {
            importerImage();
          },
        ),
        const SizedBox(
          height: 30,
        ),
        InkWell(
          child: Text(myProfil.prenom),
          onTap: () {
            changeFirstnameOrLastname("firstName");
          },
        ),
        const SizedBox(
          height: 10,
        ),
        InkWell(
          child: Text(myProfil.nom),
          onTap: () {
            changeFirstnameOrLastname("lastName");
          },
        ),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.66,
          child: DateTimePicker(
            type: DateTimePickerType.date,
            initialValue: (myProfil.birthday == null)
                ? DateTime.now().toString()
                : myProfil.birthday.toString(),
            firstDate: DateTime(1950),
            lastDate: DateTime(DateTime.now().year + 1),
            icon: const Icon(Icons.event),
            dateLabelText: 'Date de naissance',
            onChanged: (val) => setState(() {
              Map<String, dynamic> map = {};
              map = {"BIRTHDAY": DateTime.parse(val)};

              FirestoreHelper().updateUser(myProfil.id, map);
              setState(() {
                myProfil.birthday = Timestamp.fromDate(DateTime.parse(val));
              });
            }),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            FirestoreHelper().deleteUser(myProfil.id);
            Navigator.pop(context);
          },
          child: Text("Supprimer le compte"),
        ),
      ],
    );
  }

  void changeFirstnameOrLastname(String valueToChange) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text((valueToChange == "firstName")
                ? "Modifiez votre prénom"
                : "Modifiez votre nom"),
            content: TextFormField(
              initialValue: (valueToChange == "firstName")
                  ? myProfil.prenom
                  : myProfil.nom,
              onChanged: (value) {
                setState(() {
                  if (valueToChange == "firstName") firstName = value;
                  if (valueToChange == "lastName") lastName = value;
                });
              },
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Annuler",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    Map<String, dynamic> map = {};
                    if (valueToChange == "firstName")
                      map = {
                        "PRENOM": firstName,
                      };
                    if (valueToChange == "lastName")
                      map = {
                        "NOM": lastName,
                      };

                    FirestoreHelper().updateUser(myProfil.id, map);
                    Navigator.pop(context);
                    setState(() {
                      myProfil.prenom = myProfil.toCamelCase(firstName);
                      myProfil.nom = myProfil.toCamelCase(lastName);
                    });
                  });
                },
                child: const Text("Valider"),
              ),
            ],
          );
        });
  }

  void popImage() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        if (Platform.isIOS) {
          return CupertinoAlertDialog(
            title: const Text(
                "Souhaitez vous utiliser cette image comme photo de profile ?"),
            content: Image.memory(bytesData!),
          );
        } else {
          return AlertDialog(
            title: const Text(
                "Souhaitez vous utiliser cette image comme photo de profile ?"),
            content: Image.memory(bytesData!),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Annuler"),
              ),
              ElevatedButton(
                onPressed: () {
                  FirestoreHelper()
                      .savePic(fileName, bytesData!)
                      .then((String lienImage) {
                    setState(() {
                      urlImage = lienImage;
                    });
                  });
                  Map<String, dynamic> map = {
                    "AVATAR": urlImage,
                  };
                  FirestoreHelper().updateUser(myProfil.id, map);
                  Navigator.pop(context);
                  setState(() {
                    myProfil.avatar = urlImage;
                  });
                },
                child: const Text("Confirmer"),
              ),
            ],
          );
        }
      },
    );
  }

  void importerImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.image,
    );
    if (result != null) {
      setState(() {
        bytesData = result.files.first.bytes;
        fileName = result.files.first.name;
      });
    }
    popImage();
  }
}
