import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WaitingList extends StatefulWidget {

  @override
  State<WaitingList> createState() => _WaitingListState();
}

class _WaitingListState extends State<WaitingList> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('users')
      .where('role', isEqualTo: 'Patient')
      .where('assignedTo', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .where('isAssigned', isEqualTo: false)
      .snapshots();

  isAssigned(docId) {
    FirebaseFirestore.instance.collection("users").doc(docId).update({
      'assignedTo': FirebaseAuth.instance.currentUser!.uid,
      'isAssigned': true,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .primaryColor,
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .accentColor,
        title: Text('Waiting Patients'),
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
                return GestureDetector(
                  onTap: () {},
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
                          /*onTap:
                              () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PatientDetails(
                                        docId: snapshot.data!.docs[index].id,
                                        */ /*image: snapshot.data!.docChanges[index]
                                            .doc['image'],*/ /*
                                        name: snapshot.data!.docChanges[index]
                                            .doc['name'],
                                        email: snapshot.data!.docChanges[index]
                                            .doc['email'],
                                        age: snapshot.data!.docChanges[index]
                                            .doc['age'])));
                          },*/
                          title: Text(
                            snapshot.data!.docChanges[index].doc['email'],
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          subtitle: Text(
                            snapshot.data!.docChanges[index].doc['name'],
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                            trailing: Container(
                              width: 25,
                              child: PopupMenuButton(
                                onSelected: (dynamic value) {
                                  if (value == "Approve") {
                                    showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                            title: Text('Accept Patient',
                                                textAlign:
                                                TextAlign.center),
                                            content: Text(
                                                'Are you sure you want to accept this patient?'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    //FirebaseFirestore.instance.collection("users").doc(docId).update({
                                                    //       'assignedTo': FirebaseAuth.instance.currentUser!.uid,
                                                    //       'isAssigned': true,
                                                    //     });
                                                    FirebaseFirestore.instance.collection("users").doc(snapshot.data!.docs[index].id)
                                                        .update({'assignedTo': FirebaseAuth.instance.currentUser!.uid,
                                                      'isAssigned': true,});
                                                    Navigator.of(context)
                                                        .pop();
                                                  },
                                                  child: Text('YES')),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop();
                                                  },
                                                  child: Text('NO')),
                                            ]));
                                  }
                                  if (value == "Decline")
                                    showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                            title: Text('Decline Patient',
                                                textAlign:
                                                TextAlign.center),
                                            content: Text(
                                                'Are you sure you want to decline this patient?'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    FirebaseFirestore.instance.collection("users").doc(snapshot.data!.docs[index].id)
                                                        .update({'assignedTo': FirebaseAuth.instance.currentUser!.uid,
                                                      'isAssigned': false,});
                                                    Navigator.of(context)
                                                        .pop();
                                                  },
                                                  child: Text('YES')),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop();
                                                  },
                                                  child: Text('NO')),
                                            ]));
                                },
                                itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                                  const PopupMenuItem<String>(
                                    value: 'Approve',
                                    child: Text('Approve'),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'Decline',
                                    child: Text('Decline'),
                                  ),
                                ],
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
