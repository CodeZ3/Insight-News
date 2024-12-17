class Source {
  String id;
  String name;

  Source({required this.id, required this.name});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json['id'] ?? '', // Provide a default value
      name: json['name'] ?? 'Unknown Source', // Provide a default value
    );
  }

  // Default Source
  static Source defaultSource() {
    return Source(id: '', name: 'Unknown Source');
  }
}