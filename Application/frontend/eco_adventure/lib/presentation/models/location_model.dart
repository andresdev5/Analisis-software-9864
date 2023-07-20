class Country {
  String? code;
  String? name;

  Country({
    this.code,
    this.name,
  });

  static fromJson(data) => Country(
    code: data['code'],
    name: data['name'],
  );
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
