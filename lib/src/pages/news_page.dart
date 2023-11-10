import 'package:bamx_app/src/components/app_bar.dart';
import 'package:flutter/material.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return NewsPageUI(
      title: arguments['title'],
      description: arguments['description'],
      image: arguments['image'],
    );
  }
}

class NewsPageUI extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  const NewsPageUI({super.key, required this.title, required this.description, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(
              image,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 28),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    ),
    );
  }
}