import 'package:bamx_app/main.dart';
import 'package:bamx_app/src/data-source/firebase_data_source.dart';
import 'package:bamx_app/src/model/news.dart';
import 'package:bamx_app/src/repository/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final FirebaseDataSource _firebaseDataSource = getIt();

  @override
  Stream<Iterable<News>> getNews() {
    return _firebaseDataSource.getNews();
  }
}