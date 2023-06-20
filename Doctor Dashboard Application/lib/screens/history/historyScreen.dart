import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/diagnosis.dart';
import 'diagnosisCard.dart';

class HistoryList extends StatefulWidget {
  const HistoryList({Key? key}) : super(key: key);

  @override
  State<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  final CollectionReference<Map<String, dynamic>> _diagnosisRef =
      FirebaseFirestore.instance.collection('temp');

  late Stream<QuerySnapshot<Map<String, dynamic>>> _diagnosisStream;
  late List<Diagnosis> _diagnoses;

  @override
  void initState() {
    super.initState();
    _diagnosisStream = _diagnosisRef
        .where("assignedTo", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        //.orderBy('timestamp', descending: true)
        .snapshots();
    _diagnoses = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: StreamBuilder(
        stream: _diagnosisStream,
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            _diagnoses = snapshot.data!.docs.map((doc) {
              return Diagnosis(
                diagnosis: doc['diagnosis'],
                email: doc['email'],
                timestamp: doc['time'],
                url: doc['url'],
              );
            }).toList();

            return ListView.builder(
              itemCount: _diagnoses.length,
              itemBuilder: (context, index) {
                final diagnosis = _diagnoses[index];
                return DiagnosisCard(diagnosis: diagnosis);
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
