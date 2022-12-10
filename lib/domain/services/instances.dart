import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseAuth auth = FirebaseAuth.instance;