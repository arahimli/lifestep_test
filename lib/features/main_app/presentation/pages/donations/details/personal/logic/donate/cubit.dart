import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/features/main_app/domain/repositories/donation/repository.dart';
import 'package:lifestep/features/tools/common/validator.dart';
import 'package:lifestep/features/main_app/data/models/donation/charities.dart';
import 'package:lifestep/features/main_app/presentation/pages/donations/details/personal/logic/donate/state.dart';



class PersonalDonateCubit extends Cubit<PersonalDonateState> {
  final IDonationRepository donationRepository;
  final CharityModel charityModel;

  String? amount = '0';
  String? totalAmount;
  bool checked = false;
  TextEditingController inputController = TextEditingController();
  FormValidator formValidator = FormValidator();
  CancelToken dioToken = CancelToken();


  inputChanged(String value) {
    amount = formValidator.validAmount(value) ? value : amount ?? '0';
    emit(PersonalDonateState(amount: value, isValidAmount: formValidator.validAmount(value) ,checked: state.checked));
  }


  checkboxChanged(bool value) {
    //////// print("checkboxChanged(bool value) {");
    //////// print(value);

    checked = value;
    emit(PersonalDonateState(amount: state.amount, isValidAmount: state.isValidAmount, checked: checked));
  }

  Future<List> submitDonation() async{
      return await donationRepository.donateStepCharity(data: { "charity_id": charityModel.id, 'steps': state.amount, 'in_raiting': !state.checked ? '1' : "0" },token: dioToken);
  }

  PersonalDonateCubit( {required this.donationRepository, required this.charityModel}) : super(PersonalDonateState(amount: '0', checked: false)) {
    initialize();
  }

  Future<void> initialize() async {

  }
}
