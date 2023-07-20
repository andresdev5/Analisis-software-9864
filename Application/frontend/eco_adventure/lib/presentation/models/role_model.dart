class Role {
  int? id;
  String name = "";
  String description = "";

  Role({
    this.id,
    required this.name,
    required this.description,
  });

  static fromJson(data) {
    return Role(
      id: data['id'],
      name: data['name'],
      description: data['description'] ?? '',
    );
  }
}
