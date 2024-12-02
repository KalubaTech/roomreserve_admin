import 'package:cloud_firestore/cloud_firestore.dart';

class RoomModel {
  String uid;
  String lodgeID;
  String name;
  bool isBooked;
  List<String> amenities;
  List<String> images;
  String price;

  RoomModel({
    required this.uid,
    required this.name,
    required this.images,
    required this.isBooked,
    required this.amenities,
    required this.lodgeID,
    required this.price,
  });

  // Factory constructor to convert Firestore document to RoomModel
  factory RoomModel.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;

    return RoomModel(
      uid: doc.id,  // Use the document's ID as the uid
      lodgeID: data['lodgeID'] ?? '', // Default to empty string if not available
      name: data['name'] ?? '',
      isBooked: data['isBooked'] ?? false,
      amenities: List<String>.from(data['amenities'] ?? []),  // Convert to List<String> if it's not null
      images: List<String>.from(data['images'] ?? []),  // Convert to List<String> if it's not null
      price: data['price'] ?? '',
    );
  }
}
