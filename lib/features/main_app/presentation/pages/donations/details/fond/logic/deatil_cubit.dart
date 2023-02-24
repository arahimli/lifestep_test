
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/features/main_app/data/models/donation/fonds.dart';
import 'package:lifestep/features/main_app/domain/repositories/donation/repository.dart';
import 'package:lifestep/features/main_app/presentation/pages/donations/details/fond/logic/details_state.dart';

class FondDetailsBloc extends  Cubit<FondDetailsState> {

  final IDonationRepository donationRepository;
  final FondModel fondModel;
  FondDetailsBloc({required this.fondModel, required this.donationRepository}) : super(FondDetailsState(fondModel: fondModel));

  setFond(FondModel fondModel) async{
    fondChanged = true;
    emit(FondDetailsState(fondModel: fondModel));
  }

  bool fondChanged = false;

  bool isLoading = false;
  String searchText = "";
  CancelToken dioToken = CancelToken();

  ScrollController scrollController = ScrollController();





}