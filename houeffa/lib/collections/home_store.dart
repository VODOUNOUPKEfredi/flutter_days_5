import 'package:cloud_firestore/cloud_firestore.dart';

class HomeService {
  final CollectionReference homeCollection = FirebaseFirestore.instance
      .collection('homes');

  Future<DocumentReference<Object?>> addHome(String imageUrl, double price, String city) async {
    return await homeCollection.add({
      'imageUrl': imageUrl,
      'price': price,
      'city': city,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getHomes() {
    return homeCollection.orderBy('createdAt', descending: true).snapshots();
  }

  Future<void> addSampleHomes() async {
    List<Map<String, dynamic>> sampleHomes = [
      {
        'imageUrl': '',
        'price': 1200.0,
        'city': 'Cotonou',
      },
      {
        'imageUrl': '',
        'price': 900.0,
        'city': 'Porto-Novo',
      },
      {
        'imageUrl': '',
        'price': 1500.0,
        'city': 'Abomey-Calavi',
      },
    ];

    for (var home in sampleHomes) {
      await addHome(home['imageUrl'], home['price'], home['city']);
    }
  }
}
