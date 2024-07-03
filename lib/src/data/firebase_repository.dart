import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:p15_firestore_repository/src/data/database_repository.dart';
import 'package:p15_firestore_repository/src/domain/drink.dart';


class FirestoreDatabase implements DatabaseRepository {
  final FirebaseFirestore _firebaseFirestore;

  FirestoreDatabase(this._firebaseFirestore);

  @override
  Future<List<Drink>> getDrinks() async {
    final snapshot = await _firebaseFirestore.collection('Drinks').get();
    return snapshot.docs
        .where((doc) => doc.exists)
        .map((doc) => Drink.fromSnapshot(doc))
        .toList();
  }

  @override
  Stream<List<Drink>> drinksStream() {
    return _firebaseFirestore.collection('Drinks').snapshots().map((snapshot) {
      return snapshot.docs
          .where((doc) => doc.exists)
          .map((doc) => Drink.fromSnapshot(doc))
          .toList();
    });
  }

  @override
  Future<void> addDrink(Drink drink) async {
    await _firebaseFirestore
        .collection('Drinks')
        .doc(drink.id.toString())
        .set(drink.toMap());
  }

  @override
  Future<void> removeDrink(int drinkId) async {
    await _firebaseFirestore
        .collection('Drinks')
        .doc(drinkId.toString())
        .delete();
  }
}
