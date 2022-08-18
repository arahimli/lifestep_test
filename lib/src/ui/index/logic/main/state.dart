import 'package:equatable/equatable.dart';
import 'package:lifestep/src/models/index/page.dart';

abstract class IndexState extends Equatable {
  const IndexState();

  @override
  List<Object> get props => [];
}

class IndexLoading extends IndexState {
  @override
  List<Object> get props => [];
}

class IndexLoaded extends IndexState {
  final IndexPageModel indexPageModel;

  IndexLoaded({required this.indexPageModel});
  @override
  List<Object> get props => [indexPageModel];
}


class IndexError extends IndexState {
  @override
  List<Object> get props => [];
}
class AuthError extends IndexState {
  @override
  List<Object> get props => [];
}

class InternetError extends IndexState {
  @override
  List<Object> get props => [];
}
