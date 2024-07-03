import 'package:cloud_firestore/cloud_firestore.dart';

class Drink {
  final int id; // ID als int definieren
  final String type;
  final String name;
  final String brand;

  Drink({
    required this.id,
    required this.type,
    required this.name,
    required this.brand,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'brand': brand,
    };
  }

  factory Drink.fromMap(Map<String, dynamic> map) {
    return Drink(
      id: map['id'],
      type: map['type'],
      name: map['name'],
      brand: map['brand'],
    );
  }

  static Drink fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Drink(
      id: data['id'],
      type: data['type'],
      name: data['name'],
      brand: data['brand'],
    );
  }
}
