import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_functions/cloud_functions.dart';

class FirebaseService {
  // TODO: Add methods for CRUD operations, auth, messaging, etc.
  final FirebaseAuth auth = FirebaseAuth.instance;
  static User? get currentUser => FirebaseAuth.instance.currentUser;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FirebaseFunctions functions = FirebaseFunctions.instance;
}
