import 'package:equatable/equatable.dart';

class Reward extends Equatable {
  final String imagen;
  final String nombre;
  final String rewardDate;

  const Reward(
      {required this.imagen, required this.nombre, required this.rewardDate});

  @override
  List<Object> get props => [imagen, nombre, rewardDate];

  factory Reward.fromMap(Map<String, dynamic> data) {
    return Reward(
        imagen: data['image'],
        nombre: data['rewardName'],
        rewardDate: data['rewardDate']);
  }
}
