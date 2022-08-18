import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/src/tools/components/form/select/selectable/logic/state.dart';



class SelectableSelectCubit extends Cubit<SelectableSelectState> {
  final List<Map<String, dynamic>> dataMap;
  final String initialValue;
  final TextEditingController inputController;
  final Function validateFunction;
  final Function onTap;
  String? value;
  String? confirmedValue;
  bool changed = false;


  setValue(String? value, index) {
    //////// print(value);
    if(dataMap != null) {
      value = value;
      changed = initialValue != value ? true : false;
      List<Map<String, dynamic>> listResult = dataMap.where((map) => value == map["keyword"].toString()).toList();

      //////// print(listResult.length);
      //////// print(changed);
      if(listResult.isNotEmpty) {
        //////// print("listResult.first['display']");
        //////// print(listResult.first['display']);
        emit(SelectableSelectState(value: value,
            confirmedValue: confirmedValue,
            display: listResult.first['display'],
            changed: changed));
      }
    }
  }

  applyValue() async{
    if(state.changed && state.value != null && state.value != '' && validateFunction(state.value, dataMap)){
      emit(SelectableSelectState(confirmedValue: confirmedValue, display: state.display, value: state.value, changed: value != initialValue ? true : false));
      inputController.text = state.display ?? '';
      onTap(state.value);
    }
  }

  SelectableSelectCubit({required this.dataMap, required this.initialValue, required this.inputController, required this.validateFunction, required this.onTap, }) : super(SelectableSelectState(value: initialValue, confirmedValue: initialValue, changed: false)) {
    initialize();
  }

  Future<void> initialize() async {
    if(dataMap != null) {
      List<Map<String, dynamic>> listResult = dataMap.where((map) => initialValue == map["keyword"].toString()).toList();
      if(listResult.isNotEmpty){
        SelectableSelectState(value: initialValue, confirmedValue: initialValue, display: listResult.first['display'],changed: false);
      }
    }
  }
}
