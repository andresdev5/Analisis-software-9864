class Country {
  String? code;
  String? name;

  Country({
    this.code,
    this.name,
  });

  @override
  int get hashCode => code.hashCode;

  @override
  bool operator ==(Object other) => other is Country && other.code == code;

  // to string
  @override
  String toString() => name ?? '';

  static fromJson(data) => Country(
        code: data['code'],
        name: data['name'],
      );

  Map<String, dynamic> toJson() => {
    'code': code,
    'name': name,
  };
}

class City {
  int? id;
  String? code;
  String? name;

  City({
    this.id,
    this.code,
    this.name,
  });

  static fromJson(data) => City(
        id: data['id'],
        code: data['code'],
        name: data['name'],
      );
}
