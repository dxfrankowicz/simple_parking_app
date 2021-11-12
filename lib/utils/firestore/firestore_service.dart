import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_parking_app/models/parking_location.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _locationsCollection =
      _firestore.collection('locations');

  static Stream<QuerySnapshot> getStream() {
    return _locationsCollection.snapshots();
  }

  static Future<DocumentReference> addNewParkingLocation(
      ParkingLocationModel parkingLocationModel) async {
    return _locationsCollection.add(parkingLocationModel.toJson());
  }
}
