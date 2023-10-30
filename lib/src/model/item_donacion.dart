import 'package:equatable/equatable.dart';

/// Represents a donation item.
///
/// Each donation item has an [id], [nombre], [imagen], [unidad], and [prioridad].
class ItemDonacion extends Equatable {
  final String id;
  final String nombre;
  final String imagen;
  final String unidad;
  final int prioridad;

  /// Creates a new donation item.
  ///
  /// All parameters are required.
  const ItemDonacion({
    required this.id,
    required this.nombre,
    required this.imagen,
    required this.unidad,
    required this.prioridad,
  });

  @override
  List<Object> get props => [id, nombre, imagen, unidad, prioridad];

  /// Converts the donation item to a map.
  ///
  /// Useful for storing the donation item in a database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'imagen': imagen,
      'unidad': unidad,
      'prioridad': prioridad,
    };
  }

  /// Creates a new donation item from a map.
  ///
  /// Useful for creating a donation item from a database record.
  factory ItemDonacion.fromMap(String id, Map<String, dynamic> data) {
    return ItemDonacion(
      id: id,
      nombre: data['nombre'],
      unidad: data['unidad'],
      imagen: data['imagen'],
      prioridad: data['prioridad'],
    );
  }

  /// Creates a copy of the donation item with the option to replace any of its properties.
  ///
  /// Useful for updating a specific property of the donation item.
  ItemDonacion copyWith({
    String? id,
    String? nombre,
    String? imagen,
    String? unidad,
    int? prioridad,
  }) {
    return ItemDonacion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      imagen: imagen ?? this.imagen,
      unidad: unidad ?? this.unidad,
      prioridad: prioridad ?? this.prioridad,
    );
  }
}