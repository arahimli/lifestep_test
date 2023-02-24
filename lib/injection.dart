

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'features/main_app/data/repositories/donation/repository.dart';
import 'features/main_app/data/repositories/home/repository.dart';
import 'features/main_app/presentation/pages/user/repositories/auth.dart';
import 'features/main_app/resources/challenge.dart';
import 'features/main_app/resources/static.dart';
import 'features/main_app/resources/step.dart';


final sl = GetIt.I;  // Service location

Future<void> init() async{

  sl.registerLazySingleton(() => NavigationService());
  sl.registerLazySingleton(() => UserRepository());
  sl.registerLazySingleton(() => DonationRepository());
  sl.registerLazySingleton(() => HomeRepository());
  sl.registerLazySingleton(() => StepRepository());
  sl.registerLazySingleton(() => ChallengeRepository());
  sl.registerLazySingleton(() => StaticRepository());

  // Factory - each time a new instance of the Class

  // Presentation layer
  // sl.registerFactory(
  //         () => ChallengeListCubit(challengeRepository: sl()));

  // Domain layer
  // sl.registerFactory(
  //         () => JokeUseCases(randomJokeRepository: sl()));

  // Data layer
  // sl.registerFactory<IChallengeRepository>(
  //         () => ChallengeRepository());



}


class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
// Future<dynamic> navigateTo(String? routeName) {
//   return navigatorKey.currentState.pushNamed(routeName!);
// }
}