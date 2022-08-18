import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lifestep/src/resources/challenge.dart';
import 'package:lifestep/src/ui/user/repositories/auth.dart';
import 'package:lifestep/src/resources/donation.dart';
import 'package:lifestep/src/resources/home.dart';
import 'package:lifestep/src/resources/static.dart';
import 'package:lifestep/src/resources/step.dart';


GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton(() => NavigationService());
  getIt.registerLazySingleton(() => UserRepository());
  getIt.registerLazySingleton(() => DonationRepository());
  getIt.registerLazySingleton(() => HomeRepository());
  getIt.registerLazySingleton(() => StepRepository());
  getIt.registerLazySingleton(() => ChallengeRepository());
  getIt.registerLazySingleton(() => StaticRepository());
}

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  // Future<dynamic> navigateTo(String? routeName) {
  //   return navigatorKey.currentState.pushNamed(routeName!);
  // }
}

