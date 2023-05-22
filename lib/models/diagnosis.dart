import 'package:cloud_firestore/cloud_firestore.dart';

class Diagnosis {
  final String diagnosis;
  final String email;
  final Timestamp timestamp;
  final String url;

  const Diagnosis({
    required this.diagnosis,
    required this.email,
    required this.timestamp,
    required this.url,
  });
}