import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracking_app/functions/mydatetime.dart';
import 'package:tracking_app/models/weightclass.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class DatabaseWeights {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  final String _sortingtimestamp = "sortingtimestamp";
  final String _uuid = "uuid";
  final String _weight = "weight";
  final String _date = "date";
  final String _time = "time";
  final String _notes = "notes";

  Future<void> addWeights(
      {required double weight,
      required String date,
      required String time,
      required String notes}) async {
    if (_auth.currentUser == null) return;
    await users.doc(_auth.currentUser!.uid).collection('weights').add({
      _uuid: const Uuid().v4(),
      _weight: weight,
      _date: date,
      _time: time,
      _notes: notes,
      _sortingtimestamp: Timestamp.fromDate(mydatetime(date, "1:00 pm")),
    });
  }

  //weight list from snapshot
  List<NewWeight> _weightlistfromsnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((weightdoc) {
      return NewWeight(
          weight: weightdoc.get(_weight) ?? 0,
          date: weightdoc.get(_date) ?? '',
          time: weightdoc.get(_time) ?? '',
          notes: weightdoc.get(_notes),
          uuid: weightdoc.get(_uuid),
          sortingtimestamp: weightdoc.get(_sortingtimestamp));
    }).toList();
  }

  // stream of weights
  Stream<List<NewWeight>> get weights {
    // if (_auth.currentUser == null) return List.empty();

    return users
        .doc(_auth.currentUser!.uid)
        .collection('weights')
        .orderBy(_sortingtimestamp, descending: true)
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
        await weightcollection.where(_uuid, isEqualTo: uuid).get();
    final documentid = weightsnapshot.docs.first.id;
    await weightcollection.doc(documentid).update({
      _uuid: const Uuid().v4(),
      _weight: weight,
      _date: date,
      _time: time,
      _notes: notes,
    });
  }

  Future<void> delete({required String uuid}) async {
    final weightcollection =
        users.doc(_auth.currentUser!.uid).collection('weights');
    final weightsnapshot =
        await weightcollection.where(_uuid, isEqualTo: uuid).get();
    final documentid = weightsnapshot.docs.first.id;
    await weightcollection.doc(documentid).delete();
  }

  Future<NewWeight> docValues({required String uuid}) async {
    final weightcollection =
        users.doc(_auth.currentUser!.uid).collection('weights');
    final weightsnapshot =
        await weightcollection.where(_uuid, isEqualTo: uuid).get();

    final documentid = weightsnapshot.docs.first.id;
    final value = await weightcollection.doc(documentid).get();
    return NewWeight(
        weight: value[_weight],
        date: value[_date],
        time: value[_time],
        notes: value[_notes],
        uuid: value[_uuid],
        sortingtimestamp: value[_sortingtimestamp]);
  }
}
