import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String title;
  final String location;
  final String date;
  final String category;
  final String time;
  final String address;
  final String description;
  final String? imageUrl;
  bool isSaved;
  bool hasReminder;

  Event(
    this.title,
    this.location,
    this.date, {
    required this.category,
    required this.time,
    required this.address,
    required this.description,
    this.imageUrl,
    this.isSaved = false,
    this.hasReminder = false,
  });

  // Factory constructor to create an Event from a Firestore document
  factory Event.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Event(
      data['title'] ?? '',
      data['location'] ?? '',
      data['date'] ?? '',
      category: data['category'] ?? 'Other',
      description: data['description'] ?? '',
      time: data['time'] ?? '',
      address: data['address'] ?? '',
      imageUrl: data['imageUrl'],
      isSaved: data['isSaved'] ?? false,
      hasReminder: data['hasReminder'] ?? false,
    );
  }

  String describe() {
    return "$title at $location on $date";
  }
}

class EventCategories {
  static const String music = 'Music';
  static const String tech = 'Tech';
  static const String food = 'Food';
  static const String art = 'Art';
  static const String sports = 'Sports';
  static const String other = 'Other';

  static List<String> all = [
    music,
    tech,
    food,
    art,
    sports,
    other,
  ];
}