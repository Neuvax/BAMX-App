import 'package:equatable/equatable.dart';

class DonacionItem extends Equatable {
  final String name;
  final String image;
  final int puntos;
  final int cantidad;

  const DonacionItem({
    required this.image,
    required this.name,
    required this.puntos,
    required this.cantidad,
  });

  @override
  List<Object> get props => [name, puntos, cantidad];

  factory DonacionItem.fromMap(Map<String, dynamic> data) {
    return DonacionItem(
      image: '', // Placeholder since it's not provided in your structure
      name: data['name'],
      puntos: data['puntos'],
      cantidad: data['cantidad'],
    );
  }
}
