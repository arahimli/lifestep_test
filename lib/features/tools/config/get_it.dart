import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lifestep/features/main_app/data/repositories/donation/repository.dart';
import 'package:lifestep/features/main_app/data/repositories/home/repository.dart';
import 'package:lifestep/features/main_app/resources/challenge.dart';
import 'package:lifestep/features/main_app/presentation/pages/user/repositories/auth.dart';
import 'package:lifestep/features/main_app/resources/static.dart';
import 'package:lifestep/features/main_app/resources/step.dart';


GetIt sl = GetIt.I..allowReassignment = true;

void setupLocator() {

  sl.registerLazySingleton(() => NavigationService());
  sl.registerLazySingleton(() => UserRepository());
  sl.registerLazySingleton(() => DonationRepository());
  sl.registerLazySingleton(() => HomeRepository());
  sl.registerLazySingleton(() => StepRepository());
  sl.registerLazySingleton(() => ChallengeRepository());
  sl.registerLazySingleton(() => StaticRepository());
}

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  // Future<dynamic> navigateTo(String? routeName) {
  //   return navigatorKey.currentState.pushNamed(routeName!);
  // }
}

