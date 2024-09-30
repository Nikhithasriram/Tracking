import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'package:tracking_app/functions/mydatetime.dart';
// import 'package:tracking_app/models/weightclass.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:uuid/uuid.dart';

class User {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final String appuser = "AppUser";
  final String _name = "name";
  final String _dob = "dob";
  final String _gender = "gender";
  final String _hospital = "hospital";
  final String _doctor = "doctor";

  Future<void> addUser(
      {required String name,
      DateTime? dob,
      String? gender,
      String? hospital,
      String? doctor}) async {
    if (_auth.currentUser != null) {
      final userdata = users.doc(_auth.currentUser!.uid).collection(appuser);
      // final data = await userdata.doc().get();
      userdata.add({
        _name: name,
        _dob: dob,
        _gender: gender,
        _hospital: hospital,
        _doctor: doctor,
      });
    }
  }

  Future<AppUser> appUserinfo() async {
    final usercollection =
        await users.doc(_auth.currentUser!.uid).collection(appuser).get();
    final docs = usercollection.docs.first;
   DateTime? dob;
    if (docs.get(_dob) != null) {
      dob = (docs.get(_dob) as Timestamp).toDate();
    }
    return AppUser(
      name: docs.get(_name) ?? "Default",
      gender: docs.get(_gender) ?? "",
      dob: dob,
      doctor: docs.get(_doctor) ?? "",
      hospital: docs.get(_hospital) ?? "",
    );
  }

  Stream<AppUser> get getuser {
    return users
        .doc(_auth.currentUser!.uid)
        .collection(appuser)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final userDoc = snapshot.docs.first;
        DateTime? dob;
        if (userDoc.get(_dob) != null) {
          dob = (userDoc.get(_dob) as Timestamp).toDate();
        }

        return AppUser(
          name: userDoc.get(_name),
          gender: userDoc.get(_gender) ?? " ",
          dob: dob,
          doctor: userDoc.get(_doctor) ?? "",
          hospital: userDoc.get(_hospital) ?? "",
        );
      } else {
        addUser(name: "Default");
        return AppUser(name: "Default");
      }
    });
  }

  Future<void> updateUser(String? name, DateTime? dob, String? gender,
      String? hospital, String? doctor) async {
    final userdata = users.doc(_auth.currentUser!.uid).collection(appuser);
    final datacollection = await userdata.get();
    final datareference = datacollection.docs.first.reference;
    datareference.update({
      _name: name,
      _dob: dob,
      _gender: gender,
      _hospital: hospital,
      _doctor: doctor,
    });
  }
}

class AppUser {
  final String name;
  DateTime? dob;
  String? gender;
  String? hospital;
  String? doctor;
  AppUser(
      {this.name = "Default",
      this.dob,
      this.gender ="",
      this.hospital ="",
      this.doctor = ""});
}
