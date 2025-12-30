class Service {
  final String id;
  final String name;
  final int durationMinutes;
  final double price;
  final String category;

  Service({
    required this.id,
    required this.name,
    required this.durationMinutes,
    required this.price,
    required this.category,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] as String,
      name: json['name'] as String,
      durationMinutes: json['duration_minutes'] as int,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
    );
  }

  Duration get duration => Duration(minutes: durationMinutes);

  String get durationLabel {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}