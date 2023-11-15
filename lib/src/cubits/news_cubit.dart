import 'dart:async';

import 'package:bamx_app/main.dart';
import 'package:bamx_app/src/model/news.dart';
import 'package:bamx_app/src/repository/news_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsCubit extends Cubit<NewsState> {
  final NewsRepository _newsRepository = getIt();
  StreamSubscription? _newsSubscription;

  NewsCubit() : super(const NewsState());

  Future<void> init() async {
    _newsSubscription = _newsRepository.getNews().listen(newsListener);
  }

  void newsListener(Iterable<News> news) {
    emit(NewsState(
      isLoading: false,
      news: news,
    ));
  }

  @override
  Future<void> close() {
    _newsSubscription?.cancel();
    return super.close();
  }
}

class NewsState extends Equatable {
  final bool isLoading;
  final String error;
  final Iterable<News> news;

  const NewsState({
    this.isLoading = true,
    this.error = '',
    this.news = const [],
  });

  @override
  List<Object> get props => [isLoading, error, news];

  NewsState copyWith({
    bool? isLoading,
    String? error,
    Iterable<News>? news,
  }) {
    return NewsState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      news: news ?? this.news,
    );
  }
}
