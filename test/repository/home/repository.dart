// import 'package:flutter_test/flutter_test.dart';
// import 'package:lifestep/src/presentation/pages/index/logic/main/cubit.dart';
// import 'package:lifestep/src/presentation/pages/index/logic/main/state.dart';
// import 'package:mockito/mockito.dart';
//
// import 'package:lifestep/src/domain/repositories/home/repository.dart';
//
// class MockIHomeRepository extends Mock implements IHomeRepository{}
//
// void main(){
//   late MockIHomeRepository mockIHomeRepository;
//   setUp((){
//     mockIHomeRepository = MockIHomeRepository();
//   });
//
//   final indexPageModel = [];
//
//   group("slider", (){
//     test('Loaded', () {
//       when(mockIHomeRepository.getSlider()).thenAnswer((_) async => indexPageModel);
//
//       final bloc = IndexCubit(homeRepository: mockIHomeRepository);
//       bloc.initialize();
//       expectLater(bloc, emitsInOrder([
//         IndexLoading(),
//         IndexTestLoaded(value: indexPageModel)
//       ]));
//     });
//   });
// }