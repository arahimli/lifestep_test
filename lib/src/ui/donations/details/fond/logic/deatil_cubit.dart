
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/src/models/donation/fonds.dart';
import 'package:lifestep/src/ui/donations/details/fond/logic/details_state.dart';
import 'package:lifestep/src/resources/donation.dart';

class FondDetailsBloc extends  Cubit<FondDetailsState> {

  final DonationRepository donationRepository;
  final FondModel fondModel;
  FondDetailsBloc({required this.fondModel, required this.donationRepository}) : assert(donationRepository != null), super(FondDetailsState(fondModel: fondModel));

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