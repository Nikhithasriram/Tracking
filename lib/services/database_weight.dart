import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracking_app/models/weightclass.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class DatabaseWeights {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addWeights(
      {required double weight,
      required String date,
      required String time,
      required String notes}) async {
    if (_auth.currentUser == null) return;
    await users.doc(_auth.currentUser!.uid).collection('weights').add({
      'uuid': const Uuid().v4(),
      'weight': weight,
      'date': date,
      'time': time,
      'notes': notes,
    });
  }

  //weight list from snapshot
  List<NewWeight> _weightlistfromsnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((weightdoc) {
      return NewWeight(
          weight: weightdoc.get('weight') ?? 0,
          date: weightdoc.get('date') ?? '',
          time: weightdoc.get('time') ?? '',
          notes: weightdoc.get('notes'),
          uuid: weightdoc.get('uuid'));
    }).toList();
  }

  // stream of weights
  Stream<List<NewWeight>> get weights {
    // if (_auth.currentUser == null) return List.empty();

    return users
        .doc(_auth.currentUser!.uid)
        .collection('weights')
        .snapshots()
        .map(_weightlistfromsnapshot);
  }

  Future<void> updatevalue(
      {required String uuid,
      required double weight,
      required String date,
      required String time,
      required String notes}) async {
    final weightcollection =
        users.doc(_auth.currentUser!.uid).collection('weights');
    final weightsnapshot =
        await weightcollection.where('uuid', isEqualTo: uuid).get();
    final documentid = weightsnapshot.docs.first.id;
    await weightcollection.doc(documentid).update({
      'uuid': const Uuid().v4(),
      'weight': weight,
      'date': date,
      'time': time,
      'notes': notes,
    });
  }

  Future<void> delete({required String uuid}) async {
    final weightcollection =
        users.doc(_auth.currentUser!.uid).collection('weights');
    final weightsnapshot =
        await weightcollection.where('uuid', isEqualTo: uuid).get();
    final documentid = weightsnapshot.docs.first.id;
    await weightcollection.doc(documentid).delete();
  }

  Future<NewWeight> docValues({required String uuid}) async {
    final weightcollection =
        users.doc(_auth.currentUser!.uid).collection('weights');
    final weightsnapshot =
        await weightcollection.where('uuid', isEqualTo: uuid).get();

    final documentid = weightsnapshot.docs.first.id;
    final value = await weightcollection.doc(documentid).get();
    return NewWeight(
        weight: value['weight'],
        date: value['date'],
        time: value['time'],
        notes: value['notes'],
        uuid: value['uuid']);
  }
}
