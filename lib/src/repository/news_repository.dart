import 'package:bamx_app/src/model/news.dart';

abstract class NewsRepository {
  Stream<Iterable<News>> getNews();
}