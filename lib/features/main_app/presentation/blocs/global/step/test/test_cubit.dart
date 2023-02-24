import 'package:bloc/bloc.dart';

import 'test_state.dart';

class TestCubit extends Cubit<TestState> {
  TestCubit() : super(TestState().init());
}
