import 'package:equatable/equatable.dart';

class News extends Equatable {
  final String id;
  final String title;
  final String description;
  final String image;
  final String date;

  const News({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.date,
  });

  @override
  List<Object> get props => [id, title, description, image, date];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'date': date,
    };
  }

  factory News.fromMap(String id, Map<String, dynamic> data) {
    return News(
      id: id,
      title: data['title'],
      description: data['description'],
      image: data['image'],
      date: data['date'],
    );
  }

  News copyWith({
    String? id,
    String? title,
    String? description,
    String? image,
    String? date,
  }) {
    return News(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      date: date ?? this.date,
    );
  }
}
