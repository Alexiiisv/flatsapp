// ignore: file_names
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logpage/Library/lib.dart';
import 'package:logpage/functions/FirestoreHelper.dart';

import '../settings.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyDrawerState();
  }
}

class MyDrawerState extends State<MyDrawer> {
  late Uint8List? bytesData;
  late String fileName;
  late String urlImage;

  popImage() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        if (Platform.isIOS) {
          return CupertinoAlertDialog(
            title: const Text(
                "Souhaitez vous utiliser cette image comme pp de profile ?"),
            content: Image.memory(bytesData!),
          );
        } else {
          return AlertDialog(
            title: const Text(
                "Souhaitez vous utiliser cette image comme pp de profile ?"),
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
                  int count = 0;
                  Navigator.popUntil(context, (route) {
                    return count++ == 3;
                  });
                  FirestoreHelper().updateUser(myProfil.id, map);
                },
                child: const Text("Confirmer"),
              ),
            ],
          );
        }
      },
    );
  }

  importerImage() async {
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

  @override
  Widget build(BuildContext context) {
    return bodyPage();
  }

  Widget bodyPage() {
    return Container(
      padding: const EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width * 0.66,
      color: Colors.white,
      child: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Container(
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
            const SizedBox(
              height: 40,
            ),
            Text(
              "${myProfil.prenom} ${myProfil.nom}",
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            (myProfil.birthday == null)
                ? Container()
                : Text(
                    "${myProfil.birthday!.toDate().day.toString()}-${myProfil.birthday!.toDate().month.toString()}-${myProfil.birthday!.toDate().year.toString()}"),
            const SizedBox(
              height: 20,
            ),
            Text(myProfil.mail),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              child: const SizedBox(
                height: 50,
                width: 50,
                child: Icon(
                  Icons.settings,
                  size: 30,
                ),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const Settings();
                })).then((_) => setState(() {}));
              },
            ),
          ],
        ),
      ),
    );
  }
}
