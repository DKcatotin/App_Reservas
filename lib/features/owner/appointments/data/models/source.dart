class Source {
  final String type;

  Source({required this.type});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(type: json['type']);
  }
}
