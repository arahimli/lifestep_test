import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/src/tools/common/validator.dart';
import 'package:lifestep/src/models/donation/fonds.dart';
import 'package:lifestep/src/ui/donations/details/fond/logic/donate/state.dart';
import 'package:lifestep/src/resources/donation.dart';


class FondDonateCubit extends Cubit<FondDonateState> {
  final IDonationRepository donationRepository;
  final FondModel fondModel;
  String? amount = '0';
  String? totalAmount;
  bool checked = false;
  TextEditingController inputController = TextEditingController();
  FormValidator formValidator = FormValidator();
  CancelToken dioToken = CancelToken();

  inputChanged(String value) {
    amount = formValidator.validAmount(value) ? value : amount ?? '0';
    emit(FondDonateState(amount: value, isValidAmount: formValidator.validAmount(value) ,checked: state.checked));
  }


  checkboxChanged(bool value) {
    //////// print("checkboxChanged(bool value) {");
    //////// print(value);

    checked = value;
    emit(FondDonateState(amount: state.amount, isValidAmount: state.isValidAmount, checked: checked));
  }

  Future<List> submitDonation() async{
    return await donationRepository.donateStepFond(data: { "fund_id": fondModel.id, 'steps': state.amount, 'in_raiting': !state.checked ? '1' : "0" },token: dioToken);
  }


  FondDonateCubit( {required this.donationRepository, required this.fondModel}) : super(FondDonateState(amount: '0', checked: false)) {
    initialize();
  }

  Future<void> initialize() async {

  }
}
