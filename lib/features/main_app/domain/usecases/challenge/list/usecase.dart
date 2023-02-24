//
// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:lifestep/features/main_app/domain/entities/challenges/challenge.dart';
// import 'package:lifestep/features/main_app/domain/failures/failures.dart';
// import 'package:lifestep/features/main_app/resources/challenge.dart';
//
// class ChallengeListUseCases{
//   final IChallengeRepository challengeRepository;
//
//   const ChallengeListUseCases({required this.challengeRepository});
//
//   Future<Either<Failure, List<ChallengeEntity>>> getChallenges({required String searchText, required int pageValue, required CancelToken token}) async{
//   await Future.delayed(const Duration(seconds: 1));
//   return challengeRepository.getChallengesDartz(searchText: searchText, pageValue: pageValue, token: dioToken);
//   }
// }