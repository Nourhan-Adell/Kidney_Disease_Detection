import 'dart:io';

import 'package:flutter/material.dart';

class PatientDetails extends StatefulWidget {
  final docId, name, email, age, number, image, gender, height, weight, bloodType;

  /*PatientDetails(
      {this.docId, this.name, this.email, this.age, this.number, this.image});
*/

  PatientDetails(
      {this.docId,
      this.name,
      this.email,
      this.age,
      this.number,
      this.image,
      this.gender,
      this.height,
      this.weight,
      this.bloodType});

  @override
  State<PatientDetails> createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<PatientDetails> {
  File? image;
  var email;
  var age;
  var name;
  var number;
  var height;
  var weight;
  var bloodGroup;
  var gender;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name = widget.name;
    email = widget.email;
    age = widget.age;
    number = widget.number;
    height = widget.height;
    weight = widget.weight;
    bloodGroup = widget.bloodType;
    gender = widget.gender;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Patient Information'),
        centerTitle: true,
        //backgroundColor: Colors.grey[850],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: (image == null)
                    ? Image.network(widget.image)
                    : Image.file(image!),
              ),
            ),
            Divider(
              height: 30,
              color: Colors.grey[800],
            ),
            SizedBox(height: 10),
            Container(
              child: Column(
                children: <Widget>[
                  Card(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              ...ListTile.divideTiles(
                                color: Colors.grey,
                                tiles: [
                                  ListTile(
                                    leading:
                                    Icon(Icons.email),
                                    title: Text("Email"),
                                    subtitle: Text(
                                        email!),
                                  ),
                                  ListTile(
                                    leading:
                                    Icon(Icons.phone),
                                    title: Text("Phone"),
                                    subtitle:
                                    Text(number!),
                                  ),
                                  ListTile(
                                    leading:
                                    Icon(Icons.numbers),
                                    title: Text("Age"),
                                    subtitle:
                                    Text(age!),
                                  ),
                                  ListTile(
                                    leading:
                                    Icon(Icons.height),
                                    title: Text("Height"),
                                    subtitle:
                                    Text(height),
                                  ),
                                  ListTile(
                                    leading:
                                    Icon(Icons.line_weight),
                                    title: Text("Weight"),
                                    subtitle:
                                    Text(weight),
                                  ),
                                  ListTile(
                                    leading:
                                    Icon(Icons.bloodtype),
                                    title: Text("Blood Type"),
                                    subtitle:
                                    Text(bloodGroup),
                                  ),
                                  ListTile(
                                    leading:
                                    Icon(Icons.person),
                                    title: Text("Gender"),
                                    subtitle:
                                    Text(gender),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /*Text('Full name: $name',
              style: TextStyle(
                  //color: Colors.blue,
                  //letterSpacing: 2,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Text(
              "Age: $age",
              style: TextStyle(color: Colors.grey, letterSpacing: 2),
            ),
            SizedBox(height: 10),
            Text(
              number,
              style: TextStyle(
                  color: Colors.amberAccent[200],
                  letterSpacing: 2,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Row(
              children: <Widget>[
                Icon(
                  Icons.email,
                  color: Colors.grey[400],
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  email,
                  style: TextStyle(
                      color: Colors.grey[400], fontSize: 18, letterSpacing: 1),
                ),
              ],
            ),*/
          ],
        ),
      ),
    );
  }
}
