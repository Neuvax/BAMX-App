import 'package:bamx_app/src/cubits/news_cubit.dart';
import 'package:bamx_app/src/routes/routes.dart';
import 'package:bamx_app/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NewsCard extends StatelessWidget {
  final NewsState state;
  const NewsCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListView.builder(
            itemCount: 2,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return const SizedBox(
                width: 250,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0),
                          ),
                          child: SizedBox(
                            height: 130,
                            width: 200,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 4.0),
                          child: SizedBox(
                            height: 14,
                            width: 60,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ));
    } else if (state.news.isEmpty) {
      return const Center(
        child: Column(
          children: [
            Text(
              "🤷🏽‍♂️",
              style: TextStyle(
                fontSize: 64,
              ),
            ),
            Text(
                'No hay nada nuevo por aquí. Vuelve más tarde para ver las últimas noticias.', textAlign: TextAlign.center,),
          ],
        ),
      );
    } else {
      final newsList = state.news.toList();
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: newsList.length,
        itemBuilder: (context, index) => SizedBox(
          width: 250,
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.news,
                arguments: {
                  'title': newsList[index].title,
                  'description': newsList[index].description,
                  'image': newsList[index].image,
                },
              );
            },
            child: Card(
              color: MyColors.background,
              elevation: 1,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4.0),
                      topRight: Radius.circular(4.0),
                    ),
                    child: Image.network(
                      newsList[index].image,
                      height: 130,
                      width: 250,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          newsList[index].title,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          newsList[index].date,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.left,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
