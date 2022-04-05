// ignore: file_names
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logpage/Library/lib.dart';
import 'package:logpage/functions/FirestoreHelper.dart';

import '../main.dart';
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
                        ? NetworkImage(initialPP)
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
            const SizedBox(height: 200,),
            InkWell(
              child: const SizedBox(
                height: 50,
                width: 50,
                child: Icon(
                  Icons.arrow_back,
                  size: 30,
                ),
              ),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const MyApp()),
                    (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
