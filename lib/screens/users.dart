import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_dashboard/screens/user_screen.dart';
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
          title: Text('Users', style: TextStyle(fontWeight: FontWeight.bold))),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("users").snapshots(),
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
                          /*Expanded(
                              child: CachedNetworkImage(
                                  imageUrl: snapshot.data.docs[index]
                                      .data()['Image'])),*/
                          ListTile(
                              title: Text(
                                  snapshot.data.docs[index].data()['fullName']),
                              subtitle: Text(snapshot.data.docs[index]
                                  .data()['email']
                                  .toString()),
                              trailing: Container(
                                width: 25,
                                child: PopupMenuButton(
                                  onSelected: (dynamic value) {
                                    if (value == "Edit") {
                                      print(snapshot.data.docs[index]
                                          .data()['image']);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => UserScreen(
                                                  docId: snapshot
                                                      .data.docs[index].id,
                                                  image: snapshot
                                                      .data.docs[index]
                                                      .data()['image'],
                                                  name: snapshot
                                                      .data.docs[index]
                                                      .data()['fullName'],
                                                  email: snapshot
                                                      .data.docs[index]
                                                      .data()['email']
                                                      .toString(),
                                                  age: snapshot.data.docs[index]
                                                      .data()['age'])));
                                    }
                                    if (value == "Delete")
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                                  title: Text('Delete Item',
                                                      textAlign:
                                                          TextAlign.center),
                                                  content: Text(
                                                      'Are you sure you want to delete this user?'),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "users")
                                                              .doc(snapshot
                                                                  .data
                                                                  .docs[index]
                                                                  .id)
                                                              .delete();
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
                                      value: 'Edit',
                                      child: Text('Edit'),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: 'Delete',
                                      child: Text('Delete'),
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
