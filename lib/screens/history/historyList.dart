import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'history_details_screen.dart';

class HistoryList extends StatefulWidget {

  @override
  _HistoryListState createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  File? image;
  final ImagePicker picker = ImagePicker();

  final Stream<QuerySnapshot> _historyStream =
  FirebaseFirestore.instance.collection('history').snapshots();

  Future pickImage() async {
    final upload = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      image = File(upload!.path);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        title: Text('History'),
      ),
      body: StreamBuilder(
        stream: _historyStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("something is wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (_, index) {
              List images = snapshot.data!.docChanges[index].doc['images'];
              List diagnosis = snapshot.data!.docChanges[index].doc['diagnosis'];
              print(images);
              int counter = images.length;
              return Card(
                child: ListTile(
                  leading: ClipRRect(
                    child: Image.network(
                      images[--counter],
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                      loadingBuilder: (BuildContext ctx, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                                color: Colors.grey,
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    : null),
                          );
                        }
                      },
                      errorBuilder: (context, object, stackTrace) {
                        return const Icon(Icons.account_circle, size: 50);
                      },
                    ),
                  ),
                  title: Text(
                    snapshot.data!.docChanges[index].doc['email'],
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  subtitle: Text(
                    snapshot.data!.docChanges[index].doc['diagnosis'][0],
                  ),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: (){
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => HistoryDetailsScreen(
                      docId: snapshot.data!.docChanges[index].doc['id'],
                      image: snapshot.data!.docChanges[index].doc['image'],
                      diagnosis: snapshot.data!.docChanges[index].doc['diagnosis'],
                      email: snapshot.data!.docChanges[index].doc['email'],
                      time: snapshot.data!.docChanges[index].doc['time'],
                      list: images,
                    ))
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
