import 'package:equatable/equatable.dart';

abstract class DetailEvent extends Equatable {
  const DetailEvent();

  @override
  List<Object> get props => [];
}

class FetchDetail extends DetailEvent {
  final int id;
  final String mediaType; //"movie" or "tv"

  const FetchDetail(this.id, this.mediaType);

  @override
  List<Object> get props => [id, mediaType];
}
