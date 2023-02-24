import 'package:equatable/equatable.dart';
import 'package:lifestep/features/main_app/data/models/index/page.dart';

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

  const IndexLoaded({required this.indexPageModel});

  @override
  List<Object> get props => [indexPageModel];
}

class IndexTestLoaded extends IndexState {
  final List value;

  const IndexTestLoaded({required this.value});

  @override
  List<Object> get props => [value];
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
