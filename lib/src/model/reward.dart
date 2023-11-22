import 'package:equatable/equatable.dart';

class Reward extends Equatable {
  final String imagen;
  final String nombre;

  const Reward({required this.imagen, required this.nombre});

  @override
  List<Object> get props => [imagen, nombre];

  factory Reward.fromMap(Map<String, dynamic> data) {
    return Reward(
      imagen: data['image'],
      nombre: data['rewardName'],
    );
  }
}
