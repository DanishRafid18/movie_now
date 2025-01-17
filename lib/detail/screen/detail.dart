import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../db/database.dart';
import '../../main.dart';
import '../bloc/detail_bloc.dart';
import '../bloc/detail_event.dart';
import '../bloc/detail_state.dart';

class DetailScreen extends StatefulWidget {
  final int id;
  final String mediaType;

  const DetailScreen({
    Key? key,
    required this.id,
    required this.mediaType,
  }) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  //check if this movie/series is already in the favorites table
  Future<void> _checkIfFavorite() async {
    final favStatus = await dbHelper.isFavorite(widget.id, widget.mediaType);
    setState(() {
      _isFavorite = favStatus;
    });
  }

  //if currently not favorite, insert into DB
  //if already favorite, remove from DB
  Future<void> _toggleFavorite() async {
    if (_isFavorite) {
      //remove from favorites
      final row = await dbHelper.delete(widget.id);
      if (row > 0) {
        setState(() => _isFavorite = false);
      }
    } else {
      //insert into favorites
      final row = {
        DatabaseHelper.columnId: widget.id,
        DatabaseHelper.columnMediaType: widget.mediaType,
      };
      await dbHelper.insert(row);
      setState(() => _isFavorite = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailBloc(context.read()) 
        ..add(FetchDetail(widget.id, widget.mediaType)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detail'),
        ),
        body: BlocBuilder<DetailBloc, DetailState>(
          builder: (context, state) {
            if (state is DetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DetailLoaded) {
              final detail = state.detail;
              final title = widget.mediaType == 'movie'
                  ? detail['title']
                  : detail['name'];
              final posterPath = detail['poster_path'];
              final imageUrl = posterPath != null
                  ? 'https://image.tmdb.org/t/p/w500$posterPath'
                  : null;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (imageUrl != null)
                      Center(
                        child: Image.network(
                          imageUrl,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                    const SizedBox(height: 16),
                    Text(
                      title ?? 'No Title',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(detail['overview'] ?? 'No overview'),
                    const SizedBox(height: 16),
                    if (widget.mediaType == 'movie')
                      Text('Release Date: ${detail['release_date'] ?? 'N/A'}'),
                    if (widget.mediaType == 'tv')
                      Text('First Air Date: ${detail['first_air_date'] ?? 'N/A'}'),
                    const SizedBox(height: 8),
                    Text('Status: ${detail['status'] ?? 'N/A'}'),
                    const SizedBox(height: 8),
                    Text(
                      'Vote Average: ${detail['vote_average']?.toStringAsFixed(1) ?? 'N/A'}',
                    ),

                    const SizedBox(height: 24),
                    Center(
                      child: IconButton(
                        iconSize: 40,
                        icon: Icon(
                          _isFavorite ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: _toggleFavorite,
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is DetailError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
