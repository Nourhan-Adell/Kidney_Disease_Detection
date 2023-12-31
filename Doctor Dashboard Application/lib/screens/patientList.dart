import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_dashboard/screens/addscreen.dart';
import 'package:doctor_dashboard/screens/patientDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PatientList extends StatefulWidget{

  @override
  _PatientListState createState() => _PatientListState();

}

class _PatientListState extends State<PatientList> {

  DateTime? _dateOfBirth;
  int? _age;


  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('users')
      .where('role', isEqualTo: 'Patient')
      .where('assignedTo', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
      .where('isAssigned', isEqualTo: true)
      .snapshots();

  void _calculateAge() {
    final now = DateTime.now();
    final age = now.year - _dateOfBirth!.year;
    if (now.month < _dateOfBirth!.month ||
        (now.month == _dateOfBirth!.month && now.day < _dateOfBirth!.day)) {
      _age = age - 1;
    } else {
      _age = age;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        actions: [
          IconButton(
              icon: Icon(Icons.add_circle, size: 32),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Addscreen()));
              })
        ],
        title: Text('Patients'),
      ),
      body: StreamBuilder(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("something is wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (_, index) {
                final dobTimestamp = snapshot.data!.docChanges[index].doc['dateOfBirth'] as Timestamp?;
                if (dobTimestamp != null) {
                  _dateOfBirth = dobTimestamp.toDate();
                  _calculateAge();
                }
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) => PatientDetails(
                          docId: snapshot.data!.docChanges[index].doc['uid'],
                          name: snapshot.data!.docChanges[index].doc['name'],
                          email: snapshot.data!.docChanges[index].doc['email'],
                          //age: snapshot.data!.docChanges[index].doc['age'],
                          age: _age.toString(),
                          number: snapshot.data!.docChanges[index].doc['number'],
                          image: snapshot.data!.docChanges[index].doc['imgurl'],
                          gender: snapshot.data!.docChanges[index].doc['gender'],
                          height: snapshot.data!.docChanges[index].doc['height'],
                          weight: snapshot.data!.docChanges[index].doc['weight'],
                          bloodType: snapshot.data!.docChanges[index].doc['bloodGroup'],
                        )));
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        height: 4,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 3,
                          right: 3,
                        ),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          title: Text(
                            snapshot.data!.docChanges[index].doc['email'],
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

