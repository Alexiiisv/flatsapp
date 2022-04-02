import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logpage/functions/FirestoreHelper.dart';
import 'package:logpage/model/Utilisateur.dart';


class MyDrawer extends StatefulWidget{
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyDrawerState();
  }

}

class MyDrawerState extends State<MyDrawer>{
  late Utilisateur monProfil;
  late String uid;
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
              title: const Text("Souhaitez vous utiliser cette image comme pp de profile ?"),
              content: Image.memory(bytesData!),
            );
          }
          else
          {
            return AlertDialog(
              title: const Text("Souhaitez vous utiliser cette image comme pp de profile ?"),
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
                    FirestoreHelper().savePic(fileName, bytesData!).then((String lienImage) {
                      setState(() {
                        urlImage = lienImage;
                      });
                    });
                    Map<String, dynamic> map ={
                      "AVATAR": urlImage,
                    };
                    FirestoreHelper().updateUser(monProfil.id, map);
                    Navigator.pop(context);
                  },
                  child: const Text("Confirmer"),
                ),
              ],
            );
          }},
          );
  }

  importerImage() async{
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
    // TODO: implement build
    FirestoreHelper().getIdentifiant().then((String identifiant) {
      setState(() {
        uid = identifiant;
        FirestoreHelper().getUtilisateur(uid).then((Utilisateur user) {
          setState(() {
            monProfil = user;
          });
        });
      });
    });

    return bodyPage();
  }

  Widget bodyPage(){
    return Container(
      padding: const EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width/2,
      color: Colors.white,
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 60,),
            InkWell(
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: (monProfil.avatar==null)?const NetworkImage("https://voitures.com/wp-content/uploads/2017/06/Kodiaq_079.jpg.jpg"):NetworkImage(monProfil.avatar!),
                    )
                ),
              ),
              onTap: () {
                importerImage();
              },
            ),
            const SizedBox(height: 20,),
            Text("${monProfil.prenom}  ${monProfil.nom}"),
            const SizedBox(height: 20,),
            (monProfil.birthday==null)?Container():Text(monProfil.birthday.toString()),
            const SizedBox(height: 20,),
            Text(monProfil.mail),
          ],
        ),
      ),
    );
  }

}