import 'package:equatable/equatable.dart';

class UserPoints extends Equatable {
  final int puntos;

  const UserPoints({this.puntos = 0});

  @override
  List<Object> get props => [puntos];

  factory UserPoints.fromMap(Map<String, dynamic> data) {
    return UserPoints(
      puntos: data['puntos'],
    );
  }
}
