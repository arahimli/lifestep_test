
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/features/main_app/data/models/donation/charities.dart';
import 'package:lifestep/features/main_app/domain/repositories/donation/repository.dart';
import 'package:lifestep/features/main_app/presentation/pages/donations/details/personal/logic/details_state.dart';

class CharityDetailsBloc extends  Cubit<CharityDetailsState> {

  final IDonationRepository donationRepository;
  final CharityModel charityModel;
  CharityDetailsBloc({required this.charityModel, required this.donationRepository}) : super(CharityDetailsState(charityModel: charityModel));

  setCharity(CharityModel charityModel) async{
    //////// print("setCharity________________________________________");
    charityChanged = true;
    emit(CharityDetailsState(charityModel: charityModel));
  }

  bool charityChanged = false;
  String searchText = "";
  CancelToken dioToken = CancelToken();

  ScrollController scrollController = ScrollController();





}