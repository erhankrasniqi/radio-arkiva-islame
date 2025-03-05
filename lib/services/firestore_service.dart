import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:radio_arkiva_islame/data/model.dart';

class FirestoreService {
  final CollectionReference _adsCollection = FirebaseFirestore.instance
      .collection('ads');

  Stream<List<Ad>> getAds() {
    return _adsCollection.snapshots().map(
      (snapshot) =>
          snapshot.docs
              .map((doc) => Ad.fromJson(doc.data() as Map<String, dynamic>))
              .toList(),
    );
  }
}
