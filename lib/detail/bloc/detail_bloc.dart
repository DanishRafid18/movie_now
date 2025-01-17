import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/fetch_movies.dart';
import 'detail_event.dart';
import 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final FetchMovies fetchMovie;

  DetailBloc(this.fetchMovie) : super(DetailInitial()) {
    on<FetchDetail>(_onFetchDetail);
  }

  Future<void> _onFetchDetail(
      FetchDetail event, Emitter<DetailState> emit) async {
    emit(DetailLoading());
    try {
      if (event.mediaType == 'movie') {
        final movieData = await fetchMovie.fetchMovieDetail(event.id);
        emit(DetailLoaded(movieData));
      } else {
        final tvData = await fetchMovie.fetchTvDetail(event.id);
        emit(DetailLoaded(tvData));
      }
    } catch (e) {
      emit(DetailError(e.toString()));
    }
  }
}
