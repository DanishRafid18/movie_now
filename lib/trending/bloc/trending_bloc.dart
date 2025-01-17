import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import '../../data/fetch_movies.dart';
import 'trending_event.dart';
import 'trending_state.dart';

class TrendingBloc extends Bloc<TrendingEvent, TrendingState> {
  final FetchMovies fetchMovie;

  TrendingBloc(this.fetchMovie) : super(TrendingInitial()) {
    on<FetchTrending>(_onFetchTrending);
  }

  Future<void> _onFetchTrending(
      FetchTrending event, Emitter<TrendingState> emit) async {
    emit(TrendingLoading());

    try {
      final results = await fetchMovie.fetchTrending();
      emit(TrendingLoaded(results));
    } catch (e) {
      emit(TrendingError(e.toString()));
    }
  }
}
