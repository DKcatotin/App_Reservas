class Status {
  final String code;
  final String label;

  Status({required this.code, required this.label});

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      code: json['code'],
      label: json['label'],
    );
  }
}
