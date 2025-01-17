import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/trending_bloc.dart';
import '../bloc/trending_event.dart';
import '../bloc/trending_state.dart';
import '../../detail/screen/detail.dart';

class TrendingScreen extends StatelessWidget {
  const TrendingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<TrendingBloc>().add(FetchTrending());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trending Movies & TV Shows', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
      ),

      body: BlocBuilder<TrendingBloc, TrendingState>(

        builder: (context, state) {

          if (state is TrendingLoading) {
            return const Center(child: CircularProgressIndicator());
          } 
          
          else if (state is TrendingLoaded) {
            final trendingList = state.trendingList;

            return GridView.builder(

              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // number of items in each row
                mainAxisSpacing: 5.0, // spacing between rows
                crossAxisSpacing: 8.0, // spacing between columns
              ),
              itemCount: trendingList.length,
              itemBuilder: (context, index) {
                final item = trendingList[index];
                //distinguish between movie & tv because Movies use 'title' while TV Shows use 'name' in the API
                String mediaType = item['media_type'];
                String title = mediaType == 'movie' ? item['title'] : item['name'];
                String posterPath = item['poster_path'];

                final imageUrl = posterPath != null
                    ? 'https://image.tmdb.org/t/p/w500$posterPath'
                    : null;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailScreen(
                          id: item['id'],
                          mediaType: mediaType,
                        ),
                      ),);
                  },
                  child: Column(
                    children: [
                      imageUrl != null
                        ? Image.network(
                            imageUrl,
                            width: 100,
                            fit: BoxFit.cover,
                          ): const SizedBox(width: 50, child: Center(child: Text('No Image'))),
                          Text(title, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
                          Text('${item['vote_average'].toStringAsFixed(1)}/10'),
                    ],
                  ),
                ); 
              },
            );
          }
          return Text("Error");
        },
      ),
    );
  }
}
