/// Represents an event in Jastar Hub Community.
class EventModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String category;
  final DateTime date;
  final String location;
  final String city;
  final double? latitude;
  final double? longitude;
  final String organizerId;
  final String organizerName;
  final String organizerAvatar;
  final double price;
  final int attendees;
  final int maxAttendees;
  final bool isFavorite;
  final bool isJoined;
  final List<String> tags;

  const EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.date,
    required this.location,
    this.city = '',
    this.latitude,
    this.longitude,
    this.organizerId = '',
    required this.organizerName,
    this.organizerAvatar = '',
    this.price = 0,
    this.attendees = 0,
    this.maxAttendees = 100,
    this.isFavorite = false,
    this.isJoined = false,
    this.tags = const [],
  });

  bool get isFree => price == 0;
  bool get isFull => attendees >= maxAttendees;
  double get fillPercentage =>
      maxAttendees > 0 ? attendees / maxAttendees : 0;

  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? category,
    DateTime? date,
    String? location,
    String? city,
    double? latitude,
    double? longitude,
    String? organizerId,
    String? organizerName,
    String? organizerAvatar,
    double? price,
    int? attendees,
    int? maxAttendees,
    bool? isFavorite,
    bool? isJoined,
    List<String>? tags,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      date: date ?? this.date,
      location: location ?? this.location,
      city: city ?? this.city,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      organizerId: organizerId ?? this.organizerId,
      organizerName: organizerName ?? this.organizerName,
      organizerAvatar: organizerAvatar ?? this.organizerAvatar,
      price: price ?? this.price,
      attendees: attendees ?? this.attendees,
      maxAttendees: maxAttendees ?? this.maxAttendees,
      isFavorite: isFavorite ?? this.isFavorite,
      isJoined: isJoined ?? this.isJoined,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'date': date.toIso8601String(),
      'location': location,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
      'organizerId': organizerId,
      'organizerName': organizerName,
      'organizerAvatar': organizerAvatar,
      'price': price,
      'attendees': attendees,
      'maxAttendees': maxAttendees,
      'isFavorite': isFavorite,
      'isJoined': isJoined,
      'tags': tags,
    };
  }

  factory EventModel.fromJson(Map<String, dynamic> json) {
    final organizer = json['organizer'] as Map<String, dynamic>?;
    final orgId = organizer?['id'] as String? ?? json['organizerId'] as String? ?? '';
    final orgName = organizer?['name'] as String? ?? json['organizerName'] as String? ?? 'Unknown';
    final orgAvatar = organizer?['avatarUrl'] as String? ?? json['organizerAvatar'] as String? ?? '';

    return EventModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String,
      date: DateTime.parse(json['date'] as String),
      location: json['location'] as String,
      city: json['city'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      organizerId: orgId,
      organizerName: orgName,
      organizerAvatar: orgAvatar,
      price: (json['price'] as num?)?.toDouble() ?? 0,
      attendees: json['attendeesCount'] as int? ?? json['attendees'] as int? ?? 0,
      maxAttendees: json['maxAttendees'] as int? ?? 100,
      isFavorite: json['isFavorite'] as bool? ?? false,
      isJoined: json['isJoined'] as bool? ?? false,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
  }
}
