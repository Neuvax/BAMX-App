import 'package:bamx_app/src/model/news.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:bamx_app/src/cubits/news_cubit.dart';
import 'package:bamx_app/src/repository/news_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bamx_app/main.dart';

class MockNewsRepository extends Mock implements NewsRepository {}

void main() {
  late MockNewsRepository mockNewsRepository;

  setUp(() async {
    await getIt.reset();
    mockNewsRepository = MockNewsRepository();
    getIt.registerSingleton<NewsRepository>(mockNewsRepository);
  });

  blocTest<NewsCubit, NewsState>(
    'emits state with loading true when init is called',
    build: () {
      when(() => mockNewsRepository.getNews())
          .thenAnswer((_) => Stream.fromIterable([]));
      return NewsCubit();
    },
    act: (cubit) async {
      await cubit.init();
    },
    expect: () => [],
  );

  blocTest<NewsCubit, NewsState>(
    'emits state with news when repository streams news items',
    build: () {
      when(() => mockNewsRepository.getNews())
          .thenAnswer((_) => Stream.fromIterable([
                [
                  const News(
                    id: 'id',
                    title: 'title',
                    description: 'description',
                    image: 'image',
                    date: 'date',
                  )
                ]
              ]));
      return NewsCubit();
    },
    act: (cubit) => cubit.init(),
    expect: () => [
      const NewsState(
        isLoading: false,
        news: [
          News(
            id: 'id',
            title: 'title',
            description: 'description',
            image: 'image',
            date: 'date',
          )
        ],
      )
    ],
  );
}
