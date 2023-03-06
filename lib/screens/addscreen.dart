import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class Addscreen extends StatefulWidget {
  @override
  _AddscreenState createState() => _AddscreenState();
}

class _AddscreenState extends State<Addscreen> {
  File? image;
  TextEditingController name = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController age = new TextEditingController();
  final ImagePicker picker = ImagePicker();
  final formKey = GlobalKey<FormState>();

  Future pickImage() async {
    final upload = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      image = File(upload!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).accentColor,
          title:
              Text('ADD USER', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: Center(
          child: ListView(children: [
            Card(
              margin: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
              elevation: 20.0,
              child: Form(
                  key: formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        FractionallySizedBox(
                            widthFactor: 0.85,
                            child: Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.02),
                                child: (image == null)
                                    ? Container(
                                        color: Colors.grey[200],
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.25,
                                        child: Center(
                                            child: Text('NO IMAGE SELECTED')))
                                    : Image.file(image!))),
                        FractionallySizedBox(
                            widthFactor: 0.85,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.02),
                              child: TextButton(
                                  onPressed: () {
                                    pickImage();
                                  },
                                  child: Text('SELECT IMAGE FROM GALLERY')),
                            )),
                        FractionallySizedBox(
                          widthFactor: 0.85,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.02),
                            child: TextFormField(
                              controller: name,
                              validator: (value) {
                                if (value!.isEmpty) return 'Required';
                                return null;
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.person),
                                  labelText: 'Name'),
                            ),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 0.85,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.02),
                            child: TextFormField(
                                controller: email,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty) return 'Required';
                                  return null;
                                },
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Email',
                                    prefixIcon: Icon(Icons.email))),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 0.85,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.02),
                            child: TextFormField(
                                controller: age,
                                validator: (value) {
                                  if (value!.isEmpty) return 'Required';
                                  return null;
                                },
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Age',
                                    prefixIcon: Icon(Icons.numbers))),
                          ),
                        ),
                        FractionallySizedBox(
                            widthFactor: 0.85,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * 0.02,
                                  bottom: MediaQuery.of(context).size.height *
                                      0.02),
                              child: Builder(
                                builder: (context) => TextButton(
                                    onPressed: () async {
                                      FormState formstate =
                                          formKey.currentState!;
                                      if (formstate.validate()) {
                                        if (image == null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            duration: Duration(seconds: 1),
                                            backgroundColor:
                                                Theme.of(context).accentColor,
                                            content: Row(
                                              children: [
                                                Icon(Icons.image),
                                                SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.04),
                                                Text('Add user image'),
                                              ],
                                            ),
                                          ));
                                        } else {
                                          final Reference storage =
                                              FirebaseStorage.instance
                                                  .ref()
                                                  .child("${name.text}.jpg");
                                          final UploadTask task =
                                              storage.putFile(image!);
                                          task.then((value) async {
                                            String url =
                                                (await storage.getDownloadURL())
                                                    .toString();
                                            FirebaseFirestore.instance
                                                .collection("users")
                                                .add({
                                              "fullName": name.text,
                                              "email": email.text,
                                              "age": age.text,
                                              "image": url
                                            });
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .accentColor,
                                                  duration:
                                                      Duration(seconds: 1),
                                                  content: Row(children: [
                                                    Icon(Icons.check,
                                                        color: Colors.white),
                                                    SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.04),
                                                    Text(
                                                        'Added a User successfully')
                                                  ])));
                                        }
                                      }
                                    },
                                    child: Text('ADD USER')),
                              ),
                            ))
                      ])),
            ),
          ]),
        ));
  }
}
