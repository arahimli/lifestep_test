import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lifestep/pages/user/repositories/auth.dart';
import 'package:lifestep/repositories/donation.dart';
import 'package:lifestep/repositories/home.dart';
import 'package:lifestep/repositories/static.dart';
import 'package:lifestep/repositories/step.dart';

GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton(() => NavigationService());
  getIt.registerLazySingleton(() => UserRepository());
  getIt.registerLazySingleton(() => DonationRepository());
  getIt.registerLazySingleton(() => HomeRepository());
  getIt.registerLazySingleton(() => StepRepository());
  getIt.registerLazySingleton(() => StaticRepository());
}

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  // Future<dynamic> navigateTo(String? routeName) {
  //   return navigatorKey.currentState.pushNamed(routeName!);
  // }
}