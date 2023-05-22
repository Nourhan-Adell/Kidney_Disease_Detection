import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'addscreen.dart';

class Users extends StatefulWidget {
  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
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
          title: Text('Pending Patients', style: TextStyle(fontWeight: FontWeight.bold))),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("users")
              .where('role', isEqualTo: 'Patient')
              .where('assignedTo', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .where('isAssigned', isEqualTo: false)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      elevation: 5.0,
                      child: Column(
                        children: [
                          Expanded(
                              child: CachedNetworkImage(
                                  imageUrl: snapshot.data.docs[index]
                                      .data()['imgurl'])),
                          ListTile(
                              title: Text(
                                  snapshot.data.docs[index].data()['name']),
                              subtitle: Text(snapshot.data.docs[index]
                                  .data()['email']
                                  .toString()),
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
                                                  title: Text('Decline Item',
                                                      textAlign:
                                                          TextAlign.center),
                                                  content: Text(
                                                      'Are you sure you want to decline this user?'),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          FirebaseFirestore.instance.collection("users").doc(snapshot.data!.docs[index].id)
                                                              .update({'assignedTo': 'NA',
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
                              ))
                        ],
                      ));
                });
          }),
    );
  }
}
