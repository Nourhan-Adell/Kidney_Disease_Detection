import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_dashboard/screens/patientList.dart';
import 'package:doctor_dashboard/screens/pending_patients.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'doctorList.dart';
import 'history/historyScreen.dart';
import 'login.dart';

var patientCount;
var doctorCount;
var historyCount;
var waitingCount;

class Panel extends StatefulWidget {
  @override
  _PanelState createState() => _PanelState();
}

class _PanelState extends State<Panel> {
  void getDetails() {
    FirebaseFirestore.instance
        .collection("users")
        .where('role', isEqualTo: 'Patient')
        .where('assignedTo', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .where('isAssigned', isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      snapshot.docChanges.forEach((element) {
        setState(() {
          patientCount = snapshot.docs.length;
        });
      });
    });

    FirebaseFirestore.instance
        .collection("users")
        .where('role', isEqualTo: 'Patient')
        .where('assignedTo', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('isAssigned', isEqualTo: false)
        .snapshots()
        .listen((snapshot) {
      snapshot.docChanges.forEach((element) {
        setState(() {
          waitingCount = snapshot.docs.length ?? 0;
        });
      });
    });

    FirebaseFirestore.instance
        .collection("users")
        .where('role', isEqualTo: 'Doctor')
        .snapshots()
        .listen((snapshot) {
      snapshot.docChanges.forEach((element) {
        setState(() {
          doctorCount = snapshot.docs.length ?? 0;
        });
      });
    });

    FirebaseFirestore.instance
        .collection("temp")
        .where('assignedTo', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((snapshot) {
      snapshot.docChanges.forEach((element) {
        setState(() {
          historyCount = snapshot.docs.length ?? 0;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).accentColor,
          title: Text('ADMIN DASHBOARD',
              style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
              onPressed: () {
                logout(context);
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        body: GridView(
          scrollDirection:
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? Axis.vertical
                  : Axis.horizontal,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? 2
                      : 1,
              childAspectRatio:
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? 0.65
                      : 1.75),
          primary: false,
          children: [
            Tile(
                number: "${patientCount.toString()}",
                title: 'PATIENTS',
                page: 'Patients'),
            Tile(
                number: "${doctorCount.toString()}",
                title: 'DOCTORS',
                page: 'Doctors'),
            Tile(
                number: "${historyCount.toString()}",
                title: 'HISTORY',
                page: 'History'),
            Tile(
                number: "${waitingCount.toString()}",
                title: 'PENDING',
                page: 'Pending'),
          ],
        ));
  }

  Future<void> logout(BuildContext context) async {
    CircularProgressIndicator();
    await FirebaseAuth.instance.signOut();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
}

class Tile extends StatefulWidget {
  final number;
  final title;
  final page;

  Tile({this.number, this.title, this.page});

  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 30,
      color: Theme.of(context).accentColor,
      margin: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      child: InkWell(
        onTap: () {
          if (widget.page == 'Patients')
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PatientList()));
          else if (widget.page == 'Doctors') {
            print(FirebaseAuth.instance.currentUser!.uid);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => DoctorList()));
          }
          else if (widget.page == 'History')
            Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryList()));
          else if (widget.page == 'Pending')
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Users()));
        },
        child: Column(children: [
          Expanded(
            child: ListTile(
                title: Text(
              'TAP TO VIEW',
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
            )),
          ),
          Expanded(
              child: FittedBox(
                  fit: BoxFit.fill,
                  child: Text(widget.number,
                      style: TextStyle(color: Colors.white)))),
          Expanded(
            child: ListTile(
                title: Text(
              widget.title,
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            )),
          )
        ]),
      ),
    );
  }
}
