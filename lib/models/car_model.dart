class Car {
  final String id;
  final String marca;
  final String modelo;
  final int año;
  Car ({required this.id, required this.marca, required this.modelo, required this.año});
  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'],
      marca: json['marca'], 
      modelo: json['modelo'],
      año: json['año'],
    );
  }
}
